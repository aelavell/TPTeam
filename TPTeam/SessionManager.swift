private let _SessionManagerSharedInstance = SessionManager()

class SessionManager  {
    class var sharedInstance : SessionManager {
        return _SessionManagerSharedInstance
    }
    
    var fbUser : FBGraphUser?
    var friends : [AnyObject] = []
    var team : [AnyObject] = []
    var toggleStatus : Bool = false;
    
    func loginToTPTServer() {
        
    }
    
    func SetToggleStatus(state: Bool) {
        toggleStatus = state;
        if toggleStatus {
            NotificationManager.sharedInstance.gotTheTP()
        }
        else{
            NotificationManager.sharedInstance.needsTheTP()
        }
    }
    
    init() {
        // Get toggle status from the server and act accordingly
    }
    
    func removeTeammateByName(name: String) -> Bool{
        var filteredFriends = team.filter{$0.name != name}
        
        if filteredFriends.count != friends.count {
            team = filteredFriends
            return true
        }
        
        return false
    }
    
    func teammateInTeam(name: String) -> Bool {
        var friend = team.filter{$0.name == name}.first
        return (friend != nil)
    }
}








