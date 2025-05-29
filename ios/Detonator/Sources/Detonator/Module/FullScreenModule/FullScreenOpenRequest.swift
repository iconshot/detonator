import UIKit

class FullScreenOpenRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let elementEdge = edge.children.first!
        
        let view = elementEdge.element!.view as! ViewLayout
        
        let parent = view.superview!
        
        let index = parent.subviews.index(of: view)!
        
        let layoutParams = view.layoutParams
        
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            error(message: "Unable to open full screen.")
            
            return
        }
        
        guard let rootViewController = keyWindow.rootViewController else {
            error(message: "Unable to open full screen.")
            
            return
        }
        
        let fullScreenViewController = FullScreenViewController()
        
        let tmpLayoutParams = LayoutParams()
        
        tmpLayoutParams.position = layoutParams.position
        tmpLayoutParams.display = layoutParams.display
        tmpLayoutParams.width = layoutParams.width
        tmpLayoutParams.widthPercent = layoutParams.widthPercent
        tmpLayoutParams.maxWidth = layoutParams.maxWidth
        tmpLayoutParams.maxWidthPercent = layoutParams.maxWidthPercent
        tmpLayoutParams.minWidth = layoutParams.minWidth
        tmpLayoutParams.minWidthPercent = layoutParams.minWidthPercent
        tmpLayoutParams.height = layoutParams.height
        tmpLayoutParams.heightPercent = layoutParams.heightPercent
        tmpLayoutParams.maxHeight = layoutParams.maxHeight
        tmpLayoutParams.maxHeightPercent = layoutParams.maxHeightPercent
        tmpLayoutParams.minHeight = layoutParams.minHeight
        tmpLayoutParams.minHeightPercent = layoutParams.minHeightPercent
        tmpLayoutParams.flex = layoutParams.flex
        tmpLayoutParams.alignSelf = layoutParams.alignSelf
        tmpLayoutParams.aspectRatio = layoutParams.aspectRatio
        tmpLayoutParams.positionTop = layoutParams.positionTop
        tmpLayoutParams.positionTopPercent = layoutParams.positionTopPercent
        tmpLayoutParams.positionLeft = layoutParams.positionLeft
        tmpLayoutParams.positionLeftPercent = layoutParams.positionLeftPercent
        tmpLayoutParams.positionBottom = layoutParams.positionBottom
        tmpLayoutParams.positionBottomPercent = layoutParams.positionBottomPercent
        tmpLayoutParams.positionRight = layoutParams.positionRight
        tmpLayoutParams.positionRightPercent = layoutParams.positionRightPercent
        tmpLayoutParams.margin = layoutParams.margin
        
        layoutParams.position = .relative
        layoutParams.display = .flex
        layoutParams.width = nil
        layoutParams.widthPercent = 1
        layoutParams.maxWidth = nil
        layoutParams.maxWidthPercent = nil
        layoutParams.minWidth = nil
        layoutParams.minWidthPercent = nil
        layoutParams.height = nil
        layoutParams.heightPercent = 1
        layoutParams.maxHeight = nil
        layoutParams.maxHeightPercent = nil
        layoutParams.minHeight = nil
        layoutParams.minHeightPercent = nil
        layoutParams.flex = nil
        layoutParams.alignSelf = nil
        layoutParams.aspectRatio = nil
        layoutParams.positionTop = nil
        layoutParams.positionTopPercent = nil
        layoutParams.positionLeft = nil
        layoutParams.positionLeftPercent = nil
        layoutParams.positionBottom = nil
        layoutParams.positionBottomPercent = nil
        layoutParams.positionRight = nil
        layoutParams.positionRightPercent = nil
        layoutParams.margin = LayoutInsets.zero
        
        fullScreenViewController.view.addSubview(view)
        
        fullScreenViewController.modalPresentationStyle = .fullScreen
        
        rootViewController.present(fullScreenViewController, animated: false, completion: nil)
        
        FullScreenModule.parent = parent
        FullScreenModule.view = view
        FullScreenModule.index = index
        FullScreenModule.layoutParams = tmpLayoutParams
        FullScreenModule.fullScreenViewController = fullScreenViewController
        
        detonator.performLayout()
        
        end()
    }
}
