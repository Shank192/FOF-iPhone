//
//  AppDelegate.swift
//  FOF

import UIKit
import Firebase
import FirebaseCore
import GoogleMaps
import FBSDKLoginKit
import UserNotifications
import GooglePlaces
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var isFbSignIn = false
    var fbLoginManager = FBSDKLoginManager()
    var IsGoSingle = false
    @objc var userDetail = UserDetail()
    var strSearchedPlace = ""
    var locationManager = CLLocationManager()
    var isView = UIViewController()
    var currentLatitude : String = ""
    var currentLongitude : String = ""
    var curLocation : CLLocation?
    let objSendMessage = sendMessageServicesScreenVC()
    
    var arrDetailData = NSMutableDictionary()
    @objc var userLocation = CLLocationCoordinate2D()
    @objc var searchedLocation =  CLLocationCoordinate2D()
    var strCurrentPlace = ""
    var isFilterFriend = false
    
    var zomatoAPIuserKEy:String?//"ffa4b1a7f88b240a60cc050a7a603ae4"
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            
        }
        else {
            UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isCurrentLocationRestro)
            UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isCurrentLocationFrnd)
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isFriend)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constants.GoogleKey.kGoogle_Key)
        GMSPlacesClient.provideAPIKey(Constants.GoogleKey.kGoogle_Key)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        registerRemoteNotification()
        
        if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
        {
            UserDefaults.standard.set(20000, forKey: Constants.UserDefaults.FilterDistance)
            UserDefaults.standard.synchronize()
            
            
        }
        
        self.SetMyRootBy()
        
        
        //GMSPlacesClient.provideAPIKey(Constants.GoogleKey.kGoogle_Key)
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        offline()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        offline()
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        online()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        offline()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func managedObjectContext() -> NSManagedObjectContext{
        let context : NSManagedObjectContext = self.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("saved")
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        let managedObjectModel : NSManagedObjectModel = (context.persistentStoreCoordinator?.managedObjectModel)!
        let entities : NSDictionary = managedObjectModel.entitiesByName as NSDictionary
        let entityNames : NSArray = entities.allKeys as NSArray
        return context
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
    //MARK:- Check Online Offline
    func deleteAllCoreData(){
        let cdm = CoreDataManage()
        cdm.deleteAllDataWithEntityName(entity: "UserData")
        cdm.deleteAllDataWithEntityName(entity: "FriendOtherDetail")
        cdm.deleteAllDataWithEntityName(entity: "MessagesDetail")
    }
    func online(){
        if let senderId = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as? String{
            let chatGrpId = UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as! String
            objSendMessage.addObserverForStatusUpdateforChatId(chatId: chatGrpId)
            arrDetailData["status"] = "Online"
            arrDetailData["lastSeen"] = String(describing: setCurrentTimeToTimestamp())
            arrDetailData["senderId"] = senderId
            arrDetailData["timestamp"] = ""
            arrDetailData["recieverId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverId)
            objSendMessage.updateMyStatusOnFirebase(mutDictStatusDetail: arrDetailData, chatId: chatGrpId, senderId: senderId)
        }
    }
    func offline(){
        if let senderId = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as? String{
            let chatGrpId = UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as! String
            arrDetailData["status"] = "Offline"
            arrDetailData["lastSeen"] = String(describing: setCurrentTimeToTimestamp())
            arrDetailData["senderId"] = senderId
            arrDetailData["timestamp"] = ""
            arrDetailData["recieverId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverId)
            objSendMessage.updateMyStatusOnFirebase(mutDictStatusDetail: arrDetailData, chatId: chatGrpId, senderId: senderId)
        }
    }
    func Typing(){
        if let senderId = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as? String{
            let chatGrpId = UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as! String
            arrDetailData["status"] = "typing..."
            arrDetailData["lastSeen"] = String(describing: setCurrentTimeToTimestamp())
            arrDetailData["senderId"] = senderId
            arrDetailData["timestamp"] = ""
            arrDetailData["recieverId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverId)
            objSendMessage.updateMyStatusOnFirebase(mutDictStatusDetail: arrDetailData, chatId: chatGrpId, senderId: senderId)
        }
    }
    //    func managedObjectContext() -> NSManagedObjectContext {
    //        let context: NSManagedObjectContext? = persistentContainer.viewContext
    //        var error: Error? = nil
    //        if (context?.hasChanges)! && !(((try? context?.save()) != nil)) {
    //            // Replace this implementation with code to handle the error appropriately.
    //            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //            //      NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    //            abort()
    //        }
    //        let managedObjectModel: NSManagedObjectModel? = context?.persistentStoreCoordinator?.managedObjectModel
    //        let entities = managedObjectModel?.entitiesByName
    //        let entityNames = entities?.keys
    //        //   NSLog(@"All loaded entities are: %@", entityNames);
    //        return context ?? NSManagedObjectContext()
    //    }
    
    //MARK:- Set Root
    func SetMyRootBy() {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.alreadyLogin){
            if UserDefaults.standard.object(forKey: Constants.UserDefaults.isOpenFriendViewController) != nil
            {
                if "\(UserDefaults.standard.object(forKey: Constants.UserDefaults.isOpenFriendViewController)!)" == "Yes"
                {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
                    self.IsGoSingle = false
                    nextVC.selectedIndex = 1
                    Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
                }
                else
                {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
                    self.IsGoSingle = true
                    nextVC.selectedIndex = 1
                    Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
                }
            }
            else
            {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "interestedScreenVC") as! interestedScreenVC//as! FoFTabBarScreenVC
                //            nextVC.selectedIndex = 1
                self.window?.rootViewController = nextVC
            }
            
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
        isView = view
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
    func dictionaryByReplacingNullsWithStrings(adict:NSDictionary){
        let replaced : NSMutableDictionary = adict.mutableCopy() as! NSMutableDictionary
        let blank : NSString = ""
        for key in adict{
            let object = adict.object(forKey: key)
            if let dict = object as? NSDictionary{
                replaced.setObject(self.dictionaryByReplacingNullsWithStrings(adict: object as! NSDictionary), forKey: key as! NSCopying)
            }else if let dict = object as? NSArray{
                for i in 0..<dict.count{
                    // dict[i] = self.dictionaryByReplacingNullsWithStrings(adict: dict[i])
                }
            }
            
            
        }
        
    }
    
    
    //MARK:- Webservice
    func getZomatoKEY(CompletionHandler : @escaping  (Bool) -> ())
    {
        Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.getZomatoKEey, param: NSDictionary(), key: "", successStatusCode: 200) { (success, response) in
            
            if success == true
            {
                if let response_data = response.object(forKey: "response_data") as? NSDictionary
                {
                    if let zomato_key = response_data.object(forKey: "zomato_key") as? String
                    {
                        self.zomatoAPIuserKEy = zomato_key
                    }
                }
                
                CompletionHandler(true)
            }
            else
            {
                if let msg = response.object(forKey: "message") as? String
                {
                    self.window?.rootViewController?.view.makeToast(msg)
                }
                else
                {
                    self.window?.rootViewController?.view.makeToast("Something wento wrong; Please try after sometime")
                }
                
                CompletionHandler(false)
            }
            
        }
    }
    
    
//    func getUSerPRofileDetail()
//    {
//        if let userid = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
//        {
//            let param = ["user_id":"\(userid)"]
//            
//            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetUserProfile, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
//                
//                if success == true
//                {
//                    if let dataDict = response.object(forKey: "response_data") as? NSDictionary
//                    {
//                        self.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
//                        UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
//                        
//                        if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
//                        {
//                            UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
//                            UserDefaults.standard.synchronize()
//                        }
//                    }
//                    
//                    UserDefaults.standard.synchronize()
//                }
//                else
//                {
//                    if let msg = response.object(forKey: "message") as? String
//                    {
//                        self.window?.rootViewController?.view.makeToast(msg)
//                    }
//                    else
//                    {
//                        self.getUSerPRofileDetail()
//                    }
//                }
//                
//                
//            }
//        }
//    }
    
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
           
            //UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String, forKey:Constants.UserDefaults.currentRestLatitude)
           
          //  UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String, forKey:Constants.UserDefaults.currentRestLongitude)
                
                curLocation = manager.location
                NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
                manager.stopUpdatingLocation()
           // }
        } else {
            currentLatitude = NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String
            currentLongitude = NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String
            
            UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String, forKey: Constants.UserDefaults.currentLatitude)
           
            UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String, forKey: Constants.UserDefaults.currentLongitude)
           
           // UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.latitude)!) as String, forKey:Constants.UserDefaults.currentRestLatitude)
            
           // UserDefaults.standard.set(NSString(format: "%.8f", (manager.location?.coordinate.longitude)!) as String, forKey:Constants.UserDefaults.currentRestLongitude)
            curLocation = manager.location
           NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("location failes : \(error.localizedDescription)")
    }}

