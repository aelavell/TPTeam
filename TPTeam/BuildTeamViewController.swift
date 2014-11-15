import UIKit

class BuildTeamViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.Plain, target: self, action: "nextPressed:")
        
        var friendsRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler(
            {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                SessionManager.sharedInstance.friends = result["data"] as [AnyObject]
                self.tableView.reloadData()
                }
                as FBRequestHandler)
    }
    
    func nextPressed(sender : AnyObject) {
        self.performSegueWithIdentifier("BUILD_TEAM_EXIT_SEGUE", sender: self)
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return SessionManager.sharedInstance.friends.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "BuildTeamTableViewCell")
        cell.textLabel.text = SessionManager.sharedInstance.friends[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        SessionManager.sharedInstance.team.append(SessionManager.sharedInstance.friends[indexPath.row])
    }
}