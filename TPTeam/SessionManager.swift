private let _SessionManagerSharedInstance = SessionManager()

class SessionManager  {
    class var sharedInstance : SessionManager {
        return _SessionManagerSharedInstance
    }
    
    var fbUser : FBGraphUser?
    var friends : [AnyObject] = []
    var team : [AnyObject] = []
    var toggleStatus : Bool = false;
    
    func SetToggleStatus(state: Bool) {
        toggleStatus = state;
        
    }
    
    init() {
        
    }
}