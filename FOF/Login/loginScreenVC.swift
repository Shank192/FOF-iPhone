//
//  loginScreenVC.swift
//  FOF
//

//

import UIKit
import FBSDKLoginKit




class loginScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
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
    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id,first_name,last_name,picture.width(400).height(400),email,age_range"])
            //,user_gender,user_link, locale,user_birthday
            request?.start(completionHandler: { (_ , result , error ) -> Void in
                if error == nil {
                    
                    if let response : NSDictionary = result as? NSDictionary {
                        
                        print(response)
                        
                        var email = ""
                        var firstName = ""
                        var lastName = ""
                        var birthDay = ""
                        var gender = ""
                        
                        if response.object(forKey: "email") != nil {
                            email = response.object(forKey: "email") as! String
                        }else{
                            email = response.object(forKey: "id") as! String
                        }
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
                        
                        if let picture : NSDictionary = response.object(forKey: "picture") as? NSDictionary {
                            
                            if let picData : NSDictionary = picture.object(forKey: "data") as? NSDictionary {
                                if let picurl : String = picData.object(forKey: "url") as? String {
                                    print(picurl)
                                    
//                                    if picurl.characters.count > 0 {
//                                        
//                                        UserDefaults.standard.set(picurl, forKey: "USERIMAGE")
//                                        UserDefaults.standard.synchronize()
//                                        
//                                        SDWebImageManager.shared().downloadImage(with: URL(string: picurl), options: SDWebImageOptions.allowInvalidSSLCertificates, progress: nil, completed: { (image, error, SDImageCacheType, finished, url) in
//                                            
//                                            if (image != nil) {
//                                            }
//                                        })
//                                        
//                                        
//                                        
//                                    }
                                }
                            }
                        }
                    
                        let param = ["email":email,"dob":birthDay,"gender":gender,"first_name":firstName,"last_name":lastName,"device_id":UserDefaults.standard.object(forKey: Constants.UserDefaults.deviceID) as! String,"devicetype":"ios","action":"socialsignin","device_token":UserDefaults.standard.object(forKey: Constants.UserDefaults.deviceToken) as! String,"mobile":"986562323"]
                       print(param)
                       self.SocioLoginApi(param as NSDictionary)
                    }
                    
                } else {
                    print(error?.localizedDescription ?? "Error in fb user detail")
                    
                }
                
            })
        }
    }
    //MARK: - Social Login API
    
    func SocioLoginApi(_ param:NSDictionary) {
        
        
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param, CompletionHandler: { (success, response) -> () in
            
            //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if success == true {
               // if (response.object(forKey: "response") as! String) == "success" {
                    if (response.object(forKey: "data") != nil)  {
                        let data1 = response.object(forKey: "data") as! [[String:AnyObject]]
                        let data : NSDictionary = data1[0] as NSDictionary
                        //UserDefaults.standard.set(data, forKey: Constants.UserDefaults.LoginData)
                        let id_str = "\(data.object(forKey: "id")!)"
                        let id_session = "\(data.object(forKey: "sessionid")!)"
                        UserDefaults.standard.set(data.object(forKey: "last_name") as! String, forKey: Constants.UserDefaults.User_Last_Name)
                        UserDefaults.standard.set((data.object(forKey: "first_name") as AnyObject) as! String, forKey: Constants.UserDefaults.User_First_Name)
                        UserDefaults.standard.set(data.object(forKey: "email") as! String, forKey: Constants.UserDefaults.User_Email)
                        UserDefaults.standard.set(id_str, forKey: Constants.UserDefaults.user_ID)
                        UserDefaults.standard.set(id_session, forKey: Constants.UserDefaults.session_ID)

//                        if data.object(forKey: "image") != nil && (data.object(forKey: "image") as! String).count > 0 {
//                            UserDefaults.standard.set((data.object(forKey: "image") as! String), forKey: "USERIMAGE")
//                            SDWebImageManager.shared().downloadImage(with: URL(string: data.object(forKey: "image") as! String), options: SDWebImageOptions.allowInvalidSSLCertificates, progress: nil, completed: { (image, error, SDImageCacheType, finished, url) in
//
//                                if (image != nil) {
//                                    UserDefaults.standard.set(UIImagePNGRepresentation(image!), forKey: "USER_IMG_DATA")
//                                    UserDefaults.standard.synchronize()
//                                }
//                            })
//                        }
                       UserDefaults.standard.set(true, forKey: Constants.UserDefaults.alreadyLogin)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "testBudsScreenVC") as! testBudsScreenVC
                        
                        self.navigationController?.pushViewController(obj, animated: false)
                        UserDefaults.standard.synchronize()
                    Constants.GlobalConstants.appDelegate.isFbSignIn = true }
                //}
                } else if response.object(forKey: "message") != nil {
                    //self.view.makeToast(response.object(forKey: "message") as! String)
                }
                
             else {
                if response.object(forKey: "message") != nil {
                    //self.view.makeToast(response.object(forKey: "message") as! String)
                }
            }})}

    
    @IBAction func btnExploreAct(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://friendsoverfoods.com/")!, options: [:], completionHandler: nil)
    }
    
}
