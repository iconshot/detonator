import UIKit

class ViewLayout: UIView {
    static var staticId = 0
    
    public var id: Int
    
    public var flexDirection: LayoutParams.FlexDirection = .column
    
    public var justifyContent: LayoutParams.JustifyContent = .flexStart
    public var alignItems: LayoutParams.AlignItems = .flexStart
    
    override init(frame: CGRect) {
        id = ViewLayout.staticId
        
        ViewLayout.staticId += 1
        
        super.init(frame: frame)
        
        initView()
    }

    required init?(coder: NSCoder) {
        id = ViewLayout.staticId
        
        ViewLayout.staticId += 1
        
        super.init(coder: coder)
        
        initView()
    }

    private func initView() {
        clipsToBounds = false
    }
    
    private func isHorizontal() -> Bool {
        return flexDirection == .row || flexDirection == .rowReverse
    }
    
    private func isReversed() -> Bool {
        return flexDirection == .rowReverse || flexDirection == .columnReverse
    }
    
    public func performLayout() {
        let width = frame.size.width
        let height = frame.size.height
        
        measureRelativeChildren(
            exactWidth: Float(width),
            exactHeight: Float(height),
            mostWidth: nil,
            mostHeight: nil
        )
        
        measureAbsoluteChildren()
        
        layoutChildren()
        
        setNeedsLayout()
    }
    
    // exact is equivalent to android's EXACTLY
    // most is equivalent to android's AT_MOST
    
    private func measureRelativeChildren(
        exactWidth: Float?,
        exactHeight: Float?,
        mostWidth: Float?,
        mostHeight: Float?
    ) -> LayoutSize {
        let paddingTop = layoutParams.padding.top
        let paddingLeft = layoutParams.padding.left
        let paddingBottom = layoutParams.padding.bottom
        let paddingRight = layoutParams.padding.right
        
        let paddingX = paddingLeft + paddingRight
        let paddingY = paddingTop + paddingBottom
        
        let innerWidth = (exactWidth ?? 0) - paddingX
        let innerHeight = (exactHeight ?? 0) - paddingY
        
        var contentWidth: Float = 0
        var contentHeight: Float = 0
        
        var flexCount: Int = 0
        var totalFlex: Int = 0
        var usedSize: Float = 0
        
        let canUseFlex = isHorizontal() ? exactWidth != nil : exactHeight != nil
        
        // non-flex
        
        for child in subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if isAbsolute {
                continue
            }
            
            let marginTop = layoutParams.margin.top
            let marginLeft = layoutParams.margin.left
            let marginBottom = layoutParams.margin.bottom
            let marginRight = layoutParams.margin.right
            
            let marginX = marginLeft + marginRight
            let marginY = marginTop + marginBottom
            
            let hasFlex = layoutParams.flex != nil
            
            let useFlex = hasFlex && canUseFlex
            
            if useFlex {
                flexCount += 1
                
                totalFlex += layoutParams.flex!
                
                usedSize += isHorizontal() ? marginX : marginY
                
                continue
            }
            
            var childExactWidth: Float?
            var childExactHeight: Float?
            var childMostWidth: Float?
            var childMostHeight: Float?
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let useWidth = hasWidth && (layoutParams.widthPercent == nil || exactWidth != nil)
            let useHeight = hasHeight && (layoutParams.heightPercent == nil || exactHeight != nil)
            
            let useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == nil || exactWidth != nil)
            let useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == nil || exactHeight != nil)
            
            let useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == nil || exactWidth != nil)
            let useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == nil || exactHeight != nil)
            
            if useWidth {
                var width = layoutParams.width ?? innerWidth * layoutParams.widthPercent!
                
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                    
                    width = min(width, maxWidth)
                }
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childExactWidth = width
            } else {
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                    
                    childMostWidth = maxWidth
                }
            }
            
            if useHeight {
                var height = layoutParams.height ?? innerHeight * layoutParams.heightPercent!
                
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                    
                    height = min(height, maxHeight)
                }
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childExactHeight = height
            } else {
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                    
                    childMostHeight = maxHeight
                }
            }
            
            if layoutParams.aspectRatio != nil {
                if useWidth {
                    childExactHeight = childExactWidth! * layoutParams.aspectRatio!
                } else if useHeight {
                    childExactWidth = childExactHeight! * layoutParams.aspectRatio!
                }
            }
            
            let childSize = measureChild(
                view: child,
                exactWidth: childExactWidth,
                exactHeight: childExactHeight,
                mostWidth: childMostWidth,
                mostHeight: childMostHeight
            )
            
            var childWidth = childSize.width
            var childHeight = childSize.height
            
            if !useWidth {
                var width = childWidth
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childWidth = width
            }
            
            if !useHeight {
                var height = childHeight
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childHeight = height
            }
            
            if layoutParams.aspectRatio != nil && !useWidth && !useHeight {
                let hasAnyWidth = hasWidth || hasMinWidth || hasMaxWidth
                let hasAnyHeight = hasHeight || hasMinHeight || hasMaxHeight
                
                if hasAnyWidth {
                    childHeight = childWidth * layoutParams.aspectRatio!
                } else if hasAnyHeight {
                    childWidth = childHeight * layoutParams.aspectRatio!
                } else {
                    childHeight = childWidth * layoutParams.aspectRatio!
                }
            }
            
            setChildSize(view: child, width: childWidth, height: childHeight)
            
            let outerWidth = childWidth + marginX
            let outerHeight = childHeight + marginY
            
            if canUseFlex {
                usedSize += isHorizontal() ? outerWidth : outerHeight
            }
        }
        
        // flex
        
        var flexBaseSize: Float = 0
        var flexDistribution: Float = 0
        
        if flexCount > 0 {
            let availableSize = (isHorizontal() ? innerWidth : innerHeight) - usedSize
            
            flexBaseSize = availableSize / Float(totalFlex)
            
            let baseFlexRemainder = availableSize.truncatingRemainder(dividingBy: Float(totalFlex))
            
            flexDistribution = baseFlexRemainder / Float(flexCount)
        }
        
        for child in subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if isAbsolute {
                continue
            }
            
            let hasFlex = layoutParams.flex != nil
            
            let useFlex = hasFlex && canUseFlex
            
            if !useFlex {
                continue
            }
            
            let flexSize = flexBaseSize * Float(layoutParams.flex!) + flexDistribution
            
            var childExactWidth: Float?
            var childExactHeight: Float?
            var childMostWidth: Float?
            var childMostHeight: Float?
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let useWidth = hasWidth && (layoutParams.widthPercent == nil || exactWidth != nil)
            let useHeight = hasHeight && (layoutParams.heightPercent == nil || exactHeight != nil)
            
            let useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == nil || exactWidth != nil)
            let useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == nil || exactHeight != nil)
            
            let useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == nil || exactWidth != nil)
            let useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == nil || exactHeight != nil)
            
            if isHorizontal() {
                childExactWidth = flexSize
                
                if useHeight {
                    var height = layoutParams.height ?? innerHeight * layoutParams.heightPercent!
                    
                    if useMaxHeight {
                        let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                        
                        height = min(height, maxHeight)
                    }
                    
                    if useMinHeight {
                        let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                        
                        height = max(height, minHeight)
                    }
                    
                    childExactHeight = height
                } else {
                    if useMaxHeight {
                        let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                        
                        childMostHeight = maxHeight
                    }
                }
                
                if layoutParams.aspectRatio != nil {
                    childExactHeight = childExactWidth! * layoutParams.aspectRatio!
                    
                }
            } else {
                childExactHeight = flexSize
                
                if useWidth {
                    var width = layoutParams.width ?? innerWidth * layoutParams.widthPercent!
                    
                    if useMaxWidth {
                        let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                        
                        width = min(width, maxWidth)
                    }
                    
                    if useMinWidth {
                        let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                        
                        width = max(width, minWidth)
                    }
                    
                    childExactWidth = width
                } else {
                    if useMaxWidth {
                        let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                        
                        childMostWidth = maxWidth
                    }
                }
                
                if layoutParams.aspectRatio != nil {
                    childExactWidth = childExactHeight! * layoutParams.aspectRatio!
                }
            }
            
            let childSize = measureChild(
                view: child,
                exactWidth: childExactWidth,
                exactHeight: childExactHeight,
                mostWidth: childMostWidth,
                mostHeight: childMostHeight
            )
            
            var childWidth = childSize.width
            var childHeight = childSize.height
            
            if layoutParams.aspectRatio == nil {
                if isHorizontal() {
                    if !useHeight {
                        var height = childHeight
                        
                        if useMinHeight {
                            let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                            
                            height = max(height, minHeight)
                        }
                        
                        childHeight = height
                    }
                } else {
                    if !useWidth {
                        var width = childWidth
                        
                        if useMinWidth {
                            let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                            
                            width = max(width, minWidth)
                        }
                        
                        childWidth = width
                    }
                }
            }
                        
            setChildSize(view: child, width: childWidth, height: childHeight)
        }
        
        // content size
        
        for child in subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if isAbsolute {
                continue
            }
            
            let childWidth = Float(child.frame.size.width)
            let childHeight = Float(child.frame.size.height)
            
            let marginTop = layoutParams.margin.top
            let marginLeft = layoutParams.margin.left
            let marginBottom = layoutParams.margin.bottom
            let marginRight = layoutParams.margin.right
            
            let marginX = marginLeft + marginRight
            let marginY = marginTop + marginBottom
            
            let outerWidth = childWidth + marginX
            let outerHeight = childHeight + marginY
            
            if isHorizontal() {
                contentWidth += outerWidth
                
                contentHeight = max(contentHeight, outerHeight)
            } else {
                contentWidth = max(contentWidth, outerWidth)
                
                contentHeight += outerHeight
            }
        }
        
        contentWidth += paddingX
        contentHeight += paddingY
        
        var resolvedWidth: Float = 0
        var resolvedHeight: Float = 0
        
        if exactWidth != nil {
            resolvedWidth = exactWidth!
        } else if mostWidth != nil {
            resolvedWidth = min(contentWidth, mostWidth!)
        } else {
            resolvedWidth = contentWidth
        }
        
        if exactHeight != nil {
            resolvedHeight = exactHeight!
        } else if mostHeight != nil {
            resolvedHeight = min(contentHeight, mostHeight!)
        } else {
            resolvedHeight = contentHeight
        }
        
        return LayoutSize(width: resolvedWidth, height: resolvedHeight)
    }
    
    private func measureAbsoluteChildren() {
        let measuredWidth = Float(frame.size.width)
        let measuredHeight = Float(frame.size.height)
        
        for child in subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if !isAbsolute {
                continue
            }
            
            var childExactWidth: Float?
            var childExactHeight: Float?
            var childMostWidth: Float?
            var childMostHeight: Float?
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let hasPositionWidth = layoutParams.positionLeft != nil && layoutParams.positionRight != nil
            let hasPositionHeight = layoutParams.positionTop != nil && layoutParams.positionBottom != nil
            
            let useWidth = hasWidth
            let useHeight = hasHeight
            
            let useMinWidth = hasMinWidth
            let useMinHeight = hasMinHeight
            
            let useMaxWidth = hasMaxWidth
            let useMaxHeight = hasMaxHeight
            
            let usePositionWidth = hasPositionWidth
            let usePositionHeight = hasPositionHeight
            
            if useWidth {
                var width = layoutParams.width ?? measuredWidth * layoutParams.widthPercent!
                
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? measuredWidth * layoutParams.maxWidthPercent!
                    
                    width = min(width, maxWidth)
                }
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? measuredWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childExactWidth = width
            } else if usePositionWidth {
                var width = measuredWidth - layoutParams.positionLeft! - layoutParams.positionRight!
                
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? measuredWidth * layoutParams.maxWidthPercent!
                    
                    width = min(width, maxWidth)
                }
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? measuredWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childExactWidth = width
            } else {
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? measuredWidth * layoutParams.maxWidthPercent!
                    
                    childMostWidth = maxWidth
                }
            }
            
            if useHeight {
                var height = layoutParams.height ?? measuredHeight * layoutParams.heightPercent!
                
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? measuredHeight * layoutParams.maxHeightPercent!
                    
                    height = min(height, maxHeight)
                }
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? measuredHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childExactHeight = height
            } else if usePositionHeight {
                var height = measuredHeight - layoutParams.positionTop! - layoutParams.positionBottom!
                
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? measuredHeight * layoutParams.maxHeightPercent!
                    
                    height = min(height, maxHeight)
                }
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? measuredHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childExactHeight = height
            } else {
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? measuredHeight * layoutParams.maxHeightPercent!
                    
                    childMostHeight = maxHeight
                }
            }
            
            if layoutParams.aspectRatio != nil {
                if useWidth || usePositionWidth {
                    childExactHeight = childExactWidth! * layoutParams.aspectRatio!
                } else if useHeight || usePositionHeight {
                    childExactWidth = childExactHeight! * layoutParams.aspectRatio!
                }
            }
            
            let childSize = measureChild(
                view: child,
                exactWidth: childExactWidth,
                exactHeight: childExactHeight,
                mostWidth: childMostWidth,
                mostHeight: childMostHeight
            )
            
            var childWidth = childSize.width
            var childHeight = childSize.height
            
            if !(useWidth || usePositionWidth) {
                var width = childWidth
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? measuredWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childWidth = width
            }
            
            if !(useHeight || usePositionHeight) {
                var height = childHeight
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? measuredHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childHeight = height
            }
            
            if layoutParams.aspectRatio != nil
                && !(useWidth || usePositionWidth)
                && !(useHeight || usePositionHeight) {
                let hasMinOrMaxWidth = hasMinWidth || hasMaxWidth
                let hasMinOrMaxHeight = hasMinHeight || hasMaxHeight
                
                if hasMinOrMaxWidth {
                    childHeight = childWidth * layoutParams.aspectRatio!
                } else if hasMinOrMaxHeight {
                    childWidth = childHeight * layoutParams.aspectRatio!
                } else {
                    childHeight = childWidth * layoutParams.aspectRatio!
                }
            }
                        
            setChildSize(view: child, width: childWidth, height: childHeight)
        }
    }
    
    private func measureChild(
        view: UIView,
        exactWidth: Float?,
        exactHeight: Float?,
        mostWidth: Float?,
        mostHeight: Float?
    ) -> LayoutSize {
        if view is ViewLayout {
            return (view as! ViewLayout).measureRelativeChildren(
                exactWidth: exactWidth,
                exactHeight: exactHeight,
                mostWidth: mostWidth,
                mostHeight: mostHeight
            )
        }
        
        var constraintWidth = CGFloat.greatestFiniteMagnitude
        var constraintHeight = CGFloat.greatestFiniteMagnitude
        
        if exactWidth != nil {
            constraintWidth = CGFloat(exactWidth!)
        } else if mostWidth != nil {
            constraintWidth = CGFloat(mostWidth!)
        }
        
        if exactHeight != nil {
            constraintHeight = CGFloat(exactHeight!)
        } else if mostHeight != nil {
            constraintHeight = CGFloat(mostHeight!)
        }
        
        let constraintSize = CGSize(width: constraintWidth, height: constraintHeight)
        
        let fittingSize = view.sizeThatFits(constraintSize)
        
        let resolvedWidth = exactWidth ?? Float(fittingSize.width)
        let resolvedHeight = exactHeight ?? Float(fittingSize.height)
        
        return LayoutSize(width: resolvedWidth, height: resolvedHeight)
    }
    
    private func layoutChildren() {
        let measuredWidth = Float(frame.size.width)
        let measuredHeight = Float(frame.size.height)
        
        let paddingTop = layoutParams.padding.top
        let paddingLeft = layoutParams.padding.left
        let paddingBottom = layoutParams.padding.bottom
        let paddingRight = layoutParams.padding.right
        
        let paddingX = paddingLeft + paddingRight
        let paddingY = paddingTop + paddingBottom
        
        let innerWidth = measuredWidth - paddingX
        let innerHeight = measuredHeight - paddingY
        
        var contentWidth: Float = 0
        var contentHeight: Float = 0
        
        var top: Float = 0
        var left: Float = 0
        
        var relativeChildCount = 0
        
        for child in subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if isAbsolute {
                continue
            }
            
            relativeChildCount += 1
            
            let childWidth = Float(child.frame.size.width)
            let childHeight = Float(child.frame.size.height)
            
            let marginTop = layoutParams.margin.top
            let marginLeft = layoutParams.margin.left
            let marginBottom = layoutParams.margin.bottom
            let marginRight = layoutParams.margin.right
            
            let marginX = marginLeft + marginRight
            let marginY = marginTop + marginBottom
            
            let outerWidth = childWidth + marginX
            let outerHeight = childHeight + marginY
            
            if isHorizontal() {
                contentWidth += outerWidth
                
                contentHeight = max(contentHeight, outerHeight)
            } else {
                contentWidth = max(contentWidth, outerWidth)
                
                contentHeight += outerHeight
            }
        }
        
        var spaceDistribution: Float = 0
        
        if isHorizontal() {
            let startLeft = paddingLeft
            let centerLeft = paddingLeft + innerWidth / 2 - contentWidth / 2
            let endLeft = measuredWidth - paddingRight - contentWidth
            
            switch justifyContent {
            case .flexStart:
                left = isReversed() ? endLeft : startLeft
                
                break
                
            case .flexEnd:
                left = isReversed() ? startLeft : endLeft
                
                break
                
            case .start:
                left = startLeft
                
                break
                
            case .end:
                left = endLeft
                
                break
                
            case .center:
                left = centerLeft
                
                break
                
            case .spaceBetween:
                if relativeChildCount == 1 {
                    left = isReversed() ? endLeft : startLeft
                } else {
                    left = startLeft
                }
                
                if relativeChildCount >= 2 {
                    spaceDistribution = (innerWidth - contentWidth) / Float(relativeChildCount - 1)
                }
                
                break
                
            case .spaceAround:
                left = startLeft
                
                if relativeChildCount >= 1 {
                    spaceDistribution = (innerWidth - contentWidth) / Float(relativeChildCount)
                    
                    left += spaceDistribution / 2
                }
                
                break
                
            case .spaceEvenly:
                left = startLeft
                
                if relativeChildCount >= 1 {
                    spaceDistribution = (innerWidth - contentWidth) / Float(relativeChildCount - 1)
                    
                    left += spaceDistribution
                }
                
                break
            }
        } else {
            let startTop = paddingTop
            let centerTop = paddingTop + innerHeight / 2 - contentHeight / 2
            let endTop = measuredHeight - paddingBottom - contentHeight
            
            switch justifyContent {
            case .flexStart:
                top = isReversed() ? endTop : startTop
                
                break
                
            case .flexEnd:
                top = isReversed() ? startTop : endTop
                
                break
                
            case .start:
                top = startTop
                
                break
                
            case .end:
                top = endTop
                
                break
                
            case .center:
                top = centerTop
                
                break
                
            case .spaceBetween:
                if relativeChildCount == 1 {
                    top = isReversed() ? endTop : startTop
                } else {
                    top = startTop
                }
                
                if relativeChildCount >= 2 {
                    spaceDistribution = (innerHeight - contentHeight) / Float(relativeChildCount - 1)
                }
                
                break
                
            case .spaceAround:
                top = startTop
                
                if relativeChildCount >= 1 {
                    spaceDistribution = (innerHeight - contentHeight) / Float(relativeChildCount)
                    
                    top += spaceDistribution / 2
                }
                
                break
                
            case .spaceEvenly:
                top = startTop
                
                if relativeChildCount >= 1 {
                    spaceDistribution = (innerHeight - contentHeight) / Float(relativeChildCount + 1)
                    
                    top += spaceDistribution
                }
                
                break
            }
        }
        
        // relative
        
        for child in isReversed() ? subviews.reversed() : subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if isAbsolute {
                continue
            }
            
            let childWidth = Float(child.frame.size.width)
            let childHeight = Float(child.frame.size.height)
            
            let marginTop = layoutParams.margin.top
            let marginLeft = layoutParams.margin.left
            let marginBottom = layoutParams.margin.bottom
            let marginRight = layoutParams.margin.right
            
            let marginX = marginLeft + marginRight
            let marginY = marginTop + marginBottom
            
            let outerWidth = childWidth + marginX
            let outerHeight = childHeight + marginY
            
            let positionTop = layoutParams.positionTop
            let positionLeft = layoutParams.positionLeft
            let positionBottom = layoutParams.positionBottom
            let positionRight = layoutParams.positionRight
            
            var x: Float = 0
            var y: Float = 0
            
            let alignSelf = layoutParams.alignSelf ?? alignItems
            
            if isHorizontal() {
                x = left + marginLeft
                
                let startY = paddingTop + marginTop
                let centerY = paddingTop + marginTop + innerHeight / 2 - outerHeight / 2
                let endY = measuredHeight - paddingBottom - marginBottom - childHeight
                
                switch alignSelf {
                case .flexStart, .start:
                    y = startY
                    
                    break
                    
                case .flexEnd, .end:
                    y = endY
                    
                    break
                    
                case .center:
                    y = centerY
                    
                    break
                }
            } else {
                y = top + marginTop
                
                let startX = paddingLeft + marginLeft
                let centerX = paddingLeft + marginLeft + innerWidth / 2 - outerWidth / 2
                let endX = measuredWidth - paddingRight - marginRight - childWidth
                
                switch alignSelf {
                case .flexStart, .start:
                    x = startX
                    
                    break
                    
                case .flexEnd, .end:
                    x = endX
                    
                    break
                    
                case .center:
                    x = centerX
                    
                    break
                }
            }
            
            if positionLeft != nil {
                x += positionLeft!
            } else if positionRight != nil {
                x -= positionRight!
            }
            
            if positionTop != nil {
                y += positionTop!
            } else if positionBottom != nil {
                y -= positionBottom!
            }
                        
            setChildOrigin(view: child, x: x, y: y)
            
            if isHorizontal() {
                left += outerWidth + spaceDistribution
            } else {
                top += outerHeight + spaceDistribution
            }
        }
        
        // absolute
        
        for child in subviews {
            let layoutParams = child.layoutParams
            
            let isHidden = layoutParams.display == .none
            let isAbsolute = layoutParams.position == .absolute
            
            if isHidden {
                continue
            }
            
            if !isAbsolute {
                continue
            }
            
            let childWidth = Float(child.frame.size.width)
            let childHeight = Float(child.frame.size.height)
            
            let marginTop = layoutParams.margin.top
            let marginLeft = layoutParams.margin.left
            let marginBottom = layoutParams.margin.bottom
            let marginRight = layoutParams.margin.right
            
            let marginX = marginLeft + marginRight
            let marginY = marginTop + marginBottom
            
            let outerWidth = childWidth + marginX
            let outerHeight = childHeight + marginY
            
            let positionTop = layoutParams.positionTop
            let positionLeft = layoutParams.positionLeft
            let positionBottom = layoutParams.positionBottom
            let positionRight = layoutParams.positionRight
            
            var x: Float = 0
            var y: Float = 0
            
            let alignSelf = layoutParams.alignSelf ?? alignItems
            
            let startX = paddingLeft + marginLeft
            let centerX = paddingLeft + marginLeft + innerWidth / 2 - outerWidth / 2
            let endX = measuredWidth - paddingRight - marginRight - childWidth
            
            let startY = paddingTop + marginTop
            let centerY = paddingTop + marginTop + innerHeight / 2 - outerHeight / 2
            let endY = measuredHeight - paddingBottom - marginBottom - childHeight
            
            if isHorizontal() {
                switch justifyContent {
                case .flexStart, .spaceBetween:
                    x = isReversed() ? endX : startX
                    
                    break
                    
                case .flexEnd:
                    x = isReversed() ? startX : endX
                    
                    break
                    
                case .start:
                    x = startX
                    
                    break
                    
                case .end:
                    x = endX
                    
                    break
                    
                case .center, .spaceAround, .spaceEvenly:
                    x = centerX
                    
                    break
                }
                
                switch alignSelf {
                case .flexStart, .start:
                    y = startY
                    
                    break
                    
                case .flexEnd, .end:
                    y = endY
                    
                    break
                    
                case .center:
                    y = centerY
                    
                    break
                }
            } else {
                switch justifyContent {
                case .flexStart, .spaceBetween:
                    y = isReversed() ? endY : startY
                    
                    break
                    
                case .flexEnd:
                    y = isReversed() ? startY : endY
                    
                    break
                    
                case .start:
                    y = startY
                    
                    break
                    
                case .end:
                    y = endY
                    
                    break
                    
                case .center, .spaceAround, .spaceEvenly:
                    y = centerY
                    
                    break
                }
                    
                switch alignSelf {
                case .flexStart, .start:
                    x = startX
                    
                    break
                
                case .flexEnd, .end:
                    x = endX
                    
                    break
                    
                case .center:
                    x = centerX
                    
                    break
                }
            }
            
            if positionLeft != nil {
                x = positionLeft! + marginLeft
            } else if positionRight != nil {
                x = measuredWidth - positionRight! - marginRight - childWidth
            }
            
            if positionTop != nil {
                y = positionTop! + marginTop
            } else if positionBottom != nil {
                y = measuredHeight - positionBottom! - marginBottom - childHeight
            }
                        
            setChildOrigin(view: child, x: x, y: y)
        }
    }
    
    private func setChildSize(view: UIView, width: Float, height: Float) {
        view.frame.size = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        if view is ViewLayout {
            (view as! ViewLayout).measureAbsoluteChildren()
        }
    }
    
    private func setChildOrigin(view: UIView, x: Float, y: Float) {
        view.frame.origin = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        if view is ViewLayout {
            (view as! ViewLayout).layoutChildren()
        }
        
        let layoutParams = view.layoutParams
        
        layoutParams.callOnLayout()
    }
    
    override func layoutSubviews() {
        // print("layoutSubviews \(id)")
        
        // no-op
    }
}
