import UIKit
import CoreLocation

class GPS_TestViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?
    var gpsLocations = [String : CLLocation]()
    var uiApplication : UIApplication?
 
    let locationUpdateRate = 5.0
    let tpNotificationRange = 500.0

    func nextPressed(sender : AnyObject) {
        self.performSegueWithIdentifier("NAME_TEAM_TO_TPTOGGLE_SEGUE", sender: self)
    }
    
    func initGPSLocations(){
        gpsLocations["northStreetSobeys"] = CLLocation(latitude: 44.6534321,
                                                       longitude: -63.59917710000002)
        
        gpsLocations["springGardenShoppers"] = CLLocation(latitude: 44.6427495,
            longitude: -63.57760960000002)
        
        gpsLocations["queenStreetSobeys"] = CLLocation(latitude: 44.6372691,
            longitude: -63.57399700000002)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        initGPSLocations();
    
        var timer = NSTimer.scheduledTimerWithTimeInterval(locationUpdateRate,
                                                           target: self,
                                                           selector: Selector("updateCurrentLocation"),
                                                           userInfo: nil,
                                                           repeats: true)
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
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

}










