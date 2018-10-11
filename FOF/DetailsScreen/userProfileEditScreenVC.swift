//
//  userProfileEditScreenVC.swift
//  FOF
//
//  Create



//d by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import MBProgressHUD

class userProfileEditScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var collectionViewProfile: UICollectionView!
    
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewPhotos: UIView!
    var mutDictUserProfileDetail = NSMutableDictionary()
    
    
    @IBOutlet weak var viewPreferences: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushController), name: Constants.UserDefaults.pushNotificationName, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pushController(){
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "testBudsScreenVC") as! testBudsScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnSaveAct(_ sender: Any) {
        let data = UserDefaults.standard.object(forKey: "mutDictUserDetail") as! NSData
        let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
        
        
        let dataDictUser = UserDefaults.standard.object(forKey: "mutDictUser") as! NSData
        let objectDictUser = NSKeyedUnarchiver.unarchiveObject(with: dataDictUser as Data) as! NSDictionary
        
        print(objectDictUser)
        mutDictUserProfileDetail = object as! NSMutableDictionary
          print(mutDictUserProfileDetail)
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let dictEditProfilePara = ["action":"editprofile","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String,"first_name":mutDictUserProfileDetail.object(forKey:"first_name") as! String ,"last_name":mutDictUserProfileDetail.object(forKey:"last_name") as! String ,"dob":mutDictUserProfileDetail.object(forKey:"Birthday") as! String,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID) as! String,"showme":objectDictUser.object(forKey:"showme") as! String,"distance_unit":objectDictUser.object(forKey:"distance_unit") as! String,"search_min_age":objectDictUser.object(forKey:"search_min_age") as! String,"search_max_age":objectDictUser.object(forKey:"search_max_age") as! String,"search_distance":Constants.GlobalConstants.appDelegate.userDetail.searchDistance,"isreviewed":(0),"occupation":mutDictUserProfileDetail.object(forKey:"occupation") as! String,"relationship":mutDictUserProfileDetail.object(forKey:"RelationShip") as! String,"education":mutDictUserProfileDetail.object(forKey:"education") as! String,"about_me":mutDictUserProfileDetail.object(forKey:"about_me") as! String,"ethnicity":mutDictUserProfileDetail.object(forKey:"ethnicity") as! String, "is_receive_invitation_notifications":objectDictUser.object(forKey:"is_receive_invitation_notifications"),
            "is_receive_messages_notifications":objectDictUser.object(forKey:"is_receive_messages_notifications"),
            "is_show_location":objectDictUser.object(forKey:"is_show_location"),"fields": "first_name,last_name,dob,showme,search_distance,search_max_age,search_min_age,is_receive_invitation_notifications,is_receive_messages_notifications,distance_unit,is_show_location,isreviewed,about_me,ethnicity,education"] as [String : Any]
                WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
                    if success == true
                    {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                        if let dataArray = response.object(forKey: "data") as? NSArray
                        {
                            if dataArray.count != 0
                            {
                                if let dict = dataArray.object(at: 0) as? NSDictionary
                                {
                                    Constants.GlobalConstants.appDelegate.userDetail = UserDetail.modelObject(with: dict as! [AnyHashable : Any])
                                    let placesData = NSKeyedArchiver.archivedData(withRootObject: dataArray)
                                    UserDefaults.standard.set(placesData, forKey: Constants.UserDefaults.ProfileData)
                                    UserDefaults.standard.set(dict.object(forKey: "testbuds"), forKey: Constants.UserDefaults.MyTestBuds)
                                    if let sessionid = dict.object(forKey: "sessionid")
                                    {
                                        UserDefaults.standard.set("\(sessionid)", forKey: Constants.UserDefaults.session_ID)
                                    }
                                }
                            }
                        }
                    }else{
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                    }
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
