import UIKit

class BuildTeamViewController: UITableViewController {
    func nextPressed(sender : AnyObject) {
        self.performSegueWithIdentifier("BUILD_TEAM_TO_NAME_TEAM_SEGUE", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: UIBarButtonItemStyle.Plain, target: self, action: "nextPressed:")
        
        var friendsRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler(
            {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                SessionManager.sharedInstance.friends = result["data"] as [AnyObject]
                self.tableView.reloadData()
            }
        as FBRequestHandler)
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return SessionManager.sharedInstance.friends.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FRIEND_CELL") as UITableViewCell
        return cell
    }
}