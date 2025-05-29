import UIKit

public class ViewLayoutController: UIViewController {
    private var height: CGFloat? = nil
    
    override public func loadView() {
        view = ViewLayout()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let view = view as! ViewLayout
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if height == nil {
                height = view.frame.size.height
            }
            
            let tmpHeight = height! - keyboardFrame.height
            
            if tmpHeight == view.frame.size.height {
                return
            }
            
            view.frame.size.height = tmpHeight
            
            view.performLayout()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let view = view as! ViewLayout

        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let tmpHeight = height!
            
            height = nil
            
            if tmpHeight == view.frame.size.height {
                return
            }
            
            view.frame.size.height = tmpHeight
            
            view.performLayout()
        }
    }
}
