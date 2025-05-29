class InputFocusRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let element = edge.children[0].element as! InputElement
        
        element.focus()

        end()
    }
}
