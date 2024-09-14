import UIKit

class LayoutParams {
    enum Position {
        case relative, absolute
    }
    
    enum Display {
        case flex, none
    }
    
    enum FlexDirection {
        case row, rowReverse, column, columnReverse
    }
    
    enum JustifyContent {
        case flexStart, flexEnd, start, end, center, spaceBetween, spaceAround, spaceEvenly
    }
    
    enum AlignItems {
        case flexStart, flexEnd, start, end, center
    }
    
    var position: Position = .relative
    
    var display: Display = .flex
    
    var width: Float?
    var height: Float?
    
    var widthPercent: Float?
    var heightPercent: Float?
    
    var minWidth: Float?
    var minWidthPercent: Float?
    
    var maxWidth: Float?
    var maxWidthPercent: Float?
    
    var minHeight: Float?
    var minHeightPercent: Float?
    
    var maxHeight: Float?
    var maxHeightPercent: Float?
    
    var flex: Int?
    var alignSelf: AlignItems?
    
    var aspectRatio: Float?
    
    var positionTop: Float?
    var positionLeft: Float?
    var positionBottom: Float?
    var positionRight: Float?
    
    var margin: LayoutInsets = LayoutInsets.zero
    var padding: LayoutInsets = LayoutInsets.zero
    
    var onLayoutClosures: [String: (() -> Void)] = [:]
    
    func callOnLayout() {
        for (_, onLayoutClosure) in onLayoutClosures {
            onLayoutClosure()
        }
    }
}

struct LayoutInsets {
    var top: Float
    var left: Float
    var bottom: Float
    var right: Float
    
    static var zero: LayoutInsets = LayoutInsets(top: 0, left: 0, bottom: 0, right: 0) 
}

struct LayoutSize {
    var width: Float
    var height: Float
    
    static var zero: LayoutSize = LayoutSize(width: 0, height: 0)
}
