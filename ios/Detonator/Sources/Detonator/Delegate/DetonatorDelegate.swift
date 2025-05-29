import UIKit

open class DetonatorDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public var detonator: Detonator!

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = ViewLayoutController()
        
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        let rootView = rootViewController.view as! ViewLayout
        
        detonator = Detonator(rootView: rootView, filename: "index")
        
        setModuleClasses()
        
        detonator.initialize()
        
        return true
    }
    
    open func setModuleClasses() -> Void {
    }
}
