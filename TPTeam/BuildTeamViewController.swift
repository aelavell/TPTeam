import UIKit

class BuildTeamViewController: UITableViewController {
    func nextPressed(sender : AnyObject) {
        self.performSegueWithIdentifier("BUILD_TEAM_TO_NAME_TEAM_SEGUE", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: UIBarButtonItemStyle.Plain, target: self, action: "nextPressed:")
    }
}