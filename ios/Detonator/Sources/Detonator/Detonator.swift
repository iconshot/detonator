import Foundation
import WebKit
import UIKit

public class Detonator: NSObject, WKScriptMessageHandler {
    private let filename: String
    
    private var renderer: Renderer!
    
    private var messageListeners: [String: ((String) -> Void)]
    
    private var elementClasses: [String: Element.Type] = [:]
    private var requestClasses: [String: Request.Type] = [:]
    private var moduleClasses: [String: Module.Type] = [:]
    
    private var modules: [String: Module]
    
    private var encoder: JSONEncoder!
    private var decoder: JSONDecoder!
    
    private var webView: WKWebView!
    private var rootView: ViewLayout!
        
    init(rootView: ViewLayout, filename: String) {
        messageListeners = [:]
        
        modules = [:]
        
        self.filename = filename
        
        super.init()
        
        renderer = Renderer(self, rootView)
        
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        
        self.rootView = rootView
        
        setMessageListener("com.iconshot.detonator.request::init") { value in
            let incomingRequest: Request.IncomingRequest = self.decode(value)!
            
            guard let requestClass = self.requestClasses[incomingRequest.name] else {
                return;
            }
            
            let request = requestClass.init(self, incomingRequest: incomingRequest)
            
            request.run()
        }
        
        setMessageListener("com.iconshot.detonator::log") { value in
            let str = String(value.dropFirst().dropLast())
            
            print(str)
        }
        
        setElementClass("com.iconshot.detonator.view", ViewElement.self)
        setElementClass("com.iconshot.detonator.text", TextElement.self)
        setElementClass("com.iconshot.detonator.input", InputElement.self)
        setElementClass("com.iconshot.detonator.textarea", TextAreaElement.self)
        setElementClass("com.iconshot.detonator.image", ImageElement.self)
        setElementClass("com.iconshot.detonator.video", VideoElement.self)
        setElementClass("com.iconshot.detonator.audio", AudioElement.self)
        setElementClass("com.iconshot.detonator.verticalscrollview", VerticalScrollViewElement.self)
        setElementClass("com.iconshot.detonator.horizontalscrollview", HorizontalScrollViewElement.self)
        setElementClass("com.iconshot.detonator.safeareaview", SafeAreaViewElement.self)
        setElementClass("com.iconshot.detonator.icon", IconElement.self)
        setElementClass("com.iconshot.detonator.activityindicator", ActivityIndicatorElement.self)
        
        setRequestClass("com.iconshot.detonator::openUrl", OpenUrlRequest.self)
        setRequestClass("com.iconshot.detonator.input::focus", InputFocusRequest.self)
        setRequestClass("com.iconshot.detonator.input::blur", InputBlurRequest.self)
        setRequestClass("com.iconshot.detonator.input::setValue", InputSetValueRequest.self)
        setRequestClass("com.iconshot.detonator.textarea::focus", TextAreaFocusRequest.self)
        setRequestClass("com.iconshot.detonator.textarea::blur", TextAreaBlurRequest.self)
        setRequestClass("com.iconshot.detonator.textarea::setValue", TextAreaSetValueRequest.self)
        setRequestClass("com.iconshot.detonator.image::getSize", ImageGetSizeRequest.self)
        setRequestClass("com.iconshot.detonator.video::play", VideoPlayRequest.self)
        setRequestClass("com.iconshot.detonator.video::pause", VideoPauseRequest.self)
        setRequestClass("com.iconshot.detonator.video::seek", VideoSeekRequest.self)
        setRequestClass("com.iconshot.detonator.audio::play", AudioPlayRequest.self)
        setRequestClass("com.iconshot.detonator.audio::pause", AudioPauseRequest.self)
        setRequestClass("com.iconshot.detonator.audio::seek", AudioSeekRequest.self)
        
        setModuleClass("com.iconshot.detonator.appstate", AppStateModule.self)
        setModuleClass("com.iconshot.detonator.storage", StorageModule.self)
        setModuleClass("com.iconshot.detonator.fullscreen", FullScreenModule.self)
        setModuleClass("com.iconshot.detonator.stylesheet", StyleSheetModule.self)
        setModuleClass("com.iconshot.detonator.filestream", FileStreamModule.self)
    }
    
    public func initialize() -> Void {
        initWebView()
        
        registerModules()
        
        IconHelper.initialize()
    }
    
    private func initWebView() -> Void {
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
    
    public func getEdge(edgeId: Int) -> Edge? {
        return renderer.edges[edgeId]
    }
    
    public func getMessageListener(_ key: String) -> ((String) -> Void)? {
        return messageListeners[key]
    }
    
    public func setMessageListener(_ key: String, messageListener: @escaping (String) -> Void) -> Void {
        messageListeners[key] = messageListener
    }
    
    public func getElementClass(_ key: String) -> Element.Type? {
        return elementClasses[key]
    }
    
    public func setElementClass(_ key: String, _ elementClass: Element.Type) -> Void {
        elementClasses[key] = elementClass
    }
    
    public func getRequestClass(_ key: String) -> Request.Type? {
        return requestClasses[key]
    }
    
    public func setRequestClass(_ key: String, _ requestClass: Request.Type) -> Void {
        requestClasses[key] = requestClass
    }
    
    public func getModuleClass(_ key: String) -> Module.Type? {
        return moduleClasses[key]
    }
    
    public func setModuleClass(_ key: String, _ moduleClass: Module.Type) -> Void {
        moduleClasses[key] = moduleClass
    }
    
    public func encode(_ data: Encodable) -> String? {
        do {
            let tmpData = try encoder.encode(data)
            
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
    
    public func emit(_ name: String, _ value: String) -> Void {
        let escapedValue = value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
        
        let code = "window.Detonator.emitter.emit(`\(name)`, `\(escapedValue)`);"
        
        evaluate(code: code)
    }
    
    public func emit(_ name: String, _ data: Encodable) -> Void {
        let value = encode(data)!
        
        emit(name, value)
    }
    
    private func registerModules() -> Void {
        for (key, moduleClass) in moduleClasses {
            let module = moduleClass.init(self)
            
            module.register()
            
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
                let pieces = messageString.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
                
                let name = String(pieces[0])
                let value = String(pieces[1])
                
                guard let messageListener = self.messageListeners[name] else {
                    return
                }

                messageListener(value)
            }
        }
    }
}
