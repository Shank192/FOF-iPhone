//
//  loginScreenVC.swift
//  FOF
//

//

import UIKit
import FBSDKLoginKit
import CoreLocation



class loginScreenVC: UIViewController {

    
    let locationManager = CLLocationManager()
    var userCurrentLocation : CLLocationCoordinate2D?

    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    @IBAction func btnFbLoginAct(_ sender: Any) {
        //fb
            let app = UIApplication.shared.delegate as! AppDelegate
            app.isFbSignIn = true
            
            app.fbLoginManager = FBSDKLoginManager()
            app.fbLoginManager.logOut()
            app.fbLoginManager.loginBehavior = FBSDKLoginBehavior.native
            
            app.fbLoginManager.logIn(withReadPermissions: nil, from: self, handler: { (result, error) -> Void in
                if error != nil || result!.isCancelled == true {
                    print(error?.localizedDescription ?? "")
                    app.isFbSignIn = false
                } else {
                    self.fetchFacebookUserDetail()
                }
            })
        }
    
    //MARK: - Facebook Request Action
    func fetchFacebookUserDetail() {
        if FBSDKAccessToken.current() != nil {
    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id,first_name,last_name,picture,email,age_range"])
            //,user_gender,user_link, locale,user_birthday
            _ = request?.start(completionHandler: { (_ , result , error ) -> Void in
                if error == nil {
                    
                    if let response : NSDictionary = result as? NSDictionary {
                        
                        print(response)
                        
                        var email = ""
                        var firstName = ""
                        var lastName = ""
                        var birthDay = ""
                        var gender = ""
                        var id = ""
                        
                        if response.object(forKey: "email") != nil {
                            email = response.object(forKey: "email") as! String
                        }else{
                            email = response.object(forKey: "id") as! String
                        }
                        id = response.object(forKey: "id") as! String
                        if response.object(forKey: "first_name") != nil {
                            firstName = response.object(forKey: "first_name") as! String
                        }
                        if response.object(forKey: "last_name") != nil {
                            lastName = response.object(forKey: "last_name") as! String
                        }
                        if response.object(forKey: "birthday") != nil {
                            birthDay = response.object(forKey: "birthday") as! String
                        }
                        
                        if response.object(forKey: "gender") != nil {
                            gender = response.object(forKey: "gender") as! String
                        }
                        _ = "http://graph.facebook.com/\(id)/picture?type=large"
                
//                        let param = ["email":email,"dob":birthDay,"gender":gender,"first_name":firstName,"last_name":lastName,"devicetype":"ios","action":"socialsignin","device_token": "\(UserDefaults.standard.object(forKey: Constants.UserDefaults.deviceToken) ?? 123456)"
//                            ,"device_id":"\(UserDefaults.standard.object(forKey: Constants.UserDefaults.deviceID) ?? 123465)","mobile":"986562323"]
                        
                        let param = NSDictionary.init(dictionary: ["social_flag":"1","social_id":id,"email":email,"first_name":firstName,"last_name":lastName,"device_type":"0","device_token": "\(UserDefaults.standard.object(forKey: Constants.UserDefaults.deviceToken) ?? 123456)","device_id":"\(UserDefaults.standard.object(forKey: Constants.UserDefaults.deviceID) ?? 123465)","phone":"986562323"])
                        

                       print(param)
                       self.SocioLoginApi(param )
                    }
                    
                } else {
                    print(error?.localizedDescription ?? "Error in fb user detail")
                    
                }
                Constants.GlobalConstants.appDelegate.deleteAllCoreData()
            })
        }
    }
    //MARK: - Social Login API
    
    func SocioLoginApi(_ param:NSDictionary) {
        
        
        Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.LOGIN, param: param, key: "", successStatusCode: 200) { (success, response) in
            
            if success == true
            {
                if let dict = response.object(forKey: "response_data") as? NSDictionary
                {
                    if let user_id = dict.object(forKey: "user_id")
                    {
                        UserDefaults.standard.set("\(user_id)", forKey: Constants.UserDefaults.user_ID)
                    }
                    
                    if let email = dict.object(forKey: "email")
                    {
                        UserDefaults.standard.set("\(email)", forKey: Constants.UserDefaults.User_Email)
                    }
                    
                    if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name")
                    {
                        UserDefaults.standard.set("\(last_name)", forKey: Constants.UserDefaults.User_Last_Name)
                        UserDefaults.standard.set("\(first_name)", forKey: Constants.UserDefaults.User_First_Name)
                    }
                }
                
                
                
                UserDefaults.standard.set(true, forKey: Constants.UserDefaults.alreadyLogin)
               
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "interestedScreenVC")  as! interestedScreenVC //as! testBudsScreenVC
                if self.userCurrentLocation != nil
                {
                    obj.userLocation = self.userCurrentLocation!
                }
                
                self.navigationController?.pushViewController(obj, animated: false)
                UserDefaults.standard.synchronize()
                Constants.GlobalConstants.appDelegate.isFbSignIn = true
                
            }
            else{
                if let msg = response.object(forKey: "message") as? String
                {
                    print("\(msg)")
                }
                else
                {
                    
                }
                
            }
            
        }
        
//        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param, CompletionHandler: { (success, response) -> () in
//
//            //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//            if success == true {
//               // if (response.object(forKey: "response") as! String) == "success" {
//                    if (response.object(forKey: "data") != nil)  {
//                        let data1 = response.object(forKey: "data") as! [[String:AnyObject]]
//                        let data : NSDictionary = data1[0] as NSDictionary
//                        //UserDefaults.standard.set(data, forKey: Constants.UserDefaults.LoginData)
//                        let id_str = "\(data.object(forKey: "id")!)"
//                        let id_session = "\(data.object(forKey: "sessionid")!)"
//
//
//                        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.alreadyLogin)
//                        UserDefaults.standard.set(data.object(forKey: "last_name") as! String, forKey: Constants.UserDefaults.User_Last_Name)
//                        UserDefaults.standard.set((data.object(forKey: "first_name") as AnyObject) as! String, forKey: Constants.UserDefaults.User_First_Name)
//                        UserDefaults.standard.set(data.object(forKey: "email") as! String, forKey: Constants.UserDefaults.User_Email)
//                        UserDefaults.standard.set(id_str, forKey: Constants.UserDefaults.user_ID)
//                        UserDefaults.standard.set(id_session, forKey: Constants.UserDefaults.session_ID)
//
////                        if data.object(forKey: "image") != nil && (data.object(forKey: "image") as! String).count > 0 {
////                            UserDefaults.standard.set((data.object(forKey: "image") as! String), forKey: "USERIMAGE")
////                            SDWebImageManager.shared().downloadImage(with: URL(string: data.object(forKey: "image") as! String), options: SDWebImageOptions.allowInvalidSSLCertificates, progress: nil, completed: { (image, error, SDImageCacheType, finished, url) in
////
////                                if (image != nil) {
////                                    UserDefaults.standard.set(UIImagePNGRepresentation(image!), forKey: "USER_IMG_DATA")
////                                    UserDefaults.standard.synchronize()
////                                }
////                            })
////                        }
//                       UserDefaults.standard.set(true, forKey: Constants.UserDefaults.alreadyLogin)
//                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "interestedScreenVC")  as! interestedScreenVC //as! testBudsScreenVC
//                        if self.userCurrentLocation != nil
//                        {
//                            obj.userLocation = self.userCurrentLocation!
//                        }
//
//                        self.navigationController?.pushViewController(obj, animated: false)
//                        UserDefaults.standard.synchronize()
//                    Constants.GlobalConstants.appDelegate.isFbSignIn = true
//
//                }
//                //}
//                } else if response.object(forKey: "message") != nil {
//                    //self.view.makeToast(response.object(forKey: "message") as! String)
//                }
//
//             else {
//                if response.object(forKey: "message") != nil {
//                    //self.view.makeToast(response.object(forKey: "message") as! String)
//                }
//            }})
        
    }

    
    @IBAction func btnExploreAct(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://friendsoverfoods.com/")!, options: [:], completionHandler: nil)
    }
    
}

//MARK:- Location Delegate
extension loginScreenVC : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userCurrentLocation = locValue
        manager.stopUpdatingLocation()
    }
    
}
