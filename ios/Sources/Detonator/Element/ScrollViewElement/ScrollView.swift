import UIKit

class ScrollView: UIScrollView {
    override func measure(specWidth: CGFloat, specHeight: CGFloat, specWidthMode: Int, specHeightMode: Int) {
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
        
        var contentWidth: Float = 0
        var contentHeight: Float = 0
        
        let child = subviews.first!
        
        child.measure(
            specWidth: innerWidth,
            specHeight: 0,
            specWidthMode: specWidthMode,
            specHeightMode: MeasureSpec.UNSPECIFIED
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
    
    override func layout(x: CGFloat, y: CGFloat) {
        super.layout(x: x, y: y)
        
        let paddingTop = layoutParams.padding.top
        let paddingLeft = layoutParams.padding.left
        
        let x = paddingTop
        let y = paddingLeft
        
        let child = subviews.first!
        
        child.layout(x: CGFloat(x), y: CGFloat(y))
    }
}
