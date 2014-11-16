import UIKit

class TPToggleViewController: UIViewController {
    @IBOutlet var toggle : UIButton?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SessionManager.sharedInstance.events.listenTo("ButtonStateChanged", {([Any]) -> Void in self.updateButton()})
    }
    
    func updateButton() {
        var sm = SessionManager.sharedInstance
        if (sm.buttonState == true) {
            // do a thing
        }
        else {
            // whatever?
        }
    }
    
    @IBAction func togglePressed(sender: AnyObject) {
        var sm = SessionManager.sharedInstance
        if (sm.buttonState == true) {
            sm.SetToggleStatus(false)
            toggle?.selected = false;
        }
        else {
             sm.SetToggleStatus(true)
            toggle?.selected = true;
        }
    }
}