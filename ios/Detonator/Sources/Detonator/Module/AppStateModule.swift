import UIKit

enum State: String {
    case inactive
    case background
    case active
}

class AppStateModule: Module {
    private var state: State = .background
    
    private func updateState(state: State) {
        if state == self.state {
            return
        }
        
        self.state = state
        
        detonator.send("com.iconshot.detonator.appstate.state", state.rawValue)
    }
    
    override func setUp() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func appDidEnterBackground() {
        updateState(state: .background)
    }
    
    @objc func appWillEnterForeground() {
        updateState(state: .inactive)
    }
    
    @objc func appDidBecomeActive() {
        updateState(state: .active)
    }
}
