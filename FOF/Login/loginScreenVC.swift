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
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id,first_name,last_name,picture.width(400).height(400),email,name"])
            
            request?.start(completionHandler: { (_ , result , error ) -> Void in
                if error == nil {
                    
                    if let response : NSDictionary = result as? NSDictionary {
                        
                        print(response)
                        
                        var email = ""
                        var name = ""
                        var idstr = ""
                        
                        
                        if response.object(forKey: "email") != nil {
                            email = response.object(forKey: "email") as! String
                        }
                        if response.object(forKey: "name") != nil {
                            name = response.object(forKey: "name") as! String
                        }
                        
                        if response.object(forKey: "id") != nil {
                            idstr = response.object(forKey: "id") as! String
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
                        
                        
                        var device_tokn = ""
                        
                        if UserDefaults.standard.object(forKey: "device_token") != nil {
                            if (UserDefaults.standard.object(forKey: "device_token") as AnyObject).length > 0  {
                                device_tokn = UserDefaults.standard.object(forKey: "device_token") as! String
                            }
                        }
                        
                        //                        let param = ["email":email,"name":name,"social_id":idstr,"device_id":UserDefaults.standard.object(forKey: Constants.UserDefaults.DEVICE_ID) as! String,"device_type":"1","social_flag":"1","device_token":device_tokn]
                       // let param = ["email":email,"name":name,"social_id":idstr,"device_id":"7332117F-A65F-4569-B13A-C207BA8FE947","device_type":"1","social_flag":"1","device_token":"3651200A7B02BAF23729A1D209BEBE6121BD49E1ACE89ACB6F0BAF1F01423B18"]
                        
                        //print(param)
                        //self.SocioLoginApi(param as NSDictionary)
                    }
                    
                } else {
                    print(error?.localizedDescription ?? "Error in fb user detail")
                    
                }
                
            })
        }
    }
    @IBAction func btnExploreAct(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://friendsoverfoods.com/")!, options: [:], completionHandler: nil)
    }
    
}
