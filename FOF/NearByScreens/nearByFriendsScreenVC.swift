//
//  nearByFriendsScreenVC.swift
//  FOF
//


import UIKit
import GoogleMaps
import MBProgressHUD

class nearByFriendsScreenVC: UIViewController {

    @IBOutlet weak var collectionViewNearByFrnds: UICollectionView!
    @IBOutlet weak var aMapView: GMSMapView!
    
    var ArrayFriendData = NSMutableArray()
    
    private func showStatusAlert(
        withImage image: UIImage?,
        title: String?,
        message: String?) {
        
        let statusAlert = StatusAlert()
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = true
        statusAlert.accessibilityAnnouncement = {
            if let title = title {
                if let message = message {
                    return [title, ", ", message].joined()
                }
                return title
            } else if let message = message {
                return message
            }
            return nil
        }()
        statusAlert.show(withVerticalPosition: .center)
    }
    
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        
        
    }

    
    override func loadView()
    {
        super.loadView()
        let mainBundle = Bundle.main
        let styleUrl = mainBundle.url(forResource: "style", withExtension: "json")
        
        //Set the map style by passing the URL for style.json.
        
        do
        {
            let style = try GMSMapStyle.init(contentsOfFileURL: styleUrl!)
            aMapView.mapStyle = style;
            aMapView.delegate=self;
            aMapView.isMyLocationEnabled = true;
        }
        catch
        {
            print("The style definition could not be loaded: %@", error);
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.GetSuggestedFriend()
    }
    
     // MARK: - Button Actions
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        
    }
    
    @IBAction func btnFilterAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnSingleToggleAct(_ sender: Any) {
        let allviewController = self.navigationController?.viewControllers
        if allviewController![0].isKind(of:nearByFriendsScreenVC.self)
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByRestaurantsScreenVC") as! nearByRestaurantsScreenVC
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade;
            transition.subtype = kCATransitionFromRight;
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(obj, animated: false)
        }
        else
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            transition.subtype = kCATransitionFromLeft
            navigationController?.view.layer.add(transition, forKey:kCATransition)
            let _ = navigationController?.popViewController(animated: false)
        }
        
    }
    
    @objc func btnActionMessage(sender : UIButton)
    {
        if let dict = self.ArrayFriendData.object(at: sender.tag) as? NSDictionary
        {
            if let friendstatus = dict.object(forKey: "friendstatus"),let frndID = dict.object(forKey: "id")
            {
                if "\(friendstatus)" == "Friends"
                {
                
                    
                }
                else
                {
//                    let dictParameters = ["action":"sendfriendrequest","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID),"friendid":"\(frndID)"]
//
//                    MBProgressHUD.showAdded(to: self.view, animated: true)
//
//                    WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictParameters as NSDictionary) { (success, response) in
//                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                        if success == true
//                        {
//                            self.showStatusAlert(withImage: UIImage.init(named: "add_friend_btn"), title: "Friend Request", message: "Friend Request sent successfully")
//                        }
//                        else
//                        {
//                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                            if let settings = response.object(forKey: "settings") as? NSDictionary
//                            {
//                                if let errormessage = settings.object(forKey: "errormessage") as? String
//                                {
//                                    self.showStatusAlert(withImage: UIImage.init(named: "add_friend_btn"), title: "Friend Request", message: errormessage)
//                                }
//                            }
//
//
//                        }
//
//                    }
                }
            }
        }
    }
    
    
    
    
    
    
    // MARK: - webService
    func wsSetFriendsList(){
        let param = ["action":"myfriends","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID)]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
            
            if success == true
            {
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    if dataArray.count != 0
                    {
                        for i in 0..<dataArray.count
                        {
                            if let dict = dataArray.object(at: i) as? NSDictionary
                            {
                                if let details = dict.object(forKey: "details") as? NSArray
                                {
                                    if details.count != 0
                                    {
                                        if let detailsDict = details.object(at: 0) as? NSDictionary
                                        {
                                            self.ArrayFriendData.add(detailsDict)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
            else if response.object(forKey: "message") != nil
            {
                //self.view.makeToast(response.object(forKey: "message") as! String)
            }
            else
            {
                if response.object(forKey: "message") != nil
                {
                    //self.view.makeToast(response.object(forKey: "message") as! String)
                }
            }
            
            self.GetSuggestedFriend()
            
        })
        
    }
    
    func GetSuggestedFriend(){
        let param = ["action":"usersuggestion","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID)!,"skip":"0","limit":"20"]
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
            
            if success == true
            {
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    if self.ArrayFriendData.count != 0
                    {
                        self.ArrayFriendData.removeAllObjects()
                        self.ArrayFriendData.addObjects(from: dataArray as! [Any])
                    }
                    else
                    {
                        self.ArrayFriendData = NSMutableArray(array: dataArray)
                    }
                }
                
            }
            else if response.object(forKey: "message") != nil
            {
                //self.view.makeToast(response.object(forKey: "message") as! String)
            }
            else
            {
                if response.object(forKey: "message") != nil
                {
                    //self.view.makeToast(response.object(forKey: "message") as! String)
                }
            }
            
            
           self.setFriendOrSuggestArray()
            
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:- Custome method
    
    func setFriendOrSuggestArray()
    {
        if self.ArrayFriendData.count != 0
        {
            for i in 0..<self.ArrayFriendData.count
            {
                if let dict = self.ArrayFriendData.object(at: i) as? NSDictionary
                {
                    if let testbuds = dict.object(forKey: "testbuds") as? String
                    {
                        let testBudsArray = (testbuds as NSString).components(separatedBy: ",")
                        
                        if testBudsArray.count != 0
                        {
                            if let myTestBuds = UserDefaults.standard.object(forKey: Constants.UserDefaults.MyTestBuds) as? NSArray
                            {
                                var IntStr = 0
                                
                                for str in testBudsArray
                                {
                                    for j in 0..<myTestBuds.count
                                    {
                                        if let myBudsDict = myTestBuds.object(at: j) as? NSDictionary
                                        {
                                            if let name = myBudsDict.object(forKey: "name") as? String
                                            {
                                                if str == name
                                                {
                                                    IntStr = IntStr + 1
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                let persentageMatch = IntStr*100/myTestBuds.count
                                let muteDict = NSMutableDictionary(dictionary: dict)
                                muteDict.setValue(persentageMatch, forKey: "matchBuds")
                                if muteDict.object(forKey: "friendstatus") == nil
                                {
                                    muteDict.setValue("notFriend", forKey: "friendstatus")
                                }
                                self.ArrayFriendData.replaceObject(at: i, with: muteDict)
                            }
                        }
                        
                        
                    }
                }
            }
        }
        
        print("After All Adjustment :- \(ArrayFriendData)")
        
        if self.ArrayFriendData.count == 0
        {
            self.collectionViewHeight.constant = 0
            self.collectionViewNearByFrnds.isHidden = true
        }
        else
        {
            self.collectionViewHeight.constant = 180
            self.collectionViewNearByFrnds.isHidden = false
        }
        
        self.collectionViewNearByFrnds.reloadData()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
    }
    

}

extension nearByFriendsScreenVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  self.ArrayFriendData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        cell.viewBack.layer.shadowOpacity = 0.7
        cell.viewBack.layer.shadowOffset = CGSize.zero
        cell.viewBack.layer.shadowRadius = 3.0
        cell.viewBack.layer.shadowColor = UIColor.lightGray.cgColor
        
        if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
        {
            
            if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let distance = dict.object(forKey: "distance"),let profilepic1 = dict.object(forKey: "profilepic1")
            {
                if let friendstatus = dict.object(forKey: "friendstatus")
                {
                    if "\(friendstatus)" == "Friends"
                    {
                        cell.btnMEssage.setImage(UIImage.init(named: "chatIcon"), for: .normal)
                        if let matchBuds = dict.object(forKey: "matchBuds")
                        {
                            cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                            cell.viewMatchProfileRate.progressStrokeColor = Utility.UIColorFromHex(0xD42926)
                            cell.viewMatchProfileRate.fontColor = Utility.UIColorFromHex(0xD42926)
                        }
                        else
                        {
                            cell.viewMatchProfileRate.value = 0
                            cell.viewMatchProfileRate.progressStrokeColor = Utility.UIColorFromHex(0xD42926)
                            cell.viewMatchProfileRate.fontColor = Utility.UIColorFromHex(0xD42926)
                        }
                        //matchBuds
                        
                    }
                    else
                    {
                        cell.btnMEssage.setImage(UIImage.init(named: "add_friend_btn"), for: .normal)
                        
                        if let matchBuds = dict.object(forKey: "matchBuds")
                        {
                            cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                            cell.viewMatchProfileRate.progressStrokeColor = Utility.UIColorFromHex(0x8b1ea7)
                            cell.viewMatchProfileRate.fontColor = Utility.UIColorFromHex(0x8b1ea7)
                        }
                        else
                        {
                            cell.viewMatchProfileRate.value = 0
                            cell.viewMatchProfileRate.progressStrokeColor = Utility.UIColorFromHex(0x8b1ea7)
                            cell.viewMatchProfileRate.fontColor = Utility.UIColorFromHex(0x8b1ea7)
                        }
                    }
                }
                else
                {
                    cell.btnMEssage.setImage(UIImage.init(named: "add_friend_btn"), for: .normal)
                    
                    if let matchBuds = dict.object(forKey: "matchBuds")
                    {
                        cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                        cell.viewMatchProfileRate.progressStrokeColor = Utility.UIColorFromHex(0x8b1ea7)
                        cell.viewMatchProfileRate.fontColor = Utility.UIColorFromHex(0x8b1ea7)
                    }
                    else
                    {
                        cell.viewMatchProfileRate.value = 0
                        cell.viewMatchProfileRate.progressStrokeColor = Utility.UIColorFromHex(0x8b1ea7)
                        cell.viewMatchProfileRate.fontColor = Utility.UIColorFromHex(0x8b1ea7)
                    }
                }

                
                cell.btnMEssage.tag = indexPath.row
                cell.btnMEssage.addTarget(self, action: #selector(btnActionMessage(sender:)), for: .touchUpInside)
                
                cell.lblFriendName.text = "\(first_name) \(last_name)"
                cell.lblDistance.setTitle("\(distance) km", for: .normal)
                cell.imgViewFriendProfile.cornerRadius = cell.imgViewFriendProfile.frame.width/2
                cell.imgViewFriendProfile.clipsToBounds = true
                cell.imgViewFriendProfile.image = UIImage.init(named: "disableSingle")
                if "\(profilepic1)" != ""
                {
                    if let proURL = URL.init(string: "\(profilepic1)")
                    {
                        cell.imgViewFriendProfile.sd_setImage(with: proURL)
                    }
                }
                
                cell.imgViewMutualFriend.cornerRadius = cell.imgViewMutualFriend.frame.width/2
                cell.imgViewMutualFriend.clipsToBounds = true
                cell.imgViewMutualFriend.image = UIImage.init(named: "disableGroup")
                if let mutualfriendsArray = dict.object(forKey: "mutualfriends") as? NSArray
                {
                    if mutualfriendsArray.count != 0
                    {
                        if let frndDict = mutualfriendsArray.object(at: 0) as? NSDictionary
                        {
                            if let profilepic11 = frndDict.object(forKey: "profilepic1") as? String
                            {
                                if "\(profilepic11)" != ""
                                {
                                    cell.imgViewMutualFriend.sd_setImage(with: URL.init(string: "\(profilepic11)")!)
                                }
                            }
                        }
                    }
                    else
                    {
                        cell.lblMutualFriend.text = "No mutual friend"
                    }
                }
                
                
                
                
            }
            
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height:  self.collectionViewNearByFrnds.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "userProfileDetailScreenVC") as! userProfileDetailScreenVC
            obj.UserDetailData = dict
            obj.isShowRecomended = false
            self.navigationController?.pushViewController(obj, animated: true)
        }
        
    }
    
}

extension nearByFriendsScreenVC : GMSMapViewDelegate
{
    
}
