import UIKit

class NameTeamViewController: UIViewController {
    func nextPressed(sender : AnyObject) {
        self.performSegueWithIdentifier("NAME_TEAM_TO_TPTOGGLE_SEGUE", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.Plain, target: self, action: "nextPressed:")
    }
}