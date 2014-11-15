private let _SessionManagerSharedInstance = SessionManager()

class SessionManager  {
    class var sharedInstance : SessionManager {
        return _SessionManagerSharedInstance
    }
    
    var fbUser : FBGraphUser?
    
    init() {
        
    }
}