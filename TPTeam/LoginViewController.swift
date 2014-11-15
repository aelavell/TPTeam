import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    @IBOutlet var fbLoginView : FBLoginView!
    
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
        loginToTPTServer(user)
    }

    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }

    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    func loginToTPTServer(user: FBGraphUser) {
        self.performSegueWithIdentifier("LOGIN_TO_BUILD_TEAM_SEGUE", sender: self)
    }
}