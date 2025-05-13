import Foundation
import WebKit
import UIKit

public class Detonator: NSObject, WKScriptMessageHandler {
    private let filename: String
    
    private var renderer: Renderer!
    
    private var messageHandlers: [String: ((String) -> Void)]
    
    private var elementClasses: [String: Element.Type]
    private var requestClasses: [String: Request.Type]
    private var moduleClasses: [String: Module.Type]
    
    private var modules: [String: Module]
    
    private var handlerEmitter: HandlerEmitter!
    private var eventEmitter: EventEmitter!
    
    private var encoder: JSONEncoder!
    private var decoder: JSONDecoder!
    
    private var webView: WKWebView!
    private var rootView: ViewLayout!
        
    init(rootView: ViewLayout, filename: String) {
        messageHandlers = [:]
        
        elementClasses = [:]
        requestClasses = [:]
        moduleClasses = [:]
        
        modules = [:]
        
        self.filename = filename
        
        super.init()
        
        handlerEmitter = HandlerEmitter(self)
        eventEmitter = EventEmitter(self)
        
        renderer = Renderer(self, rootView)
        
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        
        self.rootView = rootView
        
        addMessageHandler(key: "com.iconshot.detonator/request") { dataString in
            let incomingRequest: Request.IncomingRequest = self.decode(dataString)!
            
            guard let requestClass = self.requestClasses[incomingRequest.name] else {
                return;
            }
            
            let request = requestClass.init(self, incomingRequest: incomingRequest)
            
            request.run()
        }
        
        addMessageHandler(key: "com.iconshot.detonator/log") { dataString in
            let str = String(dataString.dropFirst().dropLast())
            
            print(str)
        }
        
        addElementClass(key: "com.iconshot.detonator.view", elementClass: ViewElement.self)
        addElementClass(key: "com.iconshot.detonator.text", elementClass: TextElement.self)
        addElementClass(key: "com.iconshot.detonator.input", elementClass: InputElement.self)
        addElementClass(key: "com.iconshot.detonator.textarea", elementClass: TextAreaElement.self)
        addElementClass(key: "com.iconshot.detonator.image", elementClass: ImageElement.self)
        addElementClass(key: "com.iconshot.detonator.video", elementClass: VideoElement.self)
        addElementClass(key: "com.iconshot.detonator.audio", elementClass: AudioElement.self)
        addElementClass(key: "com.iconshot.detonator.verticalscrollview", elementClass: VerticalScrollViewElement.self)
        addElementClass(key: "com.iconshot.detonator.horizontalscrollview", elementClass: HorizontalScrollViewElement.self)
        addElementClass(key: "com.iconshot.detonator.safeareaview", elementClass: SafeAreaViewElement.self)
        addElementClass(key: "com.iconshot.detonator.icon", elementClass: IconElement.self)
        addElementClass(key: "com.iconshot.detonator.activityindicator", elementClass: ActivityIndicatorElement.self)
        
        addRequestClass(key: "com.iconshot.detonator/openUrl", requestClass: OpenUrlRequest.self)
        addRequestClass(key: "com.iconshot.detonator.input/focus", requestClass: InputFocusRequest.self)
        addRequestClass(key: "com.iconshot.detonator.input/blur", requestClass: InputBlurRequest.self)
        addRequestClass(key: "com.iconshot.detonator.input/setValue", requestClass: InputSetValueRequest.self)
        addRequestClass(key: "com.iconshot.detonator.textarea/focus", requestClass: TextAreaFocusRequest.self)
        addRequestClass(key: "com.iconshot.detonator.textarea/blur", requestClass: TextAreaBlurRequest.self)
        addRequestClass(key: "com.iconshot.detonator.textarea/setValue", requestClass: TextAreaSetValueRequest.self)
        addRequestClass(key: "com.iconshot.detonator.image/getSize", requestClass: ImageGetSizeRequest.self)
        addRequestClass(key: "com.iconshot.detonator.video/play", requestClass: VideoPlayRequest.self)
        addRequestClass(key: "com.iconshot.detonator.video/pause", requestClass: VideoPauseRequest.self)
        addRequestClass(key: "com.iconshot.detonator.video/seek", requestClass: VideoSeekRequest.self)
        addRequestClass(key: "com.iconshot.detonator.audio/play", requestClass: AudioPlayRequest.self)
        addRequestClass(key: "com.iconshot.detonator.audio/pause", requestClass: AudioPauseRequest.self)
        addRequestClass(key: "com.iconshot.detonator.audio/seek", requestClass: AudioSeekRequest.self)
        
        addModuleClass(key: "com.iconshot.detonator.appstate", moduleClass: AppStateModule.self)
        addModuleClass(key: "com.iconshot.detonator.storage", moduleClass: StorageModule.self)
        addModuleClass(key: "com.iconshot.detonator.fullscreen", moduleClass: FullScreenModule.self)
        addModuleClass(key: "com.iconshot.detonator.stylesheet", moduleClass: StyleSheetModule.self)
        
        initWebView()
        
        collectModuleClasses()
        
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
    
    func decode<T: Decodable>(_ data: String) -> T? {
        guard let jsonData = data.data(using: .utf8) else {
            return nil
        }
        
        return try? decoder.decode(T.self, from: jsonData)
    }
    
    public func getEdge(edgeId: Int) -> Edge? {
        return renderer.edges[edgeId]
    }
    
    public func getMessageHandler(key: String) -> ((String) -> Void)? {
        return messageHandlers[key]
    }
    
    public func addMessageHandler(key: String, messageHandler: @escaping (String) -> Void) -> Void {
        messageHandlers[key] = messageHandler
    }
    
    public func getElementClass(key: String) -> Element.Type? {
        return elementClasses[key]
    }
    
    public func addElementClass(key: String, elementClass: Element.Type) -> Void {
        elementClasses[key] = elementClass
    }
    
    public func getRequestClass(key: String) -> Request.Type? {
        return requestClasses[key]
    }
    
    public func addRequestClass(key: String, requestClass: Request.Type) -> Void {
        requestClasses[key] = requestClass
    }
    
    public func getModuleClass(key: String) -> Module.Type? {
        return moduleClasses[key]
    }
    
    public func addModuleClass(key: String, moduleClass: Module.Type) -> Void {
        moduleClasses[key] = moduleClass
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
    
    public func emit(name: String, value: Encodable) -> Void {
        do {
            let data = try encoder.encode(value)
            
            if let json = String(data: data, encoding: .utf8) {
                let escape = json
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                
                let code = "window.Detonator.emitter.emit(\"\(name)\", \"\(escape)\");"
                
                evaluate(code: code)
            }
        } catch {}
    }
    
    public func emitHandler(name: String, edgeId: Int, data: Encodable? = nil) -> Void {
        handlerEmitter.emit(name: name, edgeId: edgeId, data: data)
    }
    
    public func emitEvent(name: String, data: Encodable? = nil) -> Void {
        eventEmitter.emit(name: name, data: data)
    }
    
    private func collectModuleClasses() -> Void {
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
                let parts = messageString.components(separatedBy: "\n")
                                
                let name = parts[0]
                let data = parts[1]
                
                guard let messageHandler = self.messageHandlers[name] else {
                    return
                }

                messageHandler(data)
            }
        }
    }
}
