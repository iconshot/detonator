class TextAreaBlurRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let element = edge.children[0].element as! TextAreaElement
        
        element.blur()
        
        end()
    }
}
