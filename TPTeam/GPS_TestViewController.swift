import UIKit
import CoreLocation

class GPS_TestViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?
    var gpsLocations = [String : CLLocation]()

    let locationUpdateRate = 15.0
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
        println(nearestTP)
        
        if (tpNotificationRange > nearestTP){
            // Push notification for TP
            
        }
        
    }
    
    func getClosestTP(currentLocation: CLLocation) -> Double {
        var distances : [Double] = []
        for key in gpsLocations.keys{
            distances.append(Double(currentLocation.distanceFromLocation(gpsLocations[key])))
        }
        
        if distances.count == 0 {
            return -1
        }
        
        return sorted(distances)[0]
    }

}










