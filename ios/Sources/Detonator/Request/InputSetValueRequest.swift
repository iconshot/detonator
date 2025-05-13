import UIKit

class InputSetValueRequest: Request {
    override public func run() {
        let value: String! = decodeData()
        
        let edge = getComponentEdge()!
        
        let elementEdge = edge.children[0]
        
        let element = elementEdge.element! as! InputElement
        
        element.updateValue(value: value)
        
        end()
    }
}
