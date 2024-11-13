import UIKit

open class DetonatorDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public var detonator: Detonator?

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = ViewLayoutController()
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        let rootView = rootViewController.view as! ViewLayout

        detonator = Detonator(rootView: rootView, filename: "index")
        
        return true
    }
}
