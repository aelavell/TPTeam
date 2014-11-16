import UIKit

private let _TPToggleViewControllerSharedInstance = TPToggleViewController()

class TPToggleViewController: UIViewController {
    @IBOutlet var toggle : UIButton?
    
    class var sharedInstance : TPToggleViewController {
        return _TPToggleViewControllerSharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SessionManager.sharedInstance.events.listenTo("ButtonStateChanged", {([Any]) -> Void in self.updateButton()})
    }
    
    func updateButton() {
        evaluateButtonState()
    }
    
    func evaluateButtonState(){
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
    
    @IBAction func togglePressed(sender: AnyObject) {
        evaluateButtonState()
    }
}