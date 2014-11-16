import CoreLocation
import UIKit
import AudioToolbox.AudioServices
import Alamofire

class NotificationManager: NSObject, CLLocationManagerDelegate {

    class var sharedInstance : NotificationManager{
        struct Static {
            static let instance : NotificationManager = NotificationManager()
        }
        return Static.instance
    }
    
    var locationManager : CLLocationManager?
    var gpsLocations = [String : CLLocation]()
    var uiApplication: UIApplication?
    var notificationTimer: NSTimer?
    var dateTime = NSDate()
    var calendar = NSCalendar()
    var notified = false;

    let locationUpdateRate = 60.0    // Update frequency in seconds
    let serverPollRate = 5.0        // Update frequency in seconds
    let tpNotificationRange = 500.0 // Range in meters
    let timeToWaitAfterNotification = 60 * 60 * 4 // Time in seconds = 4 hours
    
    override init() {
        super.init()
        NSTimer.scheduledTimerWithTimeInterval(5.0,
            target: self,
            selector: "GetServerButtonState",
            userInfo: nil,
            repeats: true)
        
        SessionManager.sharedInstance.events.listenTo("ButtonStateChanged",
                                                      {([Any]) -> Void in self.startOrStopNotifications()})
    }
    
    func GetServerButtonState() {
        SessionManager.sharedInstance.GetServerButtonState();
    }
    
    func startOrStopNotifications() {
        if (SessionManager.sharedInstance.buttonState) {
            needsTheTP()
        }
        else {
            gotTheTP()
        }
    }
    
    func gotTheTP(){
        notificationTimer = NSTimer()
        //notifyUserAboutTPAcquisition()
    }
    
    func needsTheTP(){
        notified = false
        initTimer()
    }
    
    func initGPSLocations(){
        gpsLocations["North Street Sobeys"] = CLLocation(latitude: 44.6534321,
            longitude: -63.59917710000002)
        
        gpsLocations["Spring Garden Shoppers"] = CLLocation(latitude: 44.6427495,
            longitude: -63.57760960000002)
        
        gpsLocations["Queen Street Sobeys"] = CLLocation(latitude: 44.6372691,
            longitude: -63.57399700000002)
    }
    
    func initGPS(){
        initGPSLocations()
        
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self;
        if (!CLLocationManager.locationServicesEnabled()){
            println("Location services are not enabled")
        }
        
        self.locationManager!.requestAlwaysAuthorization()
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.startUpdatingLocation()
        
        initTimer()
    }
    
    func initTimer(){
        notificationTimer = NSTimer.scheduledTimerWithTimeInterval(5,
            target: self,
            selector: Selector("updateTPStatus"),
            userInfo: nil,
            repeats: false)

        notificationTimer = NSTimer.scheduledTimerWithTimeInterval(locationUpdateRate,
                                                                   target: self,
                                                                   selector: Selector("updateTPStatus"),
                                                                   userInfo: nil,
                                                                   repeats: true)
    }

    func getClosestTP(currentLocation: CLLocation) -> (Double, String) {
        var distances : [Double] = []
        for key in gpsLocations.keys{
            distances.append(Double(currentLocation.distanceFromLocation(gpsLocations[key])))
        }
        
        if distances.count == 0 {
            return (-1, "")
        }
        
        distances = sorted(distances)
        
        var locationName = gpsLocations.keys.filter{
            Double(currentLocation.distanceFromLocation(self.gpsLocations[$0])) == distances[0]
            }.array[0]
        
        return (distances[0], locationName)
    }
    
    
    
    func notifyUserAboutNearestTP(storeName : String) {

        var notificationMessage = "You can get TP at \(storeName)"
        notifyUser(notificationMessage, notificationTitle: "TP Proximity Alert")
        
        notified = true
        dateTime = NSDate()
    }
    
    func notifyUserAboutNeedForTP(){
        notifyUser("You're out of TP!", notificationTitle: "TP Status Change")
    }
    
    func notifyUserAboutTPAcquisition(){
        notifyUser("Someone else got TP!", notificationTitle:  "TP Status Change")
    }
    
    func notifyUser(notificationMessage: String, notificationTitle: String){
        
        if (uiApplication?.applicationState == UIApplicationState.Active){
            var alertController = UIAlertController(title: "TP Proximity Alert",
                message: notificationMessage,
                preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // OK CODEEEE
            }
            
            alertController.addAction(OKAction)
            
            getTopmostViewController().presentViewController(alertController,
                animated: true,
                {() -> Void in return})
        }
        else{
            var localNotification = UILocalNotification()
            localNotification.alertAction = "get TP"
            localNotification.alertBody = notificationMessage
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
            localNotification.category = "BACKGROUND_NOTIFICATION";
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func getTopmostViewController() -> UIViewController{
        var rootController = uiApplication?.keyWindow?.rootViewController
        
        while rootController?.presentedViewController != nil {
            rootController = rootController?.presentedViewController
        }
        
        return rootController!
    }
    
    func updateCurrentLocation() {
        var currentLocation = locationManager!.location;
        println("Current Location: " + currentLocation.description)
        
        var nearestTP = getClosestTP(currentLocation)
        println("\(nearestTP.0) \(nearestTP.1)")
        
        if nearestTP.0 < 0 {
            return;
        }
        
        if tpNotificationRange > nearestTP.0 {
            notifyUserAboutNearestTP(nearestTP.1)
            println("Sent a notification")
        }
    }
    
    func updateTPStatus(){
        if !notified {
            updateCurrentLocation()
        }
        else if (NSInteger(dateTime.timeIntervalSinceNow) * -1) >= timeToWaitAfterNotification {
            notified = false
            println("reset notifications");
        }
    }
    
    func initializeNotificationTypes(application: UIApplication){
        var notificationBackgroundActionOk :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationBackgroundActionOk.identifier = "BACKGROUND_ACCEPT_IDENTIFIER"
        notificationBackgroundActionOk.title = "Ok"
        notificationBackgroundActionOk.destructive = false
        notificationBackgroundActionOk.authenticationRequired = false
        notificationBackgroundActionOk.activationMode = UIUserNotificationActivationMode.Background
        
        var notificationBackgroundActionCancel :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationBackgroundActionCancel.identifier = "BACKGROUND_NOT_NOW_IDENTIFIER"
        notificationBackgroundActionCancel.title = "Not Now"
        notificationBackgroundActionCancel.destructive = true
        notificationBackgroundActionCancel.authenticationRequired = false
        notificationBackgroundActionCancel.activationMode = UIUserNotificationActivationMode.Background

        var backgroundNotification:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        backgroundNotification.identifier = "BACKGROUND_NOTIFICATION"
        backgroundNotification.setActions([notificationBackgroundActionOk,
                                           notificationBackgroundActionCancel],
                                           forContext: UIUserNotificationActionContext.Default)
        backgroundNotification.setActions([notificationBackgroundActionOk,
                                           notificationBackgroundActionCancel],
                                           forContext: UIUserNotificationActionContext.Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert |
            UIUserNotificationType.Badge, categories: NSSet(array:[backgroundNotification])
            ))
        
        uiApplication = application
    }

}
