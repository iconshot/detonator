import UIKit

enum State: String {
    case background
    case foreground
    case active
}

class AppStateModule: Module {
    var currentState: State = .background
    
    override func register() {
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
    
    private func emit() {
        detonator.eventEmitter.emit(name: "com.iconshot.detonator.appstate/state", data: currentState.rawValue)
    }
    
    @objc func appDidEnterBackground() {
        currentState = .background
        
        emit()
    }
    
    @objc func appWillEnterForeground() {
        currentState = .foreground
        
        emit()
    }
    
    @objc func appDidBecomeActive() {
        currentState = .active
        
        emit()
    }
}
