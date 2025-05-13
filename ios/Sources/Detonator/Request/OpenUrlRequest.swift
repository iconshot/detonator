import Foundation
import UIKit

class OpenUrlRequest: Request {
    override public func run() {
        let urlString: String! = decodeData()
        
        guard let url = URL(string: urlString) else {
            error(message: "Not a valid url.")
            
            return
        }
        
        if !UIApplication.shared.canOpenURL(url) {
            error(message: "Can't open url.")
            
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        end()
    }
}
