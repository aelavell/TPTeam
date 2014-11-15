import CoreLocation
import UIKit
import AudioToolbox.AudioServices

class NotificationManager: NSObject, CLLocationManagerDelegate {

    class var sharedInstance : NotificationManager{
        struct Static {
            static let instance : NotificationManager = NotificationManager()
        }
        return Static.instance
    }
    
    var locationManager : CLLocationManager?
    var gpsLocations = [String : CLLocation]()

    let locationUpdateRate = 60.0    // Update frequency in seconds
    let tpNotificationRange = 500.0 // Range in meters
    
    override init() {
        super.init()
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
        
        /*********** This code should go wherever app init happens ???? **********/
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self;
        if (!CLLocationManager.locationServicesEnabled()){
            println("Location services are not enabled")
        }
        
        self.locationManager!.requestAlwaysAuthorization()
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.startUpdatingLocation()
        
        
        /*************************************************************************/
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(locationUpdateRate,
            target: self,
            selector: Selector("updateCurrentLocation"),
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
        var localNotification = UILocalNotification()
        localNotification.alertAction = "get TP"
        localNotification.alertBody = "You can get TP at \(storeName)"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        localNotification.category = "INVITE_CATEGORY";
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func updateCurrentLocation() {
        var currentLocation = locationManager!.location;
        println("Current Location: " + currentLocation.description)
        
        
        var nearestTP = getClosestTP(currentLocation)
        println("\(nearestTP.0) \(nearestTP.1)")
        
        if nearestTP.0 < 0{
            return;
        }
        
        if tpNotificationRange > nearestTP.0 {
            // Push notification for TP
            notifyUserAboutNearestTP(nearestTP.1)
            println("Sent a notification")
        }
        
    }

}
