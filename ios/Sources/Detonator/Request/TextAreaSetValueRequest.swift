import UIKit

class TextAreaSetValueRequest: Request {
    override public func run() {
        let value: String! = decodeData()
        
        let edge = getComponentEdge()!
        
        let elementEdge = edge.children[0]
        
        let element = elementEdge.element! as! TextAreaElement
        
        element.updateValue(value: value)
        
        end()
    }
}
