import UIKit

class ScrollViewElement: Element {
    override public func decodeAttributes(edge: Edge) -> ScrollViewAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> ScrollView {
        let view = ScrollView()
        
        view.isViewGroup = true
        
        view.contentInsetAdjustmentBehavior = .never
        
        return view
    }
    
    override public func patchView() {
        let view = view as! ScrollView
        
        let attributes = attributes as! ScrollViewAttributes
        let currentAttributes = currentAttributes as! ScrollViewAttributes?
        
        let showsIndicator = attributes.showsIndicator
        let currentShowsIndicator = currentAttributes?.showsIndicator
        
        let patchShowsIndicator = forcePatch || showsIndicator != currentShowsIndicator
        
        if patchShowsIndicator {
            if showsIndicator == true {
                view.showsVerticalScrollIndicator = true
            } else {
                view.showsVerticalScrollIndicator = false
            }
        }
    }
    
    override func patchBorderRadius(
        borderRadius: StyleSize?,
        borderRadiusTopLeft: StyleSize?,
        borderRadiusTopRight: StyleSize?,
        borderRadiusBottomLeft: StyleSize?,
        borderRadiusBottomRight: StyleSize?
    ) {}
    
    class ScrollViewAttributes: Attributes {
        var horizontal: Bool?
        var showsIndicator: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            horizontal = try container.decodeIfPresent(Bool.self, forKey: .horizontal)
            showsIndicator = try container.decodeIfPresent(Bool.self, forKey: .showsIndicator)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case horizontal
            case showsIndicator
        }
    }
}
