import UIKit

open class DetonatorDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    var detonator: Detonator?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = ViewLayoutController()
        
        let rootView = rootViewController.view as! ViewLayout
        
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        detonator = Detonator(rootView: rootView, filename: "index")
        
        return true
    }
}
