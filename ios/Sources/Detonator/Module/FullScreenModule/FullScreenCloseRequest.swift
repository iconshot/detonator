import Foundation

class FullScreenCloseRequest: Request {
    override public func run() {
        let view = FullScreenModule.view!
        
        let layoutParams = view.layoutParams
        let tmpLayoutParams = FullScreenModule.layoutParams!
        
        layoutParams.position = tmpLayoutParams.position
        layoutParams.display = tmpLayoutParams.display
        layoutParams.width = tmpLayoutParams.width
        layoutParams.widthPercent = tmpLayoutParams.widthPercent
        layoutParams.maxWidth = tmpLayoutParams.maxWidth
        layoutParams.maxWidthPercent = tmpLayoutParams.maxWidthPercent
        layoutParams.minWidth = tmpLayoutParams.minWidth
        layoutParams.minWidthPercent = tmpLayoutParams.minWidthPercent
        layoutParams.height = tmpLayoutParams.height
        layoutParams.heightPercent = tmpLayoutParams.heightPercent
        layoutParams.maxHeight = tmpLayoutParams.maxHeight
        layoutParams.maxHeightPercent = tmpLayoutParams.maxHeightPercent
        layoutParams.minHeight = tmpLayoutParams.minHeight
        layoutParams.minHeightPercent = tmpLayoutParams.minHeightPercent
        layoutParams.flex = tmpLayoutParams.flex
        layoutParams.alignSelf = tmpLayoutParams.alignSelf
        layoutParams.aspectRatio = tmpLayoutParams.aspectRatio
        layoutParams.positionTop = tmpLayoutParams.positionTop
        layoutParams.positionTopPercent = tmpLayoutParams.positionTopPercent
        layoutParams.positionLeft = tmpLayoutParams.positionLeft
        layoutParams.positionLeftPercent = tmpLayoutParams.positionLeftPercent
        layoutParams.positionBottom = tmpLayoutParams.positionBottom
        layoutParams.positionBottomPercent = tmpLayoutParams.positionBottomPercent
        layoutParams.positionRight = tmpLayoutParams.positionRight
        layoutParams.positionRightPercent = tmpLayoutParams.positionRightPercent
        layoutParams.margin = tmpLayoutParams.margin
        
        FullScreenModule.parent!.insertSubview(view, at: FullScreenModule.index!)
        
        FullScreenModule.controller!.dismiss(animated: false)
        
        FullScreenModule.parent = nil
        FullScreenModule.view = nil
        FullScreenModule.index = nil
        FullScreenModule.layoutParams = nil
        FullScreenModule.controller = nil
        
        detonator.performLayout()
        
        end()
    }
}
