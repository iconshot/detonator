import Foundation

class Renderer {
    private let detonator: Detonator
    
    private let rootView: ViewLayout
    
    public var trees: [Int: Tree] = [:]
    public var edges: [Int: Edge] = [:]
    
    private var workItem: DispatchWorkItem?
    
    init(_ detonator: Detonator, _ rootView: ViewLayout) {
        self.detonator = detonator
        self.rootView = rootView
        
        detonator.setMessageListener("com.iconshot.detonator.renderer::treeInit") { value in
            let data: TreeInitData = detonator.decode(value)!
            
            var view: ViewLayout
            
            if (data.elementId != nil) {
                let elementEdge = self.edges[data.elementId!]
                
                view = elementEdge!.element!.view as! ViewLayout
            } else {
                view = rootView
            }
            
            let tree = Tree(view: view)
            
            self.trees[data.treeId] = tree
        }
            
        detonator.setMessageListener("com.iconshot.detonator.renderer::treeDeinit") { value in
            let data: TreeDeinitData = detonator.decode(value)!
            
            self.trees[data.treeId] = nil
        }
        
        detonator.setMessageListener("com.iconshot.detonator.renderer::mount") { value in
            let data: MountData = detonator.decode(value)!
            
            let tree = self.trees[data.treeId]!
            
            let target = Target(view: tree.view, index: 0)
            
            tree.edge = data.edge
            
            self.renderEdge(edge: &tree.edge!, prevEdge: nil, target: target)
            
            self.performLayout()
        }
        
        detonator.setMessageListener("com.iconshot.detonator.renderer::unmount") { value in
            let data: UnmountData = detonator.decode(value)!
            
            let tree = self.trees[data.treeId]!
            
            let target = Target(view: tree.view, index: 0)
            
            self.unmountEdge(edge: tree.edge!, target: target)
            
            tree.edge = nil
            
            self.performLayout()
        }
        
        detonator.setMessageListener("com.iconshot.detonator.renderer::rerender") { value in
            let data: RerenderData = detonator.decode(value)!
            
            let tree = self.trees[data.treeId]!
            
            for tmpEdge in data.edges {
                var edge = self.edges[tmpEdge.id]!
                
                let target = self.createTarget(edge: edge, tree: tree)
                
                let prevEdge = edge.clone()
                
                edge.copyFrom(edge: tmpEdge)
                
                self.renderEdge(edge: &edge, prevEdge: prevEdge, target: target)
                
                let difference = edge.targetViewsCount - prevEdge.targetViewsCount
                
                if difference != 0 {
                    self.propagateTargetViewsCountDifference(edge: edge, difference: difference)
                }
            }
            
            self.performLayout()
        }
    }
    
    private func renderChildren(edge: inout Edge, prevEdge: Edge?, target: Target) -> Void {
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
    
    private func renderEdge(edge: inout Edge, prevEdge: Edge?, target: Target) -> Void {
        edges[edge.id] = edge
        
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
        }
        
        if edge.skipped {
            target.index += prevEdge!.targetViewsCount
            
            edge.parent = prevEdge!.parent
            
            edge.contentType = prevEdge!.contentType
            
            edge.attributes = prevEdge!.attributes
            
            edge.children = prevEdge!.children
            
            edge.text = prevEdge!.text
            
            edge.targetViewsCount = prevEdge!.targetViewsCount
            
            return
        }
        
        let initialTargetIndex = target.index
        
        var tmpTarget = target
        
        if element != nil && element!.view.isViewGroup {
            tmpTarget = Target(view: element!.view, index: 0)
        }
        
        renderChildren(edge: &edge, prevEdge: prevEdge, target: tmpTarget)
        
        if element != nil {
            element!.patch()
            
            target.insert(child: element!.view)
        }
        
        let targetViewsCount = target.index - initialTargetIndex
        
        edge.targetViewsCount = targetViewsCount
    }
    
    private func unmountEdge(edge: Edge, target: Target?) -> Void {
        edges[edge.id] = nil
        
        var tmpTarget = target
        
        if edge.element != nil && target != nil {
            tmpTarget = nil
        }
        
        for child in edge.children {
            unmountEdge(edge: child, target: tmpTarget)
        }
        
        if edge.element != nil {
            edge.element!.remove()
            
            if target != nil {
                target!.remove(child: edge.element!.view)
            }
        }
    }
    
    private func createElement(edge: Edge) -> Element? {
        guard let contentType = edge.contentType else {
            return nil
        }
        
        guard let elementClass = detonator.getElementClass(contentType) else {
            return nil
        }
        
        return elementClass.init(detonator)
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
    
    public func performLayout() -> Void {
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
}
