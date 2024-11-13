class ViewCloseFullScreenRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let elementEdge = edge.children[0]
        
        let view = elementEdge.element!.view as! ViewLayout
    }
}
