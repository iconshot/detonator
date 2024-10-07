import UIKit

public class HorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    private var page: Int = 0
    
    public var onPageChangeListener: ((_ page: Int) -> Void)!
    
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
            specWidth: isPagingEnabled ? innerWidth * CGFloat(child.subviews.count) : 0,
            specHeight: innerHeight,
            specWidthMode: isPagingEnabled ? MeasureSpec.EXACTLY : MeasureSpec.UNSPECIFIED,
            specHeightMode: specHeightMode
        )
        
        let childWidth = Float(child.frame.size.width)
        let childHeight = Float(child.frame.size.height)
        
        contentWidth += childWidth
        contentHeight += childHeight
        
        contentWidth += paddingX
        contentHeight += paddingY
        
        let resolvedWidth = resolveSize(size: CGFloat(contentWidth), specSize: specWidth, specSizeMode: specWidthMode)
        let resolvedHeight = resolveSize(size: CGFloat(contentHeight), specSize: specHeight, specSizeMode: specHeightMode)
        
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
        
        let width = frame.size.width
        
        let child = subviews.first!
        
        let pagesCount = child.subviews.count
        
        let tmpPage = max(0, min(page, pagesCount - 1));
        
        if tmpPage == self.page {
            return
        }
        
        self.page = tmpPage
        
        onPageChangeListener(tmpPage)
        
        let targetOffset = CGPoint(x: width * CGFloat(tmpPage), y: 0)
        
        setContentOffset(targetOffset, animated: true)
    }
    
    public func scrollViewDidEndDecelerating(_ view: UIScrollView) {
        if !isPagingEnabled {
            return
        }
        
        let tmpPage = Int(view.contentOffset.x / view.frame.size.width)
        
        if tmpPage == self.page {
            return
        }
        
        self.page = tmpPage
        
        onPageChangeListener(tmpPage)
    }
}
