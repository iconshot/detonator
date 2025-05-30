import UIKit

class HorizontalScrollViewElement: Element {
    private var isAtRight: Bool = false
    
    override public func decodeAttributes() -> HorizontalScrollViewAttributes? {
        return super.decodeAttributes()
    }
    
    override public func createView() -> HorizontalScrollView {
        let view = HorizontalScrollView()
        
        view.delegate = view
        
        view.isViewGroup = true
        
        view.contentInsetAdjustmentBehavior = .never
        
        view.onPageChangeListener = { page in
            let data = OnPageChangeData(page: page)
            
            self.emitHandler(name: "onPageChange", data: data)
        }
        
        view.onScrollListener = {
            let child = view.subviews.first!
            
            let diff = child.frame.maxX - (view.frame.size.width + view.contentOffset.x)
            
            self.isAtRight = diff == 0
        }
        
        return view
    }
    
    override public func patchView() {
        let view = view as! HorizontalScrollView
        
        let layoutParams = view.layoutParams
        
        let attributes = attributes as! HorizontalScrollViewAttributes
        let prevAttributes = prevAttributes as! HorizontalScrollViewAttributes?
        
        let paginated = attributes.paginated
        let prevPaginated = prevAttributes?.paginated
        
        let patchPaginatedBool = forcePatch || paginated != prevPaginated
        
        if patchPaginatedBool {
            view.isPagingEnabled = paginated == true
        }
        
        let inverted = attributes.inverted
        let prevInverted = prevAttributes?.inverted
        
        let patchInvertedBool = forcePatch || inverted != prevInverted
        
        if patchInvertedBool {
            view.inverted = inverted == true
        }
        
        let showsIndicator = attributes.showsIndicator
        let prevShowsIndicator = prevAttributes?.showsIndicator
        
        let patchShowsIndicator = forcePatch || showsIndicator != prevShowsIndicator
        
        if patchShowsIndicator {
            view.showsHorizontalScrollIndicator = showsIndicator == true
        }
        
        let scrollToRight = inverted == true && (forcePatch || isAtRight);
        
        if scrollToRight {
            layoutParams.onLayoutClosures["scroll"] = {
                let x = view.contentSize.width - view.frame.size.width
                
                if x > 0 {
                    view.contentOffset = CGPoint(x: x, y: 0)
                }
                
                self.isAtRight = true
            }
        } else {
            layoutParams.onLayoutClosures["scroll"] = nil
        }
    }
    
    override func patchPadding(
        padding: Float?,
        paddingHorizontal: Float?,
        paddingVertical: Float?,
        paddingTop: Float?,
        paddingLeft: Float?,
        paddingBottom: Float?,
        paddingRight: Float?
    ) {}
    
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
    
    class HorizontalScrollViewAttributes: Attributes {
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
