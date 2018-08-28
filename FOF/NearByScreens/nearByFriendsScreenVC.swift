//
//  nearByFriendsScreenVC.swift
//  FOF
//


import UIKit
import GoogleMaps
import MBProgressHUD
import CoreLocation

class nearByFriendsScreenVC: UIViewController,GMSMapViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var tblViewAddress: UITableView!
    
    @IBOutlet weak var collectionViewNearByFrnds: UICollectionView!
    @IBOutlet weak var aMapView: GMSMapView!
    
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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        

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
    
        NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: NSNotification.Name(rawValue: "Cancel"), object: nil)

    }
    @objc func retriveLocation(){
        MBProgressHUD.showAdded(to: self.view, animated: true)

        latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
        longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String

            location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
            geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
                
                self.parsePlacemarks()
            })
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
        let dictEditProfilePara = ["action":"editprofile","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID),"location":"\(latitude),\(longitude)","location_string":str,"fields":"location,location_string"]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
            if success == true
            {
                let arr = response["data"] as! NSArray
                let dictArray = arr[0] as! NSDictionary
                UserDefaults.standard.set(dictArray.object(forKey: "search_distance")!, forKey: "strDistance")
                UserDefaults.standard.set(dictArray.object(forKey: "search_min_age")!, forKey: "strLowerValue")
                UserDefaults.standard.set(dictArray.object(forKey: "search_max_age")!, forKey: "strUpperValue")
                UserDefaults.standard.set(dictArray.object(forKey: "showme")!, forKey: Constants.UserDefaults.gender)
                UserDefaults.standard.set(dictArray.object(forKey: "testbuds"), forKey: Constants.UserDefaults.MyTestBuds)
                if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isFriend){
                    self.wsSetFriendsList()
                }else{
                self.GetSuggestedFriend()}

            }else{
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }
    }
    func setmap(){
        let userLoacation = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!)
        let camera = GMSCameraPosition.camera(withTarget: userLoacation, zoom: 14)
        aMapView.camera = camera
        if ArrayFriendData.count > 0 {
        let arrBuckets = NSMutableArray()
        let arrPins = NSMutableArray()
        for i in 0..<ArrayFriendData.count{
            arrBuckets.add(i+1)
            arrPins.add(UIImage(named: "pinkPin") as Any)
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
        UIView.animate(withDuration: 0.5) {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
           self.nslcHightOfButton.constant = 30
            self.btnCancelOut.setTitle("Cancel", for: .normal)
            self.btnSearchOut.setTitle("Search", for: .normal)
        }
        
    }
    @objc func textFieldDidChange(textField : UITextField){
        
        if (textField.text?.count)! > 0 {
                self.fetchBusinessFromGoogle(textField.text!)
        }}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
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
        
    }
    
    @IBAction func btnSearchAct(_ sender: Any) {
      
        txtFieldLocation.resignFirstResponder()  
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
        {let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByRestaurantsScreenVC") as! nearByRestaurantsScreenVC
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
    let param = ["action":"sendfriendrequest","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID),"friendid":frndID]
                    
    WebService.postURL(Constants.WebServiceUrl.mainUrl, param: param as NSDictionary, CompletionHandler: { (success, response) in
                        
                    })
                }
            }
        }
    }
    
    
    
    
    
    
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
            self.setFriendOrSuggestArray()

            //self.GetSuggestedFriend()
            
        })
        
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
                            if str == "all" || str == "female,mal" {
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
                                    if count == 0{}else{
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
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isCurrentLocationFrnd)

        txtFieldLocation.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
        getPlaceDetail(googlePlaceID:(arrForAddress.object(at: indexPath.row)as AnyObject).object(forKey: "place_id") as! String, location: txtFieldLocation.text!)
                self.tblViewAddress.isHidden = true
                txtFieldLocation.resignFirstResponder()
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
                    if "\(friendstatus)" == "Friends"
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
                if let distance = dict.object(forKey: "distance") as? String{
                let dist = String(describing: distance)
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
                    }
                    else
                    {
                        cell.imgViewMutualFriend.isHidden = true
                        cell.imgViewMutualFriend2.isHidden = true
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
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
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
                if let loc = dict["location"] as? String{
                  let parts = loc.components(separatedBy: ",")
                    let lat = Double(parts[0])
                    let lng = Double(parts[1])
                    let name = "Item \(index)"
                    let item = POIItem(position: CLLocationCoordinate2DMake(lat!, lng!), name: name)
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

