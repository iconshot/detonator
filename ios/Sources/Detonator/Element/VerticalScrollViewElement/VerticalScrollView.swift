import UIKit

public class VerticalScrollView: UIScrollView, UIScrollViewDelegate {
    public var inverted: Bool = false
    
    private var page: Int = 0
    
    public var onPageChangeListener: ((_ page: Int) -> Void)!
    
    public var onScrollListener: (() -> Void)!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func measure(specWidth: CGFloat, specHeight: CGFloat, specWidthMode: Int, specHeightMode: Int) {
        if layoutParams.remeasured {
            frame.size.width = specWidth
            frame.size.height = specHeight
            
            return
        }
        
        let paddingTop = layoutParams.padding.top
        let paddingLeft = layoutParams.padding.left
        let paddingBottom = layoutParams.padding.bottom
        let paddingRight = layoutParams.padding.right
        
        let paddingX = paddingLeft + paddingRight
        let paddingY = paddingTop + paddingBottom
        
        let innerWidth = specWidth - CGFloat(paddingX)
        let innerHeight = specHeight - CGFloat(paddingY)
        
        var contentWidth: Float = 0
        var contentHeight: Float = 0
        
        let child = subviews.first!
        
        child.measure(
            specWidth: innerWidth,
            specHeight: isPagingEnabled ? innerHeight * CGFloat(child.subviews.count) : 0,
            specWidthMode: specWidthMode,
            specHeightMode: isPagingEnabled ? MeasureSpec.EXACTLY : MeasureSpec.UNSPECIFIED
        )
        
        var childWidth = Float(child.frame.size.width)
        var childHeight = Float(child.frame.size.height)
        
        let remeasure = inverted && specHeightMode == MeasureSpec.EXACTLY && CGFloat(childHeight) < innerHeight;
        
        if remeasure {
            child.layoutParams.remeasured = true
            
            child.measure(
                specWidth: CGFloat(childWidth),
                specHeight: innerHeight,
                specWidthMode: MeasureSpec.EXACTLY,
                specHeightMode: MeasureSpec.EXACTLY
            )
            
            child.layoutParams.remeasured = false
        }
        
        childWidth = Float(child.frame.size.width)
        childHeight = Float(child.frame.size.height)
        
        contentWidth += childWidth
        contentHeight += childHeight
        
        contentWidth += paddingX
        contentHeight += paddingY
        
        var resolvedWidth = resolveSize(size: CGFloat(contentWidth), specSize: specWidth, specSizeMode: specWidthMode)
        var resolvedHeight = resolveSize(size: CGFloat(contentHeight), specSize: specHeight, specSizeMode: specHeightMode)
        
        frame.size.width = resolvedWidth
        frame.size.height = resolvedHeight
        
        contentSize = CGSize(
            width: CGFloat(contentWidth),
            height: CGFloat(contentHeight)
        )
    }
    
    override public func layout(x: CGFloat, y: CGFloat) {
        super.layout(x: x, y: y)
        
        let paddingTop = layoutParams.padding.top
        let paddingLeft = layoutParams.padding.left
        
        let x = paddingTop
        let y = paddingLeft
        
        let child = subviews.first!
        
        child.layout(x: CGFloat(x), y: CGFloat(y))
    }
    
    func scrollToPage(page: Int) {
        if !isPagingEnabled {
            return
        }
        
        let height = frame.size.height
        
        let child = subviews.first!
        
        let pagesCount = child.subviews.count
        
        let tmpPage = max(0, min(page, pagesCount - 1));
        
        if tmpPage == self.page {
            return
        }
        
        self.page = tmpPage
        
        onPageChangeListener(tmpPage)
        
        let targetOffset = CGPoint(x: 0, y: height * CGFloat(tmpPage))
        
        setContentOffset(targetOffset, animated: true)
    }
    
    public func scrollViewDidEndDecelerating(_ view: UIScrollView) {
        if !isPagingEnabled {
            return
        }
        
        let tmpPage = Int(view.contentOffset.y / view.frame.size.height)
        
        if tmpPage == self.page {
            return
        }
        
        self.page = tmpPage
        
        onPageChangeListener(tmpPage)
    }
    
    public func scrollViewDidScroll(_ view: UIScrollView) {
        onScrollListener()
    }
}
