import UIKit

class BuildTeamViewController: UITableViewController {
    
    var sessionManager = SessionManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 190.0/255.0, green: 221.0/255.0, blue: 161.0/255.0, alpha:1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.Plain, target: self, action: "nextPressed:")
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
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
        
        addButtonsToCell(cell, row: indexPath.row)
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func addButtonsToCell(cell: UITableViewCell, row: Int){
        var addButton = UIButton()
        addButton.frame = CGRectMake(300.0, 10.0, 100.0, 20.0);
        
        var stateCharacter = "+"
        if sessionManager.teammateInTeam(sessionManager.friends[row].name) {
            stateCharacter = "-"
        }
        
        addButton.setTitle(stateCharacter, forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        addButton.addTarget(self,
                            action: "addRemoveTeamAction:",
                            forControlEvents: UIControlEvents.TouchUpInside)
        addButton.tag = row
        
        cell.addSubview(addButton)
    }
    
    func addRemoveTeamAction(sender: AnyObject){
        var button = (sender as UIButton)
        
        if (button.titleLabel?.text == "+"){
            sessionManager.team.append(sessionManager.friends[button.tag])
            button.setTitle("-", forState: UIControlState.Normal)
            println("Added \(sessionManager.friends[button.tag].name)");
        }
        else{
            println("Removing \(sessionManager.friends[button.tag].name)");
            sessionManager.removeTeammateByName(sessionManager.friends[button.tag].name)
            button.setTitle("+", forState: UIControlState.Normal)
        }
    }
    
}