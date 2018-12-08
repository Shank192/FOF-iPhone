//
//  userProfileEditScreenVC.swift
//  FOF
//
//  Create



//d by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit


class userProfileEditScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var collectionViewProfile: UICollectionView!
    
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewPhotos: UIView!
    var mutDictUserProfileDetail = NSMutableDictionary()
    
     var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var viewPreferences: UIView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushController), name: Constants.UserDefaults.pushNotificationName, object: nil)

        if let ProfileData = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSDictionary
        {
            if let distance_unit = ProfileData.object(forKey: "distance_unit"),let search_min_age = ProfileData.object(forKey: "search_min_age"),let search_max_age = ProfileData.object(forKey: "search_max_age"),let is_receive_invitation_notifications = ProfileData.object(forKey: "is_receive_invitation_notifications"),let is_receive_messages_notifications = ProfileData.object(forKey: "is_receive_messages_notifications"),let is_show_location = ProfileData.object(forKey: "is_show_location"),let showme = ProfileData.object(forKey: "showme")
            {
                let mutDictUserDetail = NSMutableDictionary()
                mutDictUserDetail.setValue(distance_unit, forKey: "distance_unit")
                mutDictUserDetail.setValue(search_min_age, forKey: "search_min_age")
                mutDictUserDetail.setValue(search_max_age, forKey: "search_max_age")
                mutDictUserDetail.setValue(is_receive_invitation_notifications, forKey:"is_receive_invitation_notifications")
                mutDictUserDetail.setValue(is_receive_messages_notifications, forKey:"is_receive_messages_notifications")
                mutDictUserDetail.setValue(is_show_location, forKey:"is_show_location")
                
                mutDictUserDetail.setValue(showme, forKey: "showme")
                
                let data = NSKeyedArchiver.archivedData(withRootObject: mutDictUserDetail)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey:"mutDictUser")
            }
        }

        
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.collectionViewProfile.reloadData()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pushController(){
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "testBudsScreenVC") as! testBudsScreenVC
        obj.isSave = true
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnSaveAct(_ sender: Any) {
        
        
        let data = UserDefaults.standard.object(forKey: "mutDictUserDetail") as! NSData
        let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
        
        
        if let dataDictUser = UserDefaults.standard.object(forKey: "mutDictUser") as? NSData
        {
            let objectDictUser = NSKeyedUnarchiver.unarchiveObject(with: dataDictUser as Data) as! NSDictionary
            
            print(objectDictUser)
            mutDictUserProfileDetail = object as! NSMutableDictionary
            print(mutDictUserProfileDetail)
            
            if mutDictUserProfileDetail.object(forKey:"first_name") as! String == "" ,mutDictUserProfileDetail.object(forKey:"last_name") as! String == ""
            {
                self.app.window?.rootViewController?.view.makeToast("First name and last name should not be empty.")
                return
            }
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            
            
            let dictEditProfilePara = ["user_id":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String,"first_name":mutDictUserProfileDetail.object(forKey:"first_name") as! String ,"last_name":mutDictUserProfileDetail.object(forKey:"last_name") as! String ,"gender":"\(mutDictUserProfileDetail.object(forKey: "Gender") ?? "")","dob":mutDictUserProfileDetail.object(forKey:"Birthday") as! String,"showme":objectDictUser.object(forKey:"showme") as! String,"distance_unit":objectDictUser.object(forKey:"distance_unit") as! String,"search_min_age":objectDictUser.object(forKey:"search_min_age") as! String,"search_max_age":objectDictUser.object(forKey:"search_max_age") as! String,"search_distance":objectDictUser.object(forKey: "search_distance") ?? "20000","show_friends":"0","occupation":mutDictUserProfileDetail.object(forKey:"occupation") as! String,"relationship":mutDictUserProfileDetail.object(forKey:"RelationShip") as! String,"education":mutDictUserProfileDetail.object(forKey:"education") as! String,"about_me":mutDictUserProfileDetail.object(forKey:"about_me") as! String,"ethnicity":mutDictUserProfileDetail.object(forKey:"ethnicity") as! String, "is_receive_invitation_notifications":objectDictUser.object(forKey:"is_receive_invitation_notifications") ?? "1","is_receive_messages_notifications":objectDictUser.object(forKey:"is_receive_messages_notifications") ?? "1","is_show_location":objectDictUser.object(forKey:"is_show_location") ?? "1"] as [String : Any]
            
            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.updateUserData, param: dictEditProfilePara as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                if success == true
                {
                    
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    if let dataDict = response.object(forKey: "response_data") as? NSDictionary
                    {
                        Constants.GlobalConstants.appDelegate.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
                        UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
                        
                        if let search_distance = dataDict.object(forKey: "search_distance")
                        {
                            UserDefaults.standard.set("\(search_distance)", forKey: Constants.UserDefaults.FilterDistance)
                        }
                        
                        if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
                        {
                            UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
                            UserDefaults.standard.synchronize()
                        }
                    }
                    
                    UserDefaults.standard.synchronize()
                    
                    Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast("Your profile successfully saved.")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }else{
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                }
            }
        }
        else
        {
            Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast("Please show preferences.")
        }
        
    }
    
    @IBAction func btnDetailsAct(_ sender: Any) {
        viewPhotos.isHidden = true
        viewDetails.isHidden = false
        viewPreferences.isHidden = true
        scrollToPage(page: 0)
    }
    
    @IBAction func btnPhotosAct(_ sender: Any) {
        viewPhotos.isHidden = false
        viewDetails.isHidden = true
        viewPreferences.isHidden = true

        scrollToPage(page: 1)

    }
    @IBAction func
        btnPreferenecAct(_ sender: Any) {
        viewPhotos.isHidden = true
        viewDetails.isHidden = true
        viewPreferences.isHidden = false
        scrollToPage(page: 2)

    }
    func scrollToPage(page : NSNumber){
        switch page {
        case 0:
            viewPhotos.isHidden = true
            viewPreferences.isHidden = true
            viewDetails.isHidden = false
            collectionViewProfile.contentOffset = CGPoint(x: 0, y: 0)
            break
        case 1:
            viewPhotos.isHidden = false
            viewDetails.isHidden = true
            viewPreferences.isHidden = true

            collectionViewProfile.contentOffset = CGPoint(x: collectionViewProfile.frame.size.width, y: 0)
            break
        case 2:
            viewPhotos.isHidden = true
            viewDetails.isHidden = true
            viewPreferences.isHidden = false
            collectionViewProfile.contentOffset = CGPoint(x: collectionViewProfile.frame.size.width * 2, y: 0)
            break
        default:
            break
        }
    }
    
    //MARK:- Button Action
    @objc func btnActionEditProfileImage(sender : UIButton)
    {
        
        
        
        
        let alert = UIAlertController.init(title: "Select image for profile", message: "Please select option to choose your profile picture", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (act) in
            
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: "Photos", style: .default) { (act) in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if indexPath.row == 0{
            viewPhotos.isHidden = true
            viewPreferences.isHidden = true
            viewDetails.isHidden = false
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDetails", for: indexPath as IndexPath) as! detailCollectionViewCell
            cell.mutDictUserDetail = mutDictUserProfileDetail
            return cell
        }else if indexPath.row == 1{
            viewPhotos.isHidden = false
            viewDetails.isHidden = true
            viewPreferences.isHidden = true
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhotos", for: indexPath as IndexPath) as! photoCollectionViewCell
            //btnEditPhoto
            
            if Constants.GlobalConstants.appDelegate.userDetail.profilepic1 != ""
            {
                MBProgressHUD.showAdded(to: cell.imgViewMale, animated: true)
                cell.imgViewMale.sd_setImage(with: URL.init(string: Constants.GlobalConstants.appDelegate.userDetail.profilepic1)!, placeholderImage: UIImage.init(named: "male")) { (image, error, cash, url) in
                    MBProgressHUD.hideAllHUDs(for: cell.imgViewMale, animated: true)
                }
//                cell.imgViewMale.sd_setImage(with: URL.init(string: Constants.GlobalConstants.appDelegate.userDetail.profilepic1)!, placeholderImage: UIImage.init(named: "male"))
            }
            else
            {
                cell.imgViewMale.image = UIImage.init(named: "male")
            }
            
            cell.btnEditPhoto.addTarget(self, action: #selector(btnActionEditProfileImage(sender:)), for: .touchUpInside)
            
            
            return cell
            
        }else{
            viewPhotos.isHidden = true
            viewDetails.isHidden = true
            viewPreferences.isHidden = false
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPreferences", for: indexPath as IndexPath) as! preferencesCollectionViewCell
            cell.mutDictUserDetail = mutDictUserProfileDetail

            return cell
        }
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewProfile.frame.size
        
    }

    

}


extension userProfileEditScreenVC :  UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let Selectedimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if let userid = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID){
                
                let param = ["user_id":"\(userid)","profile_pic_number":"1"]
                MBProgressHUD.showAdded(to: self.view, animated: true)
                Webservices_Alamofier.postImageToUrl(Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.UpdateProfilePic, param: param as NSDictionary, image: Selectedimage, withImageName: "profile_pic") { (success, response) in
                    
                    
                    if success == true
                    {
                        if let dataDict = response.object(forKey: "response_data") as? NSDictionary
                        {
                            Constants.GlobalConstants.appDelegate.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
                            UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
                            
                            if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
                            {
                                UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
                                UserDefaults.standard.synchronize()
                            }
                        }
                        
                        self.collectionViewProfile.reloadItems(at: [IndexPath.init(row: 1, section: 0)])
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    }
                    else
                    {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        if let msg = response.object(forKey: "message") as? String
                        {
                            self.view.makeToast(msg)
                        }
                        else
                        {
                            self.view.makeToast("Please try after sometime.")
                        }
                    }
                    
                }
                
                
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
