import UIKit

class VerticalScrollViewElement: Element {
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
        
        return view
    }
    
    override public func patchView() {
        let view = view as! VerticalScrollView
        
        let attributes = attributes as! VerticalScrollViewAttributes
        let currentAttributes = currentAttributes as! VerticalScrollViewAttributes?
        
        let paginated = attributes.paginated
        let currentPaginated = currentAttributes?.paginated
        
        let patchPaginatedBool = forcePatch || paginated != currentPaginated
        
        if patchPaginatedBool {
            view.isPagingEnabled = paginated == true
        }
        
        let showsIndicator = attributes.showsIndicator
        let currentShowsIndicator = currentAttributes?.showsIndicator
        
        let patchShowsIndicatorBool = forcePatch || showsIndicator != currentShowsIndicator
        
        if patchShowsIndicatorBool {
            view.showsVerticalScrollIndicator = showsIndicator == true
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
