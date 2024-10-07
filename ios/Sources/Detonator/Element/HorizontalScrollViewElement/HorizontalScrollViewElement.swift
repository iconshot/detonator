import UIKit

class HorizontalScrollViewElement: Element {
    override public func decodeAttributes(edge: Edge) -> HorizontalScrollViewAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> HorizontalScrollView {
        let view = HorizontalScrollView()
        
        view.delegate = view
        
        view.isViewGroup = true
        
        view.contentInsetAdjustmentBehavior = .never
        
        view.onPageChangeListener = { page in
            let data = OnPageChangeData(page: page)
            
            self.detonator.emitHandler(name: "onPageChange", edgeId: self.edge.id, data: data)
        }
        
        return view
    }
    
    override public func patchView() {
        let view = view as! HorizontalScrollView
        
        let attributes = attributes as! HorizontalScrollViewAttributes
        let currentAttributes = currentAttributes as! HorizontalScrollViewAttributes?
        
        let paginated = attributes.paginated
        let currentPaginated = currentAttributes?.paginated
        
        let patchPaginatedBool = forcePatch || paginated != currentPaginated
        
        if patchPaginatedBool {
            view.isPagingEnabled = paginated == true
        }
        
        let showsIndicator = attributes.showsIndicator
        let currentShowsIndicator = currentAttributes?.showsIndicator
        
        let patchShowsIndicator = forcePatch || showsIndicator != currentShowsIndicator
        
        if patchShowsIndicator {
            view.showsHorizontalScrollIndicator = showsIndicator == true
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
    
    class HorizontalScrollViewAttributes: Attributes {
        var horizontal: Bool?
        var paginated: Bool?
        var showsIndicator: Bool?
        var onPageChange: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            horizontal = try container.decodeIfPresent(Bool.self, forKey: .horizontal)
            paginated = try container.decodeIfPresent(Bool.self, forKey: .paginated)
            showsIndicator = try container.decodeIfPresent(Bool.self, forKey: .showsIndicator)
            onPageChange = try container.decodeIfPresent(Bool.self, forKey: .onPageChange)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case horizontal
            case paginated
            case showsIndicator
            case onPageChange
        }
    }
}
