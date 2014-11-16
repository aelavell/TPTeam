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
    var firstTime : Bool = true;
    
    
    let events = EventManager()

    
    func loginToTPTServer() {
        
    }
    
    func SetToggleStatus(state: Bool, sendToServer: Bool){
        if (sendToServer) { SetServerButtonState(state) }
        SetToggleStatusInternal(state, remoteStateChange: false)
    }
    
    func SetToggleStatusInternal(state: Bool, remoteStateChange: Bool) {
        if (firstTime || buttonState != state){
            firstTime = false;
            buttonState = state
            if (remoteStateChange) { self.events.trigger("ButtonStateChanged", information: [0]) }
            NotificationManager.sharedInstance.startOrStopNotifications()
            
        }
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
                println("Sending params \(params)")
        }
    }
    
    func GetServerButtonState() {
        Alamofire.request(.GET, "http://TPTServer.herokuapp.com/api/v1/getButtonState.json")
            .responseJSON {(request, response, JSON, error) in
                
                var info = JSON as NSDictionary
                var buttonValue = info["buttonState"] as String
                
                println("Button value is \(buttonValue)")
                
                self.SetToggleStatusInternal(buttonValue == "0", remoteStateChange: true)
        }
    }
}