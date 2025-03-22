import UIKit

class ViewLayout: UIView {
    static var staticId = 0
    
    public var id: Int
    
    public var flexDirection: LayoutParams.FlexDirection = .column
    
    public var justifyContent: LayoutParams.JustifyContent = .flexStart
    public var alignItems: LayoutParams.AlignItems = .flexStart
    
    public var gap: Float = 0
    
    public var onSafeAreaInsetsChange: (() -> Void)?
    
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
        isViewGroup = true
        
        clipsToBounds = false
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        onSafeAreaInsetsChange?()
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
        
        measure(
            specWidth: width,
            specHeight: height,
            specWidthMode: MeasureSpec.EXACTLY,
            specHeightMode: MeasureSpec.EXACTLY
        )
        
        layout(x: 0, y: 0)
        
        setNeedsLayout()
    }
    
    override func measure(
        specWidth: CGFloat,
        specHeight: CGFloat,
        specWidthMode: Int,
        specHeightMode: Int
    ) {
        let isParentViewLayout = superview is ViewLayout
        
        if layoutParams.remeasured {
            frame.size.width = specWidth
            frame.size.height = specHeight
            
            measureAbsoluteChildren()
            
            return
        }
        
        let paddingTop = layoutParams.padding.top
        let paddingLeft = layoutParams.padding.left
        let paddingBottom = layoutParams.padding.bottom
        let paddingRight = layoutParams.padding.right
        
        let paddingX = paddingLeft + paddingRight
        let paddingY = paddingTop + paddingBottom
        
        let innerWidth = Float(specWidth) - paddingX
        let innerHeight = Float(specHeight) - paddingY
        
        var contentWidth: Float = 0
        var contentHeight: Float = 0
        
        let canItemsExpand = isHorizontal()
        ? specWidthMode != MeasureSpec.UNSPECIFIED
        : specHeightMode != MeasureSpec.UNSPECIFIED
        
        var availableSize = isHorizontal() ? innerWidth : innerHeight
        
        var flexCount: Int = 0
        var totalFlex: Int = 0
        
        var relativeChildCount: Int = 0
        
        // relative non-flex non-expandable
        
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
            
            let marginTop = layoutParams.margin.top
            let marginLeft = layoutParams.margin.left
            let marginBottom = layoutParams.margin.bottom
            let marginRight = layoutParams.margin.right
            
            let marginX = marginLeft + marginRight
            let marginY = marginTop + marginBottom
            
            availableSize -= isHorizontal() ? marginX : marginY
            
            let hasFlex = layoutParams.flex != nil
            
            let useFlex = hasFlex && canItemsExpand
            
            if useFlex {
                flexCount += 1
                
                totalFlex += layoutParams.flex!
                
                continue
            }
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let useWidth = hasWidth && (layoutParams.widthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useHeight = hasHeight && (layoutParams.heightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            let useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            let useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            if isHorizontal() {
                if !useWidth {
                    continue
                }
            } else {
                if !useHeight {
                    continue
                }
            }
            
            var childSpecWidth: Float = specWidthMode != MeasureSpec.UNSPECIFIED ? innerWidth : 0
            var childSpecHeight: Float = specHeightMode != MeasureSpec.UNSPECIFIED ? innerHeight : 0
            var childSpecWidthMode: Int = specWidthMode != MeasureSpec.UNSPECIFIED ? MeasureSpec.AT_MOST : MeasureSpec.UNSPECIFIED
            var childSpecHeightMode: Int = specHeightMode != MeasureSpec.UNSPECIFIED ? MeasureSpec.AT_MOST : MeasureSpec.UNSPECIFIED
            
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
                
                childSpecWidth = width
                childSpecWidthMode = MeasureSpec.EXACTLY
            } else {
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                    
                    childSpecWidth = maxWidth
                    childSpecWidthMode = MeasureSpec.AT_MOST
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
                
                childSpecHeight = height
                childSpecHeightMode = MeasureSpec.EXACTLY
            } else {
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                    
                    childSpecHeight = maxHeight
                    childSpecHeightMode = MeasureSpec.AT_MOST
                }
            }
            
            if layoutParams.aspectRatio != nil {
                if useWidth {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                    childSpecHeightMode = MeasureSpec.EXACTLY
                } else if useHeight {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                    childSpecWidthMode = MeasureSpec.EXACTLY
                }
            }
            
            measureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
            
            childSpecWidth = Float(child.frame.size.width)
            childSpecHeight = Float(child.frame.size.height)
            
            childSpecWidthMode = MeasureSpec.EXACTLY
            childSpecHeightMode = MeasureSpec.EXACTLY
            
            if !useWidth {
                var width = childSpecWidth
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childSpecWidth = width
            }
            
            if !useHeight {
                var height = childSpecHeight
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childSpecHeight = height
            }
            
            if layoutParams.aspectRatio != nil && !useWidth && !useHeight {
                let hasAnyWidth = hasWidth || hasMinWidth || hasMaxWidth
                let hasAnyHeight = hasHeight || hasMinHeight || hasMaxHeight
                
                if hasAnyWidth {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                } else if hasAnyHeight {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                } else {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                }
            }
            
            remeasureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
            
            let childWidth = Float(child.frame.size.width)
            let childHeight = Float(child.frame.size.height)
            
            availableSize -= isHorizontal() ? childWidth : childHeight
        }
        
        let totalGap = gap * Float(relativeChildCount - 1)
        
        availableSize -= totalGap
        
        // relative expandable
        
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
            
            let useFlex = hasFlex && canItemsExpand
            
            if useFlex {
                continue
            }
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let useWidth = hasWidth && (layoutParams.widthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useHeight = hasHeight && (layoutParams.heightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            let useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            let useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            if isHorizontal() {
                if useWidth {
                    continue
                }
            } else {
                if useHeight {
                    continue
                }
            }
            
            var childSpecWidth: Float = specWidthMode != MeasureSpec.UNSPECIFIED ? (isHorizontal() ? availableSize : innerWidth) : 0
            var childSpecHeight: Float = specHeightMode != MeasureSpec.UNSPECIFIED ? (!isHorizontal() ? availableSize : innerHeight) : 0
            var childSpecWidthMode: Int = specWidthMode != MeasureSpec.UNSPECIFIED ? MeasureSpec.AT_MOST : MeasureSpec.UNSPECIFIED
            var childSpecHeightMode: Int = specHeightMode != MeasureSpec.UNSPECIFIED ? MeasureSpec.AT_MOST : MeasureSpec.UNSPECIFIED
            
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
                
                childSpecWidth = width
                childSpecWidthMode = MeasureSpec.EXACTLY
            } else {
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                    
                    childSpecWidth = maxWidth
                    childSpecWidthMode = MeasureSpec.AT_MOST
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
                
                childSpecHeight = height
                childSpecHeightMode = MeasureSpec.EXACTLY
            } else {
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                    
                    childSpecHeight = maxHeight
                    childSpecHeightMode = MeasureSpec.AT_MOST
                }
            }
            
            if layoutParams.aspectRatio != nil {
                if useWidth {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                    childSpecHeightMode = MeasureSpec.EXACTLY
                } else if useHeight {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                    childSpecWidthMode = MeasureSpec.EXACTLY
                }
            }
            
            measureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
            
            childSpecWidth = Float(child.frame.size.width)
            childSpecHeight = Float(child.frame.size.height)
            
            childSpecWidthMode = MeasureSpec.EXACTLY
            childSpecHeightMode = MeasureSpec.EXACTLY
            
            if !useWidth {
                var width = childSpecWidth
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childSpecWidth = width
            }
            
            if !useHeight {
                var height = childSpecHeight
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childSpecHeight = height
            }
            
            if layoutParams.aspectRatio != nil && !useWidth && !useHeight {
                let hasAnyWidth = hasWidth || hasMinWidth || hasMaxWidth
                let hasAnyHeight = hasHeight || hasMinHeight || hasMaxHeight
                
                if hasAnyWidth {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                } else if hasAnyHeight {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                } else {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                }
            }
            
            remeasureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
            
            let childWidth = Float(child.frame.size.width)
            let childHeight = Float(child.frame.size.height)
            
            availableSize -= isHorizontal() ? childWidth : childHeight
        }
        
        // flex
        
        var flexBaseSize: Float = 0
        var flexDistribution: Float = 0
        
        if flexCount > 0 {
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
            
            let useFlex = hasFlex && canItemsExpand
            
            if !useFlex {
                continue
            }
            
            let flexSize = flexBaseSize * Float(layoutParams.flex!) + flexDistribution
            
            var childSpecWidth: Float = specWidthMode != MeasureSpec.UNSPECIFIED ? innerWidth : 0
            var childSpecHeight: Float = specHeightMode != MeasureSpec.UNSPECIFIED ? innerHeight : 0
            var childSpecWidthMode: Int = specWidthMode != MeasureSpec.UNSPECIFIED ? MeasureSpec.AT_MOST : MeasureSpec.UNSPECIFIED
            var childSpecHeightMode: Int = specHeightMode != MeasureSpec.UNSPECIFIED ? MeasureSpec.AT_MOST : MeasureSpec.UNSPECIFIED
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let useWidth = hasWidth && (layoutParams.widthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useHeight = hasHeight && (layoutParams.heightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            let useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            let useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == nil || specWidthMode != MeasureSpec.UNSPECIFIED)
            let useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == nil || specHeightMode != MeasureSpec.UNSPECIFIED)
            
            if isHorizontal() {
                childSpecWidth = flexSize
                childSpecWidthMode = MeasureSpec.EXACTLY
                
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
                    
                    childSpecHeight = height
                    childSpecHeightMode = MeasureSpec.EXACTLY
                } else {
                    if useMaxHeight {
                        let maxHeight = layoutParams.maxHeight ?? innerHeight * layoutParams.maxHeightPercent!
                        
                        childSpecHeight = maxHeight
                        childSpecHeightMode = MeasureSpec.AT_MOST
                    }
                }
                
                if layoutParams.aspectRatio != nil {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                    childSpecHeightMode = MeasureSpec.EXACTLY
                    
                }
            } else {
                childSpecHeight = flexSize
                childSpecHeightMode = MeasureSpec.EXACTLY
                
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
                    
                    childSpecWidth = width
                    childSpecWidthMode = MeasureSpec.EXACTLY
                } else {
                    if useMaxWidth {
                        let maxWidth = layoutParams.maxWidth ?? innerWidth * layoutParams.maxWidthPercent!
                        
                        childSpecWidth = maxWidth
                        childSpecWidthMode = MeasureSpec.AT_MOST
                    }
                }
                
                if layoutParams.aspectRatio != nil {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                    childSpecWidthMode = MeasureSpec.EXACTLY
                }
            }
            
            measureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
            
            childSpecWidth = Float(child.frame.size.width)
            childSpecHeight = Float(child.frame.size.height)
            
            childSpecWidthMode = MeasureSpec.EXACTLY
            childSpecHeightMode = MeasureSpec.EXACTLY
            
            if layoutParams.aspectRatio == nil {
                if isHorizontal() {
                    if !useHeight {
                        var height = childSpecHeight
                        
                        if useMinHeight {
                            let minHeight = layoutParams.minHeight ?? innerHeight * layoutParams.minHeightPercent!
                            
                            height = max(height, minHeight)
                        }
                        
                        childSpecHeight = height
                    }
                } else {
                    if !useWidth {
                        var width = childSpecWidth
                        
                        if useMinWidth {
                            let minWidth = layoutParams.minWidth ?? innerWidth * layoutParams.minWidthPercent!
                            
                            width = max(width, minWidth)
                        }
                        
                        childSpecWidth = width
                    }
                }
            }
            
            remeasureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
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
        
        if isHorizontal() {
            contentWidth += totalGap
        } else {
            contentHeight += totalGap
        }
        
        let paddedContentWidth = contentWidth + paddingX
        let paddedContentHeight = contentHeight + paddingY
        
        let resolvedWidth = resolveSize(size: CGFloat(paddedContentWidth), specSize: specWidth, specSizeMode: specWidthMode)
        let resolvedHeight = resolveSize(size: CGFloat(paddedContentHeight), specSize: specHeight, specSizeMode: specHeightMode)
        
        frame.size.width = resolvedWidth
        frame.size.height = resolvedHeight
        
        if !isParentViewLayout {
            measureAbsoluteChildren()
        }
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
            
            var childSpecWidth: Float = 0
            var childSpecHeight: Float = 0
            var childSpecWidthMode: Int = MeasureSpec.UNSPECIFIED
            var childSpecHeightMode: Int = MeasureSpec.UNSPECIFIED
            
            let hasWidth = layoutParams.width != nil || layoutParams.widthPercent != nil
            let hasHeight = layoutParams.height != nil || layoutParams.heightPercent != nil
            
            let hasMinWidth = layoutParams.minWidth != nil || layoutParams.minWidthPercent != nil
            let hasMinHeight = layoutParams.minHeight != nil || layoutParams.minHeightPercent != nil
            
            let hasMaxWidth = layoutParams.maxWidth != nil || layoutParams.maxWidthPercent != nil
            let hasMaxHeight = layoutParams.maxHeight != nil || layoutParams.maxHeightPercent != nil
            
            let hasPositionWidth = (layoutParams.positionLeft != nil || layoutParams.positionLeftPercent != nil)
            && (layoutParams.positionRight != nil || layoutParams.positionRightPercent != nil)
            
            let hasPositionHeight = (layoutParams.positionTop != nil || layoutParams.positionTopPercent != nil)
            && (layoutParams.positionBottom != nil || layoutParams.positionBottomPercent != nil)
            
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
                
                childSpecWidth = width
                childSpecWidthMode = MeasureSpec.EXACTLY
            } else if usePositionWidth {
                let left = layoutParams.positionLeft ?? measuredWidth * layoutParams.positionLeftPercent!
                
                let right = layoutParams.positionRight ?? measuredWidth * layoutParams.positionRightPercent!
                
                var width = measuredWidth - left - right
                
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? measuredWidth * layoutParams.maxWidthPercent!
                    
                    width = min(width, maxWidth)
                }
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? measuredWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childSpecWidth = width
                childSpecWidthMode = MeasureSpec.EXACTLY
            } else {
                if useMaxWidth {
                    let maxWidth = layoutParams.maxWidth ?? measuredWidth * layoutParams.maxWidthPercent!
                    
                    childSpecWidth = maxWidth
                    childSpecWidthMode = MeasureSpec.AT_MOST
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
                
                childSpecHeight = height
                childSpecHeightMode = MeasureSpec.EXACTLY
            } else if usePositionHeight {
                let top = layoutParams.positionTop ?? measuredHeight * layoutParams.positionTopPercent!
                
                let bottom = layoutParams.positionBottom ?? measuredHeight * layoutParams.positionBottomPercent!
                
                var height = measuredHeight - top - bottom
                
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? measuredHeight * layoutParams.maxHeightPercent!
                    
                    height = min(height, maxHeight)
                }
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? measuredHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childSpecHeight = height
                childSpecHeightMode = MeasureSpec.EXACTLY
            } else {
                if useMaxHeight {
                    let maxHeight = layoutParams.maxHeight ?? measuredHeight * layoutParams.maxHeightPercent!
                    
                    childSpecHeight = maxHeight
                    childSpecHeightMode = MeasureSpec.AT_MOST
                }
            }
            
            if layoutParams.aspectRatio != nil {
                if useWidth || usePositionWidth {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                    childSpecHeightMode = MeasureSpec.EXACTLY
                } else if useHeight || usePositionHeight {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                    childSpecWidthMode = MeasureSpec.EXACTLY
                }
            }
            
            measureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
            
            childSpecWidth = Float(child.frame.size.width)
            childSpecHeight = Float(child.frame.size.height)
            
            childSpecWidthMode = MeasureSpec.EXACTLY
            childSpecHeightMode = MeasureSpec.EXACTLY
            
            if !(useWidth || usePositionWidth) {
                var width = childSpecWidth
                
                if useMinWidth {
                    let minWidth = layoutParams.minWidth ?? measuredWidth * layoutParams.minWidthPercent!
                    
                    width = max(width, minWidth)
                }
                
                childSpecWidth = width
            }
            
            if !(useHeight || usePositionHeight) {
                var height = childSpecHeight
                
                if useMinHeight {
                    let minHeight = layoutParams.minHeight ?? measuredHeight * layoutParams.minHeightPercent!
                    
                    height = max(height, minHeight)
                }
                
                childSpecHeight = height
            }
            
            if layoutParams.aspectRatio != nil
                && !(useWidth || usePositionWidth)
                && !(useHeight || usePositionHeight) {
                let hasMinOrMaxWidth = hasMinWidth || hasMaxWidth
                let hasMinOrMaxHeight = hasMinHeight || hasMaxHeight
                
                if hasMinOrMaxWidth {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                } else if hasMinOrMaxHeight {
                    childSpecWidth = childSpecHeight * layoutParams.aspectRatio!
                } else {
                    childSpecHeight = childSpecWidth * layoutParams.aspectRatio!
                }
            }
            
            remeasureChild(
                view: child,
                specWidth: childSpecWidth,
                specHeight: childSpecHeight,
                specWidthMode: childSpecWidthMode,
                specHeightMode: childSpecHeightMode
            )
        }
    }
    
    override func layout(x: CGFloat, y: CGFloat) {
        super.layout(x: x, y: y)
        
        if subviews.isEmpty {
            return
        }
        
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
        
        var relativeChildCount: Int = 0
        
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
        
        let totalGap = gap * Float(relativeChildCount - 1)
        
        if isHorizontal() {
            contentWidth += totalGap
        } else {
            contentHeight += totalGap
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
            let positionTopPercent = layoutParams.positionTopPercent
            
            let positionLeft = layoutParams.positionLeft
            let positionLeftPercent = layoutParams.positionLeftPercent
            
            let positionBottom = layoutParams.positionBottom
            let positionBottomPercent = layoutParams.positionBottomPercent
            
            let positionRight = layoutParams.positionRight
            let positionRightPercent = layoutParams.positionRightPercent
            
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
            } else if positionLeftPercent != nil {
                x += measuredWidth * positionLeftPercent!
            } else if positionRight != nil {
                x -= positionRight!
            } else if positionRightPercent != nil {
                x -= measuredWidth * positionRightPercent!
            }
            
            if positionTop != nil {
                y += positionTop!
            } else if positionTopPercent != nil {
                y += measuredHeight * positionTopPercent!
            } else if positionBottom != nil {
                y -= positionBottom!
            } else if positionBottomPercent != nil {
                y -= measuredHeight * positionBottomPercent!
            }
            
            layoutChild(view: child, x: x, y: y)
            
            if isHorizontal() {
                left += outerWidth + gap + spaceDistribution
            } else {
                top += outerHeight + gap + spaceDistribution
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
            let positionTopPercent = layoutParams.positionTopPercent
            
            let positionLeft = layoutParams.positionLeft
            let positionLeftPercent = layoutParams.positionLeftPercent
            
            let positionBottom = layoutParams.positionBottom
            let positionBottomPercent = layoutParams.positionBottomPercent
            
            let positionRight = layoutParams.positionRight
            let positionRightPercent = layoutParams.positionRightPercent
            
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
            } else if positionLeftPercent != nil {
                x = measuredWidth * positionLeftPercent! + marginLeft
            } else if positionRight != nil {
                x = measuredWidth - positionRight! - marginRight - childWidth
            } else if positionRightPercent != nil {
                x = measuredWidth - measuredWidth * positionRightPercent! - marginRight - childWidth
            }
            
            if positionTop != nil {
                y = positionTop! + marginTop
            } else if positionTopPercent != nil {
                y = measuredHeight * positionTopPercent! + marginTop
            } else if positionBottom != nil {
                y = measuredHeight - positionBottom! - marginBottom - childHeight
            } else if positionBottomPercent != nil {
                y = measuredHeight - measuredHeight * positionBottomPercent! - marginBottom - childHeight
            }
            
            layoutChild(view: child, x: x, y: y)
        }
    }
    
    private func measureChild(
        view: UIView,
        specWidth: Float,
        specHeight: Float,
        specWidthMode: Int,
        specHeightMode: Int
    ) {
        view.measure(
            specWidth: CGFloat(specWidth),
            specHeight: CGFloat(specHeight),
            specWidthMode: specWidthMode,
            specHeightMode: specHeightMode
        )
    }
    
    private func remeasureChild(
        view: UIView,
        specWidth: Float,
        specHeight: Float,
        specWidthMode: Int,
        specHeightMode: Int
    ) {
        let layoutParams = view.layoutParams
        
        let isViewLayout = view is ViewLayout
        
        let hasSpecChanged = specWidth != Float(view.frame.size.width)
            || specHeight != Float(view.frame.size.height)
        
        let remeasure = isViewLayout || hasSpecChanged
        
        if !remeasure {
            return
        }
        
        layoutParams.remeasured = true
        
        view.measure(
            specWidth: CGFloat(specWidth),
            specHeight: CGFloat(specHeight),
            specWidthMode: specWidthMode,
            specHeightMode: specHeightMode
        )
        
        layoutParams.remeasured = false
    }
    
    private func layoutChild(view: UIView, x: Float, y: Float) {
        view.layout(x: CGFloat(x), y: CGFloat(y))
        
        let layoutParams = view.layoutParams
        
        layoutParams.callOnLayout()
    }
    
    override func layoutSubviews() {
        // print("layoutSubviews \(id)")
        
        // no-op
    }
}
