import UIKit

class ViewElement: Element {
    override public func decodeAttributes() -> ViewAttributes? {
        return super.decodeAttributes()
    }
    
    override public func createView() -> ViewLayout {
        return ViewLayout()
    }
    
    override func patchOverflow(overflow: String?) {
        let tmpOverflow = overflow ?? "visible"
        
        switch tmpOverflow {
        case "visible":
            view.clipsToBounds = false
            
            break
            
        case "hidden":
            view.clipsToBounds = true
            
            break
            
        default:
            view.clipsToBounds = false
            
            break
        }
    }
    
    override func patchFlexDirection(flexDirection: String?) {
        let view = view as! ViewLayout
        
        switch flexDirection {
        case "row":
            view.flexDirection = .row
            
            break
            
        case "row-reverse":
            view.flexDirection = .rowReverse
            
            break
            
        case "column":
            view.flexDirection = .column
            
            break
            
        case "column-reverse":
            view.flexDirection = .columnReverse
            
            break
            
        default:
            view.flexDirection = .column
            
            break
        }
    }
    
    override func patchJustifyContent(justifyContent: String?) {
        let view = view as! ViewLayout
        
        switch justifyContent {
        case "flex-start":
            view.justifyContent = .flexStart
            
            break
            
        case "flex-end":
            view.justifyContent = .flexEnd
            
            break
            
        case "start":
            view.justifyContent = .start
            
            break
            
        case "end":
            view.justifyContent = .end
            
            break
            
        case "center":
            view.justifyContent = .center
            
            break
            
        case "space-between":
            view.justifyContent = .spaceBetween
            
            break
            
        case "space-around":
            view.justifyContent = .spaceAround
            
            break
            
        case "space-evenly":
            view.justifyContent = .spaceEvenly
            
            break
            
        default:
            view.justifyContent = .flexStart
            
            break
        }
    }
    
    override func patchAlignItems(alignItems: String?) {
        let view = view as! ViewLayout
        
        switch alignItems {
        case "flex-start":
            view.alignItems = .flexStart
            
            break
            
        case "flex-end":
            view.alignItems = .flexEnd
            
            break
            
        case "start":
            view.alignItems = .start
            
            break
            
        case "end":
            view.alignItems = .end
            
            break
            
        case "center":
            view.alignItems = .center
            
            break
            
        default:
            view.alignItems = .flexStart
            
            break
        }
    }
    
    override func patchGap(gap: Float?) {
        let view = view as! ViewLayout
        
        view.gap = gap ?? 0
    }
    
    class ViewAttributes: Attributes {}
}
