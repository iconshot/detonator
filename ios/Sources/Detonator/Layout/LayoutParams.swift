import UIKit

public class LayoutParams {
    public enum Position {
        case relative, absolute
    }
    
    public enum Display {
        case flex, none
    }
    
    public enum FlexDirection {
        case row, rowReverse, column, columnReverse
    }
    
    public enum JustifyContent {
        case flexStart, flexEnd, start, end, center, spaceBetween, spaceAround, spaceEvenly
    }
    
    public enum AlignItems {
        case flexStart, flexEnd, start, end, center
    }
    
    public var remeasured: Bool = false
    
    public var position: Position = .relative
    
    public var display: Display = .flex
    
    public var width: Float?
    public var height: Float?
    
    public var widthPercent: Float?
    public var heightPercent: Float?
    
    public var minWidth: Float?
    public var minWidthPercent: Float?
    
    public var maxWidth: Float?
    public var maxWidthPercent: Float?
    
    public var minHeight: Float?
    public var minHeightPercent: Float?
    
    public var maxHeight: Float?
    public var maxHeightPercent: Float?
    
    public var flex: Int?
    public var alignSelf: AlignItems?
    
    public var aspectRatio: Float?
    
    public var positionTop: Float?
    public var positionLeft: Float?
    public var positionBottom: Float?
    public var positionRight: Float?
    
    public var margin: LayoutInsets = LayoutInsets.zero
    public var padding: LayoutInsets = LayoutInsets.zero
    
    public var onLayoutClosures: [String: (() -> Void)] = [:]
    
    public func callOnLayout() {
        for (_, onLayoutClosure) in onLayoutClosures {
            onLayoutClosure()
        }
    }
}

public struct LayoutInsets {
    var top: Float
    var left: Float
    var bottom: Float
    var right: Float
    
    static var zero: LayoutInsets = LayoutInsets(top: 0, left: 0, bottom: 0, right: 0)
}

public struct LayoutSize {
    var width: Float
    var height: Float
    
    static var zero: LayoutSize = LayoutSize(width: 0, height: 0)
}
