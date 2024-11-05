import UIKit

class VerticalScrollViewElement: Element {
    private var isAtBottom: Bool = false
    
    override public func decodeAttributes(edge: Edge) -> VerticalScrollViewAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> VerticalScrollView {
        let view = VerticalScrollView()
        
        view.delegate = view
        
        view.isViewGroup = true
        
        view.contentInsetAdjustmentBehavior = .never
        
        view.onPageChangeListener = { page in
            let data = OnPageChangeData(page: page)
            
            self.detonator.emitHandler(name: "onPageChange", edgeId: self.edge.id, data: data)
        }
        
        view.onScrollListener = {
            let child = view.subviews.first!
            
            let diff = child.frame.maxY - (view.frame.size.height + view.contentOffset.y)
            
            self.isAtBottom = diff == 0
        }
        
        return view
    }
    
    override public func patchView() {
        let view = view as! VerticalScrollView
        
        let layoutParams = view.layoutParams
        
        let attributes = attributes as! VerticalScrollViewAttributes
        let currentAttributes = currentAttributes as! VerticalScrollViewAttributes?
        
        let paginated = attributes.paginated
        let currentPaginated = currentAttributes?.paginated
        
        let patchPaginatedBool = forcePatch || paginated != currentPaginated
        
        if patchPaginatedBool {
            view.isPagingEnabled = paginated == true
        }
        
        let inverted = attributes.inverted
        let currentInverted = currentAttributes?.inverted
        
        let patchInvertedBool = forcePatch || inverted != currentInverted
        
        if patchInvertedBool {
            view.inverted = inverted == true
        }
        
        let showsIndicator = attributes.showsIndicator
        let currentShowsIndicator = currentAttributes?.showsIndicator
        
        let patchShowsIndicatorBool = forcePatch || showsIndicator != currentShowsIndicator
        
        if patchShowsIndicatorBool {
            view.showsVerticalScrollIndicator = showsIndicator == true
        }
        
        let scrollToBottom = inverted == true && (forcePatch || isAtBottom);
        
        if scrollToBottom {
            layoutParams.onLayoutClosures["scroll"] = {
                let y = view.contentSize.height - view.frame.size.height
                
                if y > 0 {
                    view.contentOffset = CGPoint(x: 0, y: y)
                }
                
                self.isAtBottom = true
            }
        } else {
            layoutParams.onLayoutClosures["scroll"] = nil
        }
    }
    
    override func patchBorderRadius(
        borderRadius: StyleSize?,
        borderRadiusTopLeft: StyleSize?,
        borderRadiusTopRight: StyleSize?,
        borderRadiusBottomLeft: StyleSize?,
        borderRadiusBottomRight: StyleSize?
    ) {}
    
    struct OnPageChangeData: Encodable {
        let page: Int
    }
    
    class VerticalScrollViewAttributes: Attributes {
        var horizontal: Bool?
        var paginated: Bool?
        var inverted: Bool?
        var showsIndicator: Bool?
        var onPageChange: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            horizontal = try container.decodeIfPresent(Bool.self, forKey: .horizontal)
            paginated = try container.decodeIfPresent(Bool.self, forKey: .paginated)
            inverted = try container.decodeIfPresent(Bool.self, forKey: .inverted)
            showsIndicator = try container.decodeIfPresent(Bool.self, forKey: .showsIndicator)
            onPageChange = try container.decodeIfPresent(Bool.self, forKey: .onPageChange)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case horizontal
            case paginated
            case inverted
            case showsIndicator
            case onPageChange
        }
    }
}
