////
//  nearByFriendsScreenVC.swift
//  FOF
//


import UIKit
import GoogleMaps
import CoreLocation

class nearByFriendsScreenVC: UIViewController,GMSMapViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var tblViewAddress: UITableView!
    
    @IBOutlet weak var collectionViewNearByFrnds: UICollectionView!
    @IBOutlet weak var aMapView: GMSMapView!
    
    var ArrayAllFriendData = NSMutableArray()
    var ArrayFriendData = NSMutableArray()
    var clusterManager: GMUClusterManager!
    var latitude = String()
    var longitude = String()
    var location: CLLocation?
    var locationManager = CLLocationManager()
    var objofFilter : filterScreenVC?
    //var isCurrentLocation = true
    
    @IBOutlet weak var nslcHightOfButton: NSLayoutConstraint!
    @IBOutlet weak var btnCancelOut: UIButton!
    @IBOutlet weak var btnSearchOut: UIButton!
    @IBOutlet weak var txtFieldLocation: UITextField!
    
    var arrForAddress = NSMutableArray()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
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
    var SearchLocationDict : NSDictionary?
     let app = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        let cdm = CoreDataManage()
        let arr = cdm.fetchWithEntityName(entity: "UserData")

        print(arr)
        
        txtFieldLocation.delegate = self
        txtFieldLocation.addTarget(self, action: #selector(myTargetFunction(textField:)), for: UIControlEvents.allTouchEvents)
        txtFieldLocation.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.tblViewAddress.backgroundView = blurEffectView
        tblViewAddress.layoutMargins = UIEdgeInsets.zero
        tblViewAddress.tableFooterView = UIView(frame: CGRect.zero)
        tblViewAddress.separatorInset = UIEdgeInsets.zero
        tblViewAddress.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
       // if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isCurrentLocationFrnd){
            let obj = nearByFriendsScreenVC()
            Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
            NotificationCenter.default.addObserver(self, selector: #selector(retriveLocation), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
       // }
        self.objofFilter = (self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC)
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
        nslcHightOfButton.constant = 10
        btnCancelOut.setTitle("", for: .normal)
        btnSearchOut.setTitle("", for: .normal)
        self.btnSearchOut.contentHorizontalAlignment = .right
        self.btnCancelOut.contentHorizontalAlignment = .left
        
        UserDefaults.standard.set("Yes", forKey: Constants.UserDefaults.isOpenFriendViewController)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: NSNotification.Name(rawValue: "Cancel"), object: nil)

    }
    @objc func retriveLocation(){
        
        self.txtFieldLocation.text = ""
        
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isFriend)
        {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
            longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
            
            self.wsSetFriendsList()
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
            longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
            
            location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
            if self.SearchLocationDict != nil
            {
                txtFieldLocation.text = SearchLocationDict!.object(forKey: "description") as? String
                
                getPlaceDetail(googlePlaceID:SearchLocationDict!.object(forKey: "place_id") as! String, location: txtFieldLocation.text!)
            }
            else
            {
                geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                    if error == nil, let placemark = placemarks, !placemark.isEmpty {
                        self.placemark = placemark.last
                        self.parsePlacemarks()
                    }
                    else
                    {
                        if error != nil
                        {
                            //                        self.view.makeToast("\(error!.localizedDescription)")
                            self.view.makeToast("Something went to wrong with geting your current location. Please try after sometime")
                        }
                        else
                        {
                            self.view.makeToast("Something went to wrong. Please try after sometime")
                        }
                        //                    self.retriveLocation()
                    }
                    
                    
                })
            }

        }
        
        
    }
    func parsePlacemarks() {
        if let _ = location {
            if let placemark = placemark {
                var city1 = ""
                var country1 = ""
                    if let city = placemark.locality, !city.isEmpty {
                       city1 = city
                    }
                    if let country = placemark.country, !country.isEmpty {
                        country1 = country
                    }
                let strAddress = placemark.addressDictionary as! [String:AnyObject]
                let strFormatted = strAddress["FormattedAddressLines"]! as! NSArray
                setProfile(str: "\(strFormatted[0]),\(strFormatted[1]),\(city1),\(country1)", latitude: latitude , longitude: longitude)

                locationManager.stopUpdatingLocation()
            }
        } else {}
    }
    func setProfile(str: String , latitude : String,longitude : String){
       // latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
       // longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
        
        if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
        {
            UserDefaults.standard.set("20000", forKey: Constants.UserDefaults.FilterDistance)
            UserDefaults.standard.synchronize()
        }
        
        if let dict = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSDictionary,let radius = UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance)
        {
           
            
            if let profileDict = UserDefaults.standard.object(forKey:  Constants.UserDefaults.ProfileData) as? NSDictionary
            {
                self.app.userDetail = UserDetail.init(dictionary: profileDict as? [AnyHashable : Any])
            }
            else
            {
                 self.getProfileDetail(str: str , latitude : latitude,longitude : longitude)
            }
            
            if let showsearch_max_ageme = dict.object(forKey: "search_max_age"),let search_min_age = dict.object(forKey: "search_min_age"),let showme = dict.object(forKey: "showme")
            {
                
                _ = UserDetail.init(dictionary: dict as? [AnyHashable : Any])
                
                var searchDictanceRange = Int("\(radius)") ?? 0
                
                searchDictanceRange = searchDictanceRange/1610
                
                let dictEditProfilePara = ["user_id":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"latitude":latitude,"longitude":longitude,"address":"\(str)","search_distance":"\(searchDictanceRange)","search_min_age":"\(search_min_age)","search_max_age":"\(showsearch_max_ageme)","gender":"\(showme)"]
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetUserSuggestion, param: dictEditProfilePara as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                    
                    if success == true
                    {
                        if let data = response.object(forKey: "response_data") as? NSDictionary
                        {
                            
                            if let users = data.object(forKey: "users") as? NSArray
                            {
                                self.ArrayFriendData.removeAllObjects()
                                self.ArrayAllFriendData.removeAllObjects()
                                
                                self.ArrayFriendData.addObjects(from: users as! [Any])
                                self.ArrayAllFriendData.addObjects(from: users as! [Any])
                                
                                
                            }
                        }
                        
                        let userLoacation = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!)
                        let camera = GMSCameraPosition.camera(withTarget: userLoacation, zoom: 14)
                        self.aMapView.camera = camera
                        self.setFriendOrSuggestArray()
                    
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
                            
                            let alert = UIAlertController.init(title: "FOF", message: "Something went to wrong. Please try after sometime.", preferredStyle: .alert)
                            let retry = UIAlertAction(title: "Retry", style: .default, handler: { (act) in
                                self.setProfile(str: str, latitude: latitude, longitude: longitude)
                            })
                            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            
                            alert.addAction(retry)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                        
                }
                    
            }
        }
        else
        {
            if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
            {
                UserDefaults.standard.set(20000, forKey: Constants.UserDefaults.FilterDistance)
                UserDefaults.standard.synchronize()
                
                self.setProfile(str: str , latitude : latitude,longitude : longitude)
            }
            else
            {
                self.getProfileDetail(str: str , latitude : latitude,longitude : longitude)
            }
            
        }
        
        
        
//         let dictEditProfilePara = ["action":"editprofile","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID),"location":"\(latitude),\(longitude)","location_string":str,"fields":"location,location_string"]
//        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
//            if success == true
//            {
//                let arr = response["data"] as! NSArray
//                let dictArray = arr[0] as! NSDictionary
//                UserDefaults.standard.set(dictArray.object(forKey: "search_distance")!, forKey: "strDistance")
//                UserDefaults.standard.set(dictArray.object(forKey: "search_min_age")!, forKey: "strLowerValue")
//                UserDefaults.standard.set(dictArray.object(forKey: "search_max_age")!, forKey: "strUpperValue")
//                UserDefaults.standard.set(dictArray.object(forKey: "showme")!, forKey: Constants.UserDefaults.gender)
//                UserDefaults.standard.set(dictArray.object(forKey: "testbuds"), forKey: Constants.UserDefaults.MyTestBuds)
//                if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isFriend){
//                    self.wsSetFriendsList()
//                }else{
//                self.GetSuggestedFriend()
//                }
//            }else{
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//            }
//        }
    }
    
    func getProfileDetail(str: String , latitude : String,longitude : String)
    {
        if let user_id = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
        {
            let param = ["user_id":"\(user_id)"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetUserProfile, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                
                if success == true
                {
                    if let dataDict = response.object(forKey: "response_data") as? NSDictionary
                    {
                        self.app.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
                        UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
                        
                        if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
                        {
                            UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
                            
                        }
                        
                        UserDefaults.standard.synchronize()
                        self.setProfile(str: str , latitude : latitude,longitude : longitude)
                    }
                    
                    
                }
                else
                {
                    if let msg = response.object(forKey: "message") as? String
                    {
                        self.view.makeToast(msg)
                    }
                    else
                    {
                        self.view.makeToast("Something went to wring. Please try after sometime.")
                    }
                }
            }
            
        }
        
    }
    
    
    func setmap(){
        
        
        if ArrayFriendData.count > 0 {
        let arrBuckets = NSMutableArray()
        let arrPins = NSMutableArray()
        for i in 0..<ArrayFriendData.count{
            arrBuckets.add(i+1)
            arrPins.add(UIImage(named: "pinkPin") as Any)
        }
            if self.ArrayFriendData.count > 0
            {
                if let dict = ArrayFriendData.object(at: 0) as? NSDictionary{
                    if let latitude = dict["latitude"] , let longitude = dict["longitude"]{
                        
                        let lat = Double("\(latitude)") ?? 0.0
                        let lng = Double("\(longitude)") ?? 0.0
                        if lat != 0.0 && lng != 0.0
                        {
                            let userLoacation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            let camera = GMSCameraPosition.camera(withTarget: userLoacation, zoom: 14)
                            aMapView.camera = camera
                        }
                    }
                }
            }
           
            
        let iconGenerator = GMUDefaultClusterIconGenerator.init(buckets: arrBuckets as! [NSNumber], backgroundImages: arrPins as! [UIImage])
        // Set up the cluster manager with default icon generator and renderer.
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: aMapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: aMapView, algorithm: algorithm, renderer: renderer)
            generateClusterItems()
            clusterManager.cluster()
            clusterManager.setDelegate(self, mapDelegate: self)}
    }
    
    // MARK: - TextField delegate method
    @objc func myTargetFunction(textField: UITextField) {
        UIView.animate(withDuration: 2.5) {
           self.nslcHightOfButton.constant = 30
            self.btnCancelOut.setTitle("Cancel", for: .normal)
            self.btnSearchOut.setTitle("Search", for: .normal)
            self.btnSearchOut.contentHorizontalAlignment = .right
            self.btnCancelOut.contentHorizontalAlignment = .left
        }
        
    }
    @objc func textFieldDidChange(textField : UITextField){
        
        if (textField.text?.count)! > 0 {
                self.fetchBusinessFromGoogle(textField.text!)
        }}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if self.SearchLocationDict != nil
        {
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isCurrentLocationFrnd)
            
            txtFieldLocation.text = SearchLocationDict!.object(forKey: "description") as? String
            
            nslcHightOfButton.constant = 10
            btnCancelOut.setTitle("", for: .normal)
            btnSearchOut.setTitle("", for: .normal)
            txtFieldLocation.resignFirstResponder()
            self.tblViewAddress.isHidden = true
            
            getPlaceDetail(googlePlaceID:SearchLocationDict!.object(forKey: "place_id") as! String, location: txtFieldLocation.text!)
            
            txtFieldLocation.resignFirstResponder()
        }
        else
        {
            Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast("Please search proper place.")
            
            nslcHightOfButton.constant = 10
            btnCancelOut.setTitle("", for: .normal)
            btnSearchOut.setTitle("", for: .normal)
            txtFieldLocation.resignFirstResponder()
            self.tblViewAddress.isHidden = true
            
            txtFieldLocation.resignFirstResponder()
        }
        return true
    }
     // MARK: - Button Actions
    
    @IBAction func btnCurrentLocationAct(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isCurrentLocationFrnd)

        txtFieldLocation.text = ""
        let obj = nearByFriendsScreenVC()
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
    }
    
    
    @IBAction func btnCancelAct(_ sender: Any) {
        nslcHightOfButton.constant = 10
        btnCancelOut.setTitle("", for: .normal)
        btnSearchOut.setTitle("", for: .normal)
        txtFieldLocation.resignFirstResponder()
        tblViewAddress.isHidden = true
    }
    
    @IBAction func btnClearAct(_ sender: Any) {
        txtFieldLocation.text = ""
        tblViewAddress.isHidden = true
        self.SearchLocationDict = nil
        nslcHightOfButton.constant = 10
        btnCancelOut.setTitle("", for: .normal)
        btnSearchOut.setTitle("", for: .normal)
        txtFieldLocation.resignFirstResponder()
        tblViewAddress.isHidden = true
        
    }
    
    @IBAction func btnSearchAct(_ sender: Any) {
      
        if self.SearchLocationDict != nil
        {
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isCurrentLocationFrnd)
            
            txtFieldLocation.text = SearchLocationDict!.object(forKey: "description") as? String
            
            nslcHightOfButton.constant = 10
            btnCancelOut.setTitle("", for: .normal)
            btnSearchOut.setTitle("", for: .normal)
            txtFieldLocation.resignFirstResponder()
            self.tblViewAddress.isHidden = true
            
            getPlaceDetail(googlePlaceID:SearchLocationDict!.object(forKey: "place_id") as! String, location: txtFieldLocation.text!)
            
            txtFieldLocation.resignFirstResponder()
        }
        else
        {
            Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast("Please select a Location from the list.")
            
            nslcHightOfButton.constant = 10
            btnCancelOut.setTitle("", for: .normal)
            btnSearchOut.setTitle("", for: .normal)
            txtFieldLocation.resignFirstResponder()
            self.tblViewAddress.isHidden = true
            
            txtFieldLocation.resignFirstResponder()
        }
       
    }
    
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "testBudsScreenVC") as! testBudsScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnFilterAct(_ sender: Any) {
        self.app.isFilterFriend = true
        addChildViewController(objofFilter!)
        self.view.addSubview(objofFilter!.view)
        objofFilter!.didMove(toParentViewController: self)
        
    }
    @objc func cancel(){
        objofFilter!.willMove(toParentViewController: nil)
        objofFilter!.view.removeFromSuperview()
        objofFilter!.removeFromParentViewController()
        retriveLocation()
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
        }else{
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            transition.subtype = kCATransitionFromLeft
            navigationController?.view.layer.add(transition, forKey:kCATransition)
            let _ = navigationController?.popViewController(animated: false)
        }
    }
    
    @objc func btnActionMessage(sender : UIButton){
    if let dict = self.ArrayFriendData.object(at: sender.tag) as? NSDictionary{
    if dict.object(forKey: "friendstatus") as! String == "Sent"{
        return
        }
        let objChat = self.storyboard?.instantiateViewController(withIdentifier: "conversationScreenVC") as! conversationScreenVC
        objChat.dictUserDetail = dict
        
        if let chatid = dict.object(forKey: "request_id")
        {
            objChat.chatGrpId = "\(chatid)"
        }
        
        if dict.object(forKey: "friendstatus") as! String == "Friend"{
            objChat.isFreind = true
        }else{
            objChat.isFreind = false
            }
        self.navigationController?.pushViewController(objChat, animated: true)
        }
    }
//    {
//        if let dict = self.ArrayFriendData.object(at: sender.tag) as? NSDictionary
//        {
//            if let friendstatus = dict.object(forKey: "friendstatus"),let frndID = dict.object(forKey: "id")
//            {
//                if "\(friendstatus)" == "Friends"
//                {
//
//                }
//                else
//                {

//                }
//            }
//        }
//    }
    
    
    
    
    
    
    // MARK: - webService
    func fetchBusinessFromGoogle (_ searchname : String){
        if searchname.count > 0 {
            WebService.GetAutoCompletePlaces(searchname, locationString: "\(latitude),\(longitude)", radiusString: "20000", CompletionHandler: { (success, response) in
                if success == true {
                   self.tblViewAddress.isHidden = false
                    if let resultArr : NSArray = response.object(forKey: "predictions") as? NSArray {
                        self.arrForAddress = NSMutableArray(array: resultArr)
                        self.tblViewAddress.reloadData()
                    } else {
                        self.arrForAddress = NSMutableArray()
                        self.tblViewAddress.reloadData()
                    }
                } else {
                    self.arrForAddress = NSMutableArray()
                    self.tblViewAddress.reloadData()
                }
            })
        } else {
            self.arrForAddress = NSMutableArray()
            self.tblViewAddress.reloadData()
        }}
    func getPlaceDetail(googlePlaceID:String , location : String) {
        
        WebService.GetPlaceDetailByPlaceId(googlePlaceID) { (success, response) -> () in
            if success == true {
                if (response.object(forKey: "result") != nil) {
                    let arr = response.object(forKey: "result") as! NSDictionary
                    let dict = arr["geometry"] as? NSDictionary
                    if let loc = dict!["location"] as? NSDictionary{
                        let lat = String(describing:loc["lat"]!)
                        let lng = String(describing:loc["lng"]!)
                       
                        self.setProfile(str: location, latitude: lat , longitude: lng)
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        }}
    func wsSetFriendsList(){
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

        let obj = getFriendsScreen()
        obj.wsSetFriendsList { (isNewUser, arrFrndData) in
            print(isNewUser,arrFrndData)
            
            self.ArrayFriendData.removeAllObjects()
            self.ArrayAllFriendData.removeAllObjects()
            
            for i in arrFrndData
            {
                let dict = i as! NSDictionary
                if let detailsarry = dict.object(forKey: "details") as? NSArray
                {
                    if detailsarry.count > 0,let detail = detailsarry.object(at: 0) as? NSDictionary
                    {
                        self.ArrayFriendData.add(detail)
                        self.ArrayAllFriendData.add(detail)
                    }
                }
                self.setFriendOrSuggestArray()

            }
            
        }

    }
    
    func GetSuggestedFriend(){
        let param = ["action":"usersuggestion","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID)!,"skip":"0","limit":"20"]
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
            
            if success == true
            {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                var isRemove = false
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    let arrDataForFilter = dataArray as! [[String:AnyObject]]
                       if let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.gender) as? String{
                      self.ArrayFriendData.removeAllObjects()
                        for i in arrDataForFilter{
                            let strGende = i["gender"] as! String
                            if str == "all" || str == "female,male" {
                                if self.ArrayFriendData.count != 0{
                                    if isRemove{}else{self.ArrayFriendData.removeAllObjects()
                                        isRemove = true}
                                    self.ArrayFriendData.add(i)
                                }else{
                                   self.ArrayFriendData = NSMutableArray(array: dataArray)
                                }
                            }else if  str == "lgbt,femal" || str == "female"{
                                if strGende == "female"{
                                    if self.ArrayFriendData.count != 0{
                                        if isRemove{}else{self.ArrayFriendData.removeAllObjects()
                                            isRemove = true}
                                        self.ArrayFriendData.add(i)
                                    }else{
                                        self.ArrayFriendData = NSMutableArray(array: dataArray)
                                    }
                                }
                            }else if str == "male" || str == "lgbt,male"{
                                if strGende == "male"{
                                    if self.ArrayFriendData.count != 0{
                                        if isRemove{}else{self.ArrayFriendData.removeAllObjects()
                                            isRemove = true}
                                        self.ArrayFriendData.add(i)
                                    }else{
                                      self.ArrayFriendData = NSMutableArray(array: dataArray)
                                    }
                                }
                            }
                        }
                    }
                   
                }
            }else if response.object(forKey: "message") != nil {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

            } else {
                if response.object(forKey: "message") != nil
                {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
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
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        self.aMapView.clear()
        
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
                                
                                if let count = myTestBuds.count as? Int{
                                    if count != 0{
                                    let persentageMatch = IntStr*100/count
                                let muteDict = NSMutableDictionary(dictionary: dict)
                                    muteDict.setValue(persentageMatch, forKey: "matchBuds")
                                if muteDict.object(forKey: "friendstatus") == nil
                                {
                                    muteDict.setValue("notFriend", forKey: "friendstatus")
                                }
                                        self.ArrayFriendData.replaceObject(at: i, with: muteDict)}}
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
        setmap()
        self.collectionViewNearByFrnds.reloadData()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
    }
    

}
extension nearByFriendsScreenVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.init(name: "GillSans", size: 16.0)
        cell?.textLabel?.frame = CGRect(x: 20, y: 5, width: tableView.frame.size.width - 40, height: 21)
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.textColor = UIColor.white
        if arrForAddress.count > indexPath.row {
            cell?.textLabel?.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
        } else {
            cell?.textLabel?.text = ""
        }
        cell?.textLabel?.sizeToFit()
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dict = self.arrForAddress.object(at: indexPath.row) as? NSDictionary
        {
            self.SearchLocationDict = dict
            
            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isCurrentLocationFrnd)
            
            txtFieldLocation.text = SearchLocationDict!.object(forKey: "description") as? String
            
            nslcHightOfButton.constant = 10
            btnCancelOut.setTitle("", for: .normal)
            btnSearchOut.setTitle("", for: .normal)
            txtFieldLocation.resignFirstResponder()
            tblViewAddress.isHidden = true
            
            getPlaceDetail(googlePlaceID:SearchLocationDict!.object(forKey: "place_id") as! String, location: txtFieldLocation.text!)
            self.tblViewAddress.isHidden = true
            txtFieldLocation.resignFirstResponder()
            
        }
        
       
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
            
            if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let profilepic1 = dict.object(forKey: "profilepic1")
            {
                if let friendstatus = dict.object(forKey: "friendstatus")
                {
                    if "\(friendstatus)" == "Friend"
                    {
                    
                        cell.btnMEssage.setImage(UIImage.init(named: "chatIcon"), for: .normal)
                        if let matchBuds = dict.object(forKey: "matchBuds")
                        {
                            cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                            cell.viewMatchProfileRate.progressStrokeColor = Constants.color.friendMatchProgressColor
                            cell.viewMatchProfileRate.fontColor = Constants.color.friendMatchProgressColor
                        }
                        else
                        {
                            cell.viewMatchProfileRate.value = 0
                            cell.viewMatchProfileRate.progressStrokeColor = Constants.color.friendMatchProgressColor
                            cell.viewMatchProfileRate.fontColor = Constants.color.friendMatchProgressColor
                        }
                        //matchBuds
                        
                    }else if "\(friendstatus)" == "Sent"
                    {
                        
                        cell.btnMEssage.setImage(UIImage.init(named: "requestSent"), for: .normal)
                        if let matchBuds = dict.object(forKey: "matchBuds")
                        {
                            cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                            cell.viewMatchProfileRate.progressStrokeColor = Constants.color.friendMatchProgressColor
                            cell.viewMatchProfileRate.fontColor = Constants.color.friendMatchProgressColor
                        }
                        else
                        {
                            cell.viewMatchProfileRate.value = 0
                            cell.viewMatchProfileRate.progressStrokeColor = Constants.color.friendMatchProgressColor
                            cell.viewMatchProfileRate.fontColor = Constants.color.friendMatchProgressColor
                        }
                        //matchBuds
                        
                    }
                    else
                    {
                        cell.btnMEssage.setImage(UIImage.init(named: "add_friend_btn"), for: .normal)
                     
                        if let matchBuds = dict.object(forKey: "matchBuds")
                        {
                            cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                            cell.viewMatchProfileRate.progressStrokeColor = Constants.color.matchProgressColor
                            cell.viewMatchProfileRate.fontColor = Constants.color.matchProgressColor
                        }
                        else
                        {
                            cell.viewMatchProfileRate.value = 0
                            cell.viewMatchProfileRate.progressStrokeColor = Constants.color.matchProgressColor
                            cell.viewMatchProfileRate.fontColor = Constants.color.matchProgressColor
                        }
                    }
                }
                else
                {
                    cell.btnMEssage.setImage(UIImage.init(named: "add_friend_btn"), for: .normal)
                    
                    if let matchBuds = dict.object(forKey: "matchBuds")
                    {
                        cell.viewMatchProfileRate.value = CGFloat.init(Double("\(matchBuds)")!)
                        cell.viewMatchProfileRate.progressStrokeColor = Constants.color.matchProgressColor
                        cell.viewMatchProfileRate.fontColor = Constants.color.matchProgressColor
                    }
                    else
                    {
                        cell.viewMatchProfileRate.value = 0
                        cell.viewMatchProfileRate.progressStrokeColor = Constants.color.matchProgressColor
                        cell.viewMatchProfileRate.fontColor = Constants.color.matchProgressColor
                    }
                }

                
                cell.btnMEssage.tag = indexPath.row
                cell.lblFriendName.text = "\(first_name) \(last_name)"
                cell.btnMEssage.addTarget(self, action: #selector(btnActionMessage(sender:)), for: .touchUpInside)
                if let distance = dict.object(forKey: "distance") {
                let dist = String(describing: "\(distance)")
                 cell.lblDistance.setTitle("\(dist.prefix(4)) km", for: .normal)}
                cell.imgViewFriendProfile.cornerRadius = cell.imgViewFriendProfile.frame.width/2
                cell.imgViewFriendProfile.clipsToBounds = true
                cell.imgViewFriendProfile.image = UIImage.init(named: "disableSingle")
                if "\(profilepic1)" != ""
                {
                    if let proURL = URL.init(string: "\(profilepic1)")
                    {
                        cell.imgViewFriendProfile.sd_setImage(with: proURL)
                    }
                    if cell.imgViewFriendProfile.image == nil{
                        cell.imgViewFriendProfile.image = UIImage.init(named: "disableSingle")
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
                                    cell.imgViewMutualFriend.isHidden = false
                                    cell.imgViewMutualFriend2.isHidden = true
                                    cell.lblMutualFriend.text = "Mutual friend"
                                    cell.imgViewMutualFriend.sd_setImage(with: URL.init(string: "\(profilepic11)")!)
                                }
                            }
                        }
                        if mutualfriendsArray.count == 2{
                            if let frndDict = mutualfriendsArray.object(at: 1) as? NSDictionary
                            {
                                if let profilepic11 = frndDict.object(forKey: "profilepic1") as? String
                                {
                                    if "\(profilepic11)" != ""
                                    {
                                        cell.imgViewMutualFriend.isHidden = false
                                        cell.imgViewMutualFriend2.isHidden = false
                                    cell.imgViewMutualFriend2.sd_setImage(with: URL.init(string: "\(profilepic11)")!)
                                    }
                                }
                            }
                       }
                    }
                    else
                    {
                        cell.imgViewMutualFriend.isHidden = true
                        cell.imgViewMutualFriend2.isHidden = true
                        cell.lblMutualFriend.text = "No mutual friend"
                    }
                }
                else
                {
                    cell.imgViewMutualFriend.isHidden = true
                    cell.imgViewMutualFriend2.isHidden = true
                    cell.lblMutualFriend.text = "No mutual friend"
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
extension nearByFriendsScreenVC : GMUClusterManagerDelegate,GMUClusterRendererDelegate{
    
    // MARK: - GMUClusterManagerDelegate
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: aMapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        aMapView.moveCamera(update)
        return false
    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? GMUCluster {
            
            print(poiItem.items.count)
            
            self.ArrayFriendData.removeAllObjects()
            
            for data in poiItem.items
            {
                if let data = data as? POIItem
                {
                    self.ArrayFriendData.add(self.ArrayAllFriendData[data.arryIndex])
                }
                
            }
            
            self.collectionViewNearByFrnds.reloadData()
            
            //            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    
    /// cluster manager.
    private func generateClusterItems() {
        for index in 0..<ArrayFriendData.count {
            print(index)
            print(ArrayFriendData[index])
            if let dict = ArrayFriendData.object(at: index) as? NSDictionary{
                if let latitude = dict["latitude"] , let longitude = dict["longitude"]{
                    let lat = Double("\(latitude)") ?? 0.0
                    let lng = Double("\(longitude)") ?? 0.0
                    let name = "Item \(index)"
                    let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name, arryIndex: index)
                    clusterManager.add(item)
                }
            }
            
        }
        
       
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
}

