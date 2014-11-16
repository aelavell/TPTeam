import UIKit
import Alamofire
import Foundation

class LoginViewController: UIViewController, FBLoginViewDelegate {
    @IBOutlet var fbLoginView : FBLoginView!
    var loggingIn : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
    }

    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }

    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        // println(FBSession.activeSession().accessTokenData.accessToken)
        SessionManager.sharedInstance.fbUser = user

        let params:[String:AnyObject] = ["buttonState": true]
        
        /*Alamofire.request(.POST, "http://192.168.100.129:5000/api/v1/setButtonState.json", parameters: params)
            .responseJSON {(request, response, JSON, error) in
                println(response)
                println(JSON)
                self.loggingIn = false;
        }
        
        Alamofire.request(.GET, "http://192.168.100.129:5000/api/v1/getButtonState.json")
            .responseJSON {(request, response, JSON, error) in
                println(response)
                println(JSON)
                self.loggingIn = false;
        }*/
        
        self.performSegueWithIdentifier("LOGIN_TO_BUILD_TEAM_SEGUE", sender: self)

    }

    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }

    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
}