//
//  AppDelegate.swift
//  FOF
//

//

import UIKit
import Firebase
import FirebaseCore
import GoogleMaps
import FBSDKLoginKit
import UserNotifications
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var isFbSignIn = false
    var fbLoginManager = FBSDKLoginManager()
    var IsGoSingle = false
    @objc var userDetail = UserDetail()
    var strSearchedPlace = ""
    var locationManager = CLLocationManager()
    
    var currentLatitude : String = ""
    var currentLongitude : String = ""
    var curLocation : CLLocation?
    
    @objc var userLocation = CLLocationCoordinate2D()
    @objc var searchedLocation =  CLLocationCoordinate2D()
    
    var strCurrentPlace = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
        }
        else {
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constants.GoogleKey.kGoogle_Key)
        GMSPlacesClient.provideAPIKey(Constants.GoogleKey.kGoogle_Key)

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        registerRemoteNotification()
        
        self.SetMyRootBy()
        
        
        //GMSPlacesClient.provideAPIKey(Constants.GoogleKey.kGoogle_Key)
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //MARK:- Register RemoteNotification
    func registerRemoteNotification()
    {
        let appli = UIApplication.shared
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    DispatchQueue.main.async { // Correct
                        appli.registerUserNotificationSettings(settings)
                        appli.registerForRemoteNotifications()
                    }
                    
                }
                else{
                    
                    print("Do stuff if unsuccessful...")
                    //Do stuff if unsuccessful...
                }
            })
        } else {
            
            appli.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    //MARK:- didRegisterForRemoteNotificationsWithDeviceToken
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(tokenString, forKey: Constants.UserDefaults.deviceToken)
        UserDefaults.standard.synchronize()
        print("Token : \(tokenString)")
        print("Device Id : \(getUUID())")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if isFbSignIn == true {
            //fb
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        }
        return true
    }
    //MARK:- Set Root
    func SetMyRootBy() {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.alreadyLogin){
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "interestedScreenVC") as! interestedScreenVC
            self.window?.rootViewController = nextVC
        } else {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            let nextVC  = storyboard.instantiateViewController(withIdentifier: "loginScreenVC") as! loginScreenVC
            let navig : UINavigationController = UINavigationController(rootViewController: nextVC)
            navig.isNavigationBarHidden = true
            self.window?.rootViewController = navig
        }
        self.window?.makeKeyAndVisible()
    }
    //MARK:- Get UUID
    func getUUID() -> String
    {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        var strApplicationUUID = SSKeychain.password(forService: appName, account: "incoding")
        
        if strApplicationUUID == nil
        {
            strApplicationUUID = UIDevice.current.identifierForVendor?.uuidString
            UserDefaults.standard.set(strApplicationUUID, forKey: Constants.UserDefaults.deviceID)
            SSKeychain.password(forService: strApplicationUUID, account: "incoding")
        }
        return strApplicationUUID!
    }
    
    func locateLocationManager(view : UIViewController)
    {
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if locationManager.location != nil
        {
            self.userLocation = locationManager.location!.coordinate
        }
    }
}

extension AppDelegate : CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if curLocation != nil {
            
            let newLoc = manager.location
            
            let meters : CLLocationDistance = (newLoc?.distance(from: curLocation!))!
            
           // if meters > 25 {
                currentLatitude = NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String
                currentLongitude = NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String
                UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String, forKey: Constants.UserDefaults.currentLatitude)
                UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String, forKey: Constants.UserDefaults.currentLongitude)
                
                curLocation = manager.location
                
              NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
                manager.stopUpdatingLocation()
           // }
        } else {
            currentLatitude = NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String
            currentLongitude = NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String
            UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String, forKey: Constants.UserDefaults.currentLatitude)
            UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String, forKey: Constants.UserDefaults.currentLongitude)
            
            curLocation = manager.location
           NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("location failes : \(error.localizedDescription)")
    }}

