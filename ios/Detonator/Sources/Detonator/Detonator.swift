import Foundation
import WebKit
import UIKit

public class Detonator: NSObject, WKScriptMessageHandler {
    private let filename: String
    
    private var renderer: Renderer!
    
    public var messageFormatter: MessageFormatter!
    
    private var eventListeners: [String: ((String) -> Void)] = [:]
    
    private var requestListeners: [String: ((RequestPromise, String, Edge?) -> Void)] = [:]
    
    private var moduleClasses: [String: Module.Type] = [:]
    private var elementClasses: [String: Element.Type] = [:]
    
    private var modules: [String: Module] = [:]
    
    private var encoder: JSONEncoder!
    private var decoder: JSONDecoder!
    
    private var webView: WKWebView!
    private var rootView: ViewLayout!
        
    init(rootView: ViewLayout, filename: String) {
        self.filename = filename
        
        super.init()
        
        renderer = Renderer(self, rootView)
        
        messageFormatter = MessageFormatter(self)
        
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        
        encoder.outputFormatting = [.sortedKeys]
        
        self.rootView = rootView
        
        setEventListener("com.iconshot.detonator.request::fetch") { value in
            let parts = self.messageFormatter.split(value, 4)
            
            let fetchId = Int(parts[0])!
            let edgeId = parts[1] != "-" ? Int(parts[1]) : nil
            let name = parts[2]
            let dataValue = parts[3]
            
            let promise = RequestPromise(self, fetchId)
            
            var edge: Edge? = nil
            
            if let edgeId = edgeId {
                edge = self.getEdge(edgeId)
                
                if let element = edge!.element {
                    let elementRequestListener = element.getRequestListener(name)
                    
                    if let elementRequestListener = elementRequestListener {
                        
                        elementRequestListener(promise, dataValue)
                        
                        return
                    }
                }
            }
            
            let requestListener = self.requestListeners[name]
            
            guard let requestListener = requestListener else {
                promise.reject("No request listener found for \"\(name)\".")
                
                return
            }
            
            requestListener(promise, dataValue, edge)
        }
        
        setModuleClass("com.iconshot.detonator.ui", UIModule.self)
        setModuleClass("com.iconshot.detonator.utility", UtilityModule.self)
        setModuleClass("com.iconshot.detonator.appstate", AppStateModule.self)
        setModuleClass("com.iconshot.detonator.storage", StorageModule.self)
        setModuleClass("com.iconshot.detonator.fullscreen", FullScreenModule.self)
        setModuleClass("com.iconshot.detonator.stylesheet", StyleSheetModule.self)
        setModuleClass("com.iconshot.detonator.filestream", FileStreamModule.self)
    }
    
    public func initialize() -> Void {
        initializeWebView()
        
        initializeModules()
        
        IconHelper.initialize()
    }
    
    private func initializeWebView() -> Void {
        let contentController = WKUserContentController()
        
        contentController.add(self, name: "DetonatorBridge")
        
        let config = WKWebViewConfiguration()
        
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        
        webView.layoutParams.display = .none
        
        rootView.addSubview(webView)
        
        evaluate(code: "window.__detonator_platform = \"ios\"")
        
        let code = readIndexFile()
        
        evaluate(code: code)
    }
    
    public func getEdge(_ edgeId: Int) -> Edge? {
        return renderer.edges[edgeId]
    }
    
    public func setEventListener(_ key: String, eventListener: @escaping (String) -> Void) -> Void {
        eventListeners[key] = eventListener
    }
    
    public func setRequestListener(_ key: String, requestListener: @escaping (RequestPromise, String, Edge?) -> Void) -> Void {
        requestListeners[key] = requestListener
    }
    
    public func setModuleClass(_ key: String, _ moduleClass: Module.Type) -> Void {
        moduleClasses[key] = moduleClass
    }
    
    public func getElementClass(_ key: String) -> Element.Type? {
        return elementClasses[key]
    }
    
    public func setElementClass(_ key: String, _ elementClass: Element.Type) -> Void {
        elementClasses[key] = elementClass
    }
    
    public func encode(_ data: Encodable?) -> String? {
        if data == nil {
            return "null"
        }

        do {
            let tmpData = try encoder.encode(data!)
            
            let value = String(data: tmpData, encoding: .utf8)
            
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: Decodable>(_ value: String) -> T? {
        guard let tmpData = value.data(using: .utf8) else {
            return nil
        }
        
        return try? decoder.decode(T.self, from: tmpData)
    }
    
    private func readIndexFile() -> String {
        if let path = Bundle.main.path(forResource: filename, ofType: "js") {
            do {
                let code = try String(contentsOfFile: path, encoding: .utf8)
                
                return code;
            } catch {}
        }
        
        return "";
    }
    
    private func evaluate(code: String, completion: ((Any?, Error?) -> Void)? = nil) -> Void {
        webView.evaluateJavaScript(code, completionHandler: completion)
    }
    
    public func send(_ name: String, _ data: Encodable? = "") -> Void {
        let lines: [Encodable?] = [data]
        
        send(name, lines)
    }
    
    private func send(_ name: String, _ lines: [Encodable?]) {
        let value = messageFormatter.join(lines)
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
        
        let code = "window.Detonator.emitter.emit(`\(name)`, `\(value)`);"
        
        evaluate(code: code)
    }
    
    private func initializeModules() -> Void {
        for (key, moduleClass) in moduleClasses {
            let module = moduleClass.init(self)
            
            module.setUp()
            
            modules[key] = module
        }
    }
    
    public func performLayout() -> Void {
        renderer.performLayout()
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        /*
         
         why the asyncAfter?
         
         the userContentController is an asynchronous operation
         
         if we perform regular UI operations here (mount, rerender, etc),
         it could interfere with ongoing layout processes
         
         for example, we've observed that when adding a TextAreaView with an initial value,
         the view's scroll position is often set to the end, which is not the desired behavior...
         this issue is resolved by using asyncAfter
         
         */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if message.name == "DetonatorBridge", let messageString = message.body as? String {
                let pieces = self.messageFormatter.split(messageString, 2)
                
                let name = pieces[0]
                let value = pieces[1]
                
                guard let eventListener = self.eventListeners[name] else {
                    return
                }

                eventListener(value)
            }
        }
    }
}
