import UIKit

class TextAreaFocusRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let textEdge = edge.children[0]
        
        let view = textEdge.element!.view as! TextAreaView
        
        view.becomeFirstResponder()
        
        end()
    }
}
