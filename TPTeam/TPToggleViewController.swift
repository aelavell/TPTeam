import UIKit

class TPToggleViewController: UIViewController {
    @IBOutlet var toggle : UIButton?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var sm = SessionManager.sharedInstance
        if (sm.toggleStatus == true) {
            // do a thing
        }
        else {
            // whatever?
        }
    }
    
    @IBAction func togglePressed(sender: AnyObject) {
        var sm = SessionManager.sharedInstance
        if (sm.toggleStatus == true) {
            sm.SetToggleStatus(false)
            toggle?.selected = false;
        }
        else {
             sm.SetToggleStatus(true)
            toggle?.selected = true;
        }
    }
}