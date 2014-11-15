//
//  AppDelegate.swift
//  TPTeam
//
//  Created by Allan Lavell on 2014-11-14.
//  Copyright (c) 2014 ThinkRad. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var notificationActionOk :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionOk.identifier = "ACCEPT_IDENTIFIER"
        notificationActionOk.title = "Ok"
        notificationActionOk.destructive = false
        notificationActionOk.authenticationRequired = false
        notificationActionOk.activationMode = UIUserNotificationActivationMode.Background
        
        var notificationActionCancel :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionCancel.identifier = "NOT_NOW_IDENTIFIER"
        notificationActionCancel.title = "Not Now"
        notificationActionCancel.destructive = true
        notificationActionCancel.authenticationRequired = false
        notificationActionCancel.activationMode = UIUserNotificationActivationMode.Background
        
        var notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "INVITE_CATEGORY"
        notificationCategory .setActions([notificationActionOk,notificationActionCancel], forContext: UIUserNotificationActionContext.Default)
        notificationCategory .setActions([notificationActionOk,notificationActionCancel], forContext: UIUserNotificationActionContext.Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert |
            UIUserNotificationType.Badge, categories: NSSet(array:[notificationCategory])
            ))
        
        initGPSLocations();
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    var locationManager : CLLocationManager?
    var gpsLocations = [String : CLLocation]()
    var uiApplication : UIApplication?
    
    let locationUpdateRate = 5.0
    let tpNotificationRange = 500.0
    
    
    func initGPSLocations(){
        gpsLocations["northStreetSobeys"] = CLLocation(latitude: 44.6534321,
            longitude: -63.59917710000002)
        
        gpsLocations["springGardenShoppers"] = CLLocation(latitude: 44.6427495,
            longitude: -63.57760960000002)
        
        gpsLocations["queenStreetSobeys"] = CLLocation(latitude: 44.6372691,
            longitude: -63.57399700000002)
        
        
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
        localNotification.category = "INVITE_CATEGORY";
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }


}

