//
//  userProfileEditScreenVC.swift
//  FOF
//
//  Created by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class userProfileEditScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var collectionViewProfile: UICollectionView!
    
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewPhotos: UIView!
    
    
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
        
          NotificationCenter.default.post(name: Constants.UserDefaults.notificationName, object: nil)
        
//        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
//            if success == true
//            {
//                if let dataArray = response.object(forKey: "data") as? NSArray
//                {
//                    if dataArray.count != 0
//                    {
//                        if let dict = dataArray.object(at: 0) as? NSDictionary
//                        {
//                            Constants.GlobalConstants.appDelegate.userDetail = UserDetail.modelObject(with: dict as! [AnyHashable : Any])
//                            let placesData = NSKeyedArchiver.archivedData(withRootObject: dataArray)
//                            UserDefaults.standard.set(placesData, forKey: Constants.UserDefaults.ProfileData)
//                            UserDefaults.standard.set(dict.object(forKey: "testbuds"), forKey: Constants.UserDefaults.MyTestBuds)
//                            if let sessionid = dict.object(forKey: "sessionid")
//                            {
//                                UserDefaults.standard.set("\(sessionid)", forKey: Constants.UserDefaults.session_ID)
//                            }
//                        }
//                    }
//                }
//            }
//        }
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
            
            return cell
        }
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewProfile.frame.size
        
    }

    

}
