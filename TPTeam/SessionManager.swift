import Alamofire

private let _SessionManagerSharedInstance = SessionManager()

class SessionManager  {
    class var sharedInstance : SessionManager {
        return _SessionManagerSharedInstance
    }
    
    var fbUser : FBGraphUser?
    var friends : [AnyObject] = []
    var team : [AnyObject] = []
    var buttonState : Bool = false;
    
    let events = EventManager()

    
    func loginToTPTServer() {
        
    }
    
    func SetToggleStatus(state: Bool) {
        buttonState = state;
        if buttonState {
            NotificationManager.sharedInstance.gotTheTP()
        }
        else {
            NotificationManager.sharedInstance.needsTheTP()
        }
        SetServerButtonState(state);
    }
    
    
    
    init() {
        // Get toggle status from the server and act accordingly
        self.GetServerButtonState()
        /**/
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
    
    func SetServerButtonState(state : Bool) {
        let params:[String:AnyObject] = ["buttonState": state]
        Alamofire.request(.POST, "http://TPTServer.herokuapp.com/api/v1/setButtonState.json", parameters: params)
            .responseJSON {(request, response, JSON, error) in
                println(response)
                println(JSON)
        }
    }
    
    func GetServerButtonState() {
        Alamofire.request(.GET, "http://TPTServer.herokuapp.com/api/v1/getButtonState.json")
            .responseJSON {(request, response, JSON, error) in
                self.events.trigger("ButtonStateChanged", information: [0])
                println(JSON)
        }
    }
}