class TextAreaSetValueRequest: Request {
    override public func run() {
        let value: String! = decodeData()
        
        let edge = getComponentEdge()!
        
        let element = edge.children[0].element as! TextAreaElement
        
        element.setValue(value: value)
        
        end()
    }
}
