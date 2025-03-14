import Foundation
import WebKit
import UIKit

public class Detonator: NSObject, WKScriptMessageHandler {
    private let filename: String
    
    private var elementClasses: [String: Element.Type]
    private var requestClasses: [String: Request.Type]
    private var moduleClasses: [String: Module.Type]
    
    private var modules: [String: Module]
    
    private var handlerEmitter: HandlerEmitter!
    private var eventEmitter: EventEmitter!
    
    private var trees: [Int: Tree]
    private var edges: [Int: Edge]
    
    private var webView: WKWebView!
    private let rootView: ViewLayout
    
    private var workItem: DispatchWorkItem?
    
    init(rootView: ViewLayout, filename: String) {
        elementClasses = [:]
        requestClasses = [:]
        moduleClasses = [:]
        
        modules = [:]
        
        trees = [:]
        edges = [:]
        
        self.filename = filename
        self.rootView = rootView
        
        super.init()
        
        handlerEmitter = HandlerEmitter(self)
        eventEmitter = EventEmitter(self)
        
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
                
        initWebView()
        
        collectModuleClasses()
        
        registerModules()
        
        IconHelper.initialize()
    }
    
    private func initWebView() {
        let contentController = WKUserContentController()
        
        contentController.add(self, name: "DetonatorBridge")
        
        let config = WKWebViewConfiguration()
        
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        
        webView.layoutParams.display = .none
        
        rootView.addSubview(webView)
        
        evaluate(code: "window.__detonator_platform = \"ios\"")
        
        let code = readIndex()
        
        evaluate(code: code)
    }
    
    public func getEdge(edgeId: Int) -> Edge? {
        return edges[edgeId]
    }
    
    public func addElementClass(key: String, elementClass: Element.Type) {
        elementClasses[key] = elementClass
    }
    
    public func addRequestClass(key: String, requestClass: Request.Type) {
        requestClasses[key] = requestClass
    }
    
    public func addModuleClass(key: String, moduleClass: Module.Type) {
        moduleClasses[key] = moduleClass
    }
    
    private func readIndex() -> String {
        if let path = Bundle.main.path(forResource: filename, ofType: "js") {
            do {
                let code = try String(contentsOfFile: path, encoding: .utf8)
                
                return code;
            } catch {}
        }
        
        return "";
    }
    
    private func evaluate(code: String, completion: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(code, completionHandler: completion)
    }
    
    public func emit(name: String, value: Encodable) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(value)
            
            if let json = String(data: data, encoding: .utf8) {
                let escape = json
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                
                let code = "window.Detonator.emit(\"\(name)\", \"\(escape)\");"
                
                evaluate(code: code)
            }
        } catch {}
    }
    
    public func emitEvent(name: String, data: Encodable? = nil) {
        eventEmitter.emit(name: name, data: data)
    }
    
    public func emitHandler(name: String, edgeId: Int, data: Encodable? = nil) {
        handlerEmitter.emit(name: name, edgeId: edgeId, data: data)
    }
    
    private func collectModuleClasses() {
    }
    
    private func registerModules() {
        for (key, moduleClass) in moduleClasses {
            let module = moduleClass.init(self)
            
            module.register()
            
            modules[key] = module
        }
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
            if message.name == "DetonatorBridge", let body = message.body as? String {
                if let json = body.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    
                    do {
                        let message = try decoder.decode(Message.self, from: json)
                        
                        switch message.action {
                        case "treeInit":
                            self.treeInit(dataString: message.data)
                            
                            break
                            
                        case "treeDeinit":
                            self.treeDeinit(dataString: message.data)
                            
                            break
                            
                        case "mount":
                            self.mount(dataString: message.data)
                            
                            break
                            
                        case "rerender":
                            self.rerender(dataString: message.data)
                            
                            break
                            
                        case "unmount":
                            self.unmount(dataString: message.data)
                            
                            break
                            
                        case "style":
                            self.style(dataString: message.data)
                            
                            break
                            
                        case "request":
                            self.request(dataString: message.data)
                            
                            break
                            
                        case "log":
                            self.log(dataString: message.data)
                            
                            break
                            
                        default:
                            break
                        }
                    } catch {}
                }
            }
        }
    }
    
    private func treeInit(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(TreeInitData.self, from: json)
                
                var view: ViewLayout
                
                if (data.elementId != nil) {
                    let elementEdge = edges[data.elementId!]
                    
                    view = elementEdge!.element!.view! as! ViewLayout
                } else {
                    view = rootView
                }
                
                let tree = Tree(view: view)
                
                trees[data.treeId] = tree
            } catch {}
        }
    }
    
    private func treeDeinit(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(TreeDeinitData.self, from: json)
                
                trees[data.treeId] = nil
            } catch {}
        }
    }
    
    private func mount(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(MountData.self, from: json)
                
                let tree = trees[data.treeId]!
                
                let target = Target(view: tree.view, index: 0)
                
                tree.edge = data.edge
                
                renderEdge(edge: &tree.edge!, prevEdge: nil, target: target)
                
                performLayout()
            } catch {}
        }
    }
    
    private func unmount(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(UnmountData.self, from: json)
                
                let tree = trees[data.treeId]!
                
                let target = Target(view: tree.view, index: 0)
                
                unmountEdge(edge: tree.edge!, target: target)
                
                tree.edge = nil
                
                performLayout()
            } catch {}
        }
    }
    
    private func rerender(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(RerenderData.self, from: json)
                
                let tree = trees[data.treeId]!
                
                for tmpEdge in data.edges {
                    var edge = edges[tmpEdge.id]!
                    
                    let target = createTarget(edge: edge, tree: tree)
                    
                    let prevEdge = edge.clone()
                    
                    edge.copyFrom(edge: tmpEdge)
                    
                    renderEdge(edge: &edge, prevEdge: prevEdge, target: target)
                    
                    let difference = edge.targetViewsCount - prevEdge.targetViewsCount
                    
                    if difference != 0 {
                        propagateTargetViewsCountDifference(edge: edge, difference: difference)
                    }
                }
                
                performLayout()
            } catch {}
        }
    }
    
    private func style(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                
                let styleItems = try decoder.decode([StyleItem].self, from: json)
                
                for styleItem in styleItems {
                    let edge = edges[styleItem.elementId]!
                    
                    edge.element!.applyStyle(style: styleItem.style, keys: styleItem.keys)
                }
                
                performLayout()
            } catch {}
        }
    }
    
    private func request(dataString: String) {
        if let json = dataString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                
                let incomingRequest = try decoder.decode(Request.IncomingRequest.self, from: json)
                
                guard let requestClass = requestClasses[incomingRequest.name] else {
                    return;
                }
                
                let request = requestClass.init(self, incomingRequest: incomingRequest)
                
                request.run()
            } catch {}
        }
    }
    
    private func log(dataString: String) {
        let str = String(dataString.dropFirst().dropLast())
        
        print(str)
    }
    
    public func performLayout() {
        workItem?.cancel()
        
        workItem = DispatchWorkItem { [weak self] in
            self?.rootView.performLayout()
            
            if let fullScreenViewController = FullScreenModule.fullScreenViewController {
                let fullScreenView = fullScreenViewController.view as! ViewLayout
                
                fullScreenView.performLayout()
            }
        }
        
        DispatchQueue.main.async(execute: workItem!)
    }
    
    private func renderChildren(edge: inout Edge, prevEdge: Edge?, target: Target) {
        let children = edge.children;
        
        let prevChildren = prevEdge?.children ?? []
                
        for prevChild in prevChildren {
            var child: Edge?
            
            for tmpChild in children {
                if prevChild.id == tmpChild.id {
                    child = tmpChild
                    
                    break
                }
            }
            
            if child == nil {
                unmountEdge(edge: prevChild, target: target)
            }
        }
        
        for var child in children {
            var prevChild: Edge?
            
            for tmpChild in prevChildren {
                if child.id == tmpChild.id {
                    prevChild = tmpChild
                    
                    break
                }
            }
            
            if child.moved {
                let tmpTarget = Target(view: target.view, index: target.index)
                
                moveEdge(edge: prevChild!, target: tmpTarget)
            }
            
            renderEdge(edge: &child, prevEdge: prevChild, target: target)
        }
    }
    
    private func renderEdge(edge: inout Edge, prevEdge: Edge?, target: Target) {
        edges[edge.id] = edge
        
        if edge.skipped {
            target.index += prevEdge!.targetViewsCount
            
            edge.targetViewsCount = prevEdge!.targetViewsCount
            
            edge.children = prevEdge!.children
            
            return
        }
        
        let initialTargetIndex = target.index
        
        var element = prevEdge?.element
        
        if element == nil {
            element = createElement(edge: edge)
            
            if element != nil {
                element!.create()
            }
        }
        
        edge.element = element
        
        if element != nil {
            element!.edge = edge
            element!.prevEdge = prevEdge
        }
        
        var tmpTarget: Target = target
        
        if element != nil {
            element!.patch()
            
            if element!.view!.isViewGroup {
                tmpTarget = Target(view: element!.view!, index: 0)
            }
        }
        
        renderChildren(edge: &edge, prevEdge: prevEdge, target: tmpTarget)
        
        if element != nil {
            target.insert(child: element!.view!)
        }
        
        let targetViewsCount = target.index - initialTargetIndex
        
        edge.targetViewsCount = targetViewsCount
    }
    
    private func unmountEdge(edge: Edge, target: Target?) {
        edges[edge.id] = nil
        
        var tmpTarget = target
        
        if edge.element != nil {
            edge.element!.remove()
            
            if target != nil {
                tmpTarget = nil
            }
        }
        
        for child in edge.children {
            unmountEdge(edge: child, target: tmpTarget)
        }
        
        if edge.element != nil && target != nil {
            target!.remove(child: edge.element!.view!)
        }
    }
    
    private func createElement(edge: Edge) -> Element? {
        guard let contentType = edge.contentType else {
            return nil
        }
        
        guard let elementClass = elementClasses[contentType] else {
            return nil
        }
        
        return elementClass.init(self)
    }
    
    private func createTarget(edge: Edge, tree: Tree) -> Target {
        var targetIndex = 0
        
        return createTarget(edge: edge, tree: tree, targetIndex: &targetIndex)
    }
    
    private func createTarget(edge: Edge, tree: Tree, targetIndex: inout Int) -> Target {
        if edge.parent == nil {
            return Target(view: tree.view, index: targetIndex)
        }
        
        let parent = edges[edge.parent!]!
        
        let index = parent.children.firstIndex{ $0 === edge }!
        
        for i in stride(from: index - 1, through: 0, by: -1) {
            let child = parent.children[i]
            
            targetIndex += child.targetViewsCount
        }
        
        if parent.element != nil {
            return Target(view: parent.element!.view, index: targetIndex)
        }
        
        return createTarget(edge: parent, tree: tree, targetIndex: &targetIndex)
    }
    
    private func propagateTargetViewsCountDifference(edge: Edge, difference: Int) -> Void {
        if edge.parent == nil {
            return
        }
        
        let parent = edges[edge.parent!]!
        
        let element = parent.element
        
        if element != nil {
            return
        }
        
        parent.targetViewsCount += difference
        
        propagateTargetViewsCountDifference(edge: parent, difference: difference)
    }
    
    private func moveEdge(edge: Edge, target: Target) -> Void {
        if edge.element != nil {
            target.insert(child: edge.element!.view)
            
            return
        }
        
        for child in edge.children {
            moveEdge(edge: child, target: target)
        }
    }
    
    struct Message: Decodable {
        let action: String
        let data: String
    }
    
    struct TreeInitData: Decodable {
        let treeId: Int
        let elementId: Int?
    }
    
    struct TreeDeinitData: Decodable {
        let treeId: Int
    }
    
    struct MountData: Decodable {
        let treeId: Int
        let edge: Edge
    }
    
    struct UnmountData: Decodable {
        let treeId: Int
    }
    
    struct RerenderData: Decodable {
        let treeId: Int
        let edges: [Edge]
    }
    
    struct StyleItem: Decodable {
        let elementId: Int
        let style: Style
        let keys: [String]
    }
}
