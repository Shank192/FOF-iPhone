//
//  nearByRestaurantsScreenVC.swift
//  FOF
//


import UIKit
import GoogleMaps
import GooglePlaces

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var arryIndex: Int!
    
    init(position: CLLocationCoordinate2D, name: String, arryIndex:Int) {
        self.position = position
        self.name = name
        self.arryIndex = arryIndex
    }
}

class nearByRestaurantsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSMapViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tblViewAddress: UITableView!
    @IBOutlet weak var collectionViewNearByRestaurants: UICollectionView!
    @IBOutlet weak var txtSearchTestBuds: UITextField!
    @IBOutlet weak var txtFieldLocation: UITextField!
    @IBOutlet weak var btnSearchOut: UIButton!
    @IBOutlet weak var nslcHieghtOfButton: NSLayoutConstraint!
    @IBOutlet weak var btnCancelOut: UIButton!
    @IBOutlet weak var aMapView: GMSMapView!

    @IBOutlet weak var constSearchTestbudsViewHeight: NSLayoutConstraint!
    var objofFilter : filterScreenVC?
    var arrForAddress = NSMutableArray()
    var latitude = String()
    var longitude = String()
    var arrForRestaurantData = [[String:AnyObject]]()
    var arrForAllRestaurantData = [[String:AnyObject]]()
    var clusterManager: GMUClusterManager!
    var arrPlaces = NSMutableArray()
    var arrAllTestBudsPlaces = [[String : AnyObject]]()
    var arrSearchTestBuds = NSMutableArray()
    var IsSearchTestBuds = false
    var arrDuration = NSMutableArray()
    
    var currebntlyRetriveRestuarant = false
    
    var SearchLocationDict : NSDictionary?
    var SearchTestbudsDict : NSDictionary?
    
    //var isCurrentLocation = true
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.tblViewAddress.backgroundView = blurEffectView
        tblViewAddress.layoutMargins = UIEdgeInsets.zero
        tblViewAddress.tableFooterView = UIView(frame: CGRect.zero)
        tblViewAddress.separatorInset = UIEdgeInsets.zero
        tblViewAddress.isHidden = true

       txtFieldLocation.delegate = self
        
        txtSearchTestBuds.delegate = self
        
        txtFieldLocation.addTarget(self, action: #selector(myTargetFunctionLocation(textField:)), for: UIControlEvents.allTouchEvents)
        
           txtSearchTestBuds.addTarget(self, action: #selector(myTargetFunctionTestBuds(textField:)), for: UIControlEvents.allTouchEvents)
        
        txtFieldLocation.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
         txtSearchTestBuds.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        hideKeyboardWhenTappedAround()
        //if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isCurrentLocationRestro){
            let obj = nearByRestaurantsScreenVC()
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
   NotificationCenter.default.addObserver(self, selector: #selector(setLocation), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
      //  }
        
        if let TestArray = UserDefaults.standard.object(forKey: Constants.UserDefaults.AllTestBudsArrayFromYourLocation) as? NSArray
        {
            self.arrAllTestBudsPlaces = TestArray as! [[String : AnyObject]]
        }
      
        self.objofFilter = (self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC)

        
        
    }
    @objc func setLocation(){
        
        if self.currebntlyRetriveRestuarant == false && self.SearchLocationDict == nil
        {
            latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
            longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
            MBProgressHUD.showAdded(to: self.view, animated: true)
            retriveDataForRestaurant(latitude: latitude, longitude: longitude)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        nslcHieghtOfButton.constant = 10
        btnCancelOut.setTitle("", for: .normal)
        btnSearchOut.setTitle("", for: .normal)
        self.constSearchTestbudsViewHeight.constant = 0
        btnSearchOut.contentHorizontalAlignment = .right
        btnCancelOut.contentHorizontalAlignment = .left
        if self.SearchLocationDict != nil
        {
            if let description = self.SearchLocationDict?.object(forKey: "description") as? String
            {
                self.txtFieldLocation.text = description
            }
        }
        else
        {
            self.txtFieldLocation.text = ""
        }
        
        UserDefaults.standard.set("No", forKey: Constants.UserDefaults.isOpenFriendViewController)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: NSNotification.Name(rawValue: "Cancel"), object: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView()
    {
        super.loadView()
        let mainBundle = Bundle.main
        let styleUrl = mainBundle.url(forResource: "style", withExtension: "json")
        do {
            let style = try GMSMapStyle.init(contentsOfFileURL: styleUrl!)
            aMapView.mapStyle = style;
            aMapView.delegate=self;
            aMapView.isMyLocationEnabled = true; }
        catch
        {
            print("The style definition could not be loaded: %@", error);
        }
    }
    func setmap(){
       
        if arrForRestaurantData.count > 0{
        let arrBuckets = NSMutableArray()
        let arrPins = NSMutableArray()
        for i in 0..<arrForRestaurantData.count{
            arrBuckets.add(i+1)
            arrPins.add(UIImage(named: "pinkPin") as Any)
        }
        let iconGenerator = GMUDefaultClusterIconGenerator.init(buckets: arrBuckets as! [NSNumber], backgroundImages: arrPins as! [UIImage])
        // Set up the cluster manager with default icon generator and renderer.
        
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: aMapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: aMapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        }}
    
    // MARK: - TextField delegate method
    @objc func myTargetFunctionLocation(textField: UITextField) {
        
        self.IsSearchTestBuds = false
        
        UIView.animate(withDuration: 0.30) {
            self.nslcHieghtOfButton.constant = 30
            self.btnCancelOut.setTitle("Cancel", for: .normal)
            self.btnSearchOut.setTitle("Search", for: .normal)
            self.constSearchTestbudsViewHeight.constant = 40
            self.btnSearchOut.contentHorizontalAlignment = .right
            self.btnCancelOut.contentHorizontalAlignment = .left
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func myTargetFunctionTestBuds(textField: UITextField) {
        
        self.IsSearchTestBuds = true
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        
        if textField == txtSearchTestBuds
        {
            if self.txtSearchTestBuds.text == ""
            {
                self.SearchTestbudsDict = nil
            }
            else if self.txtSearchTestBuds.text != ""
            {
                if self.SearchTestbudsDict != nil
                {
                    if let name = self.SearchLocationDict?.object(forKey: "name") as? String
                    {
                        if self.txtSearchTestBuds.text != name
                        {
                            self.SearchTestbudsDict = nil
                        }
                    }
                }
            }
            
            if (textField.text?.count)! > 0 {
            self.fetchtestBuds(textField.text!)
            }
            
        }
        else
        {
            
            if self.txtFieldLocation.text == ""
            {
                self.SearchLocationDict = nil
            }
            else if self.txtFieldLocation.text != ""
            {
                if self.SearchLocationDict != nil
                {
                    if let name = self.SearchLocationDict?.object(forKey: "description") as? String
                    {
                        if self.txtFieldLocation.text != name
                        {
                            self.SearchLocationDict = nil
                        }
                    }
                }
            }
            
            if (textField.text?.count)! > 0 {
                self.fetchBusinessFromGoogle(textField.text!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - Button Actions
    
    @IBAction func btnCurrentLocationAct(_ sender: Any) {
        let obj = nearByRestaurantsScreenVC()
        txtFieldLocation.text = ""
        self.SearchLocationDict = nil
       Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj) 
//          UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isCurrentLocationRestro)
    }
    
    @IBAction func btnSearchAct(_ sender: Any) {
       
        if self.SearchLocationDict != nil && self.SearchTestbudsDict != nil
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
            obj.searchLocatioData = self.SearchLocationDict!
            obj.searchTestBuds = self.SearchTestbudsDict!
            self.navigationController?.pushViewController(obj, animated: false)
        }
        else if self.SearchTestbudsDict != nil
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
            obj.searchTestBuds = self.SearchTestbudsDict!
            self.navigationController?.pushViewController(obj, animated: false)
        }
        else if self.SearchLocationDict != nil
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
             self.getPlaceDetail(googlePlaceID: self.SearchLocationDict!.object(forKey: "place_id") as! String)
        }
        
       tblViewAddress.isHidden = true
        txtFieldLocation.resignFirstResponder()

    }
    
    @IBAction func btnClearAllAct(_ sender: Any) {

        NotificationCenter.default.addObserver(self, selector: #selector(setLocation), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
        txtFieldLocation.text = ""
        self.SearchLocationDict = nil
        tblViewAddress.isHidden = true
    }
    
    @IBAction func btnActionSearchTestbudsCancel(_ sender: Any)
    {
        self.txtSearchTestBuds.text = ""
        self.SearchTestbudsDict = nil
        tblViewAddress.isHidden = true
    }
    
    
    @IBAction func btnCancelAct(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            
            self.nslcHieghtOfButton.constant = 10
            self.btnCancelOut.setTitle("", for: .normal)
            self.btnSearchOut.setTitle("", for: .normal)
            self.constSearchTestbudsViewHeight.constant = 0
            self.tblViewAddress.isHidden = true
            self.txtFieldLocation.resignFirstResponder()
            
            self.view.layoutIfNeeded()
            
        }
        
    }
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        if self.SearchLocationDict != nil
        {
            obj.searchLocatioData = self.SearchLocationDict
        }
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "testBudsScreenVC") as! testBudsScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnFriendToggleAct(_ sender: Any) {
        
        let allviewController = self.navigationController?.viewControllers
        
        if allviewController![0].isKind(of: nearByRestaurantsScreenVC.self)
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByFriendsScreenVC") as! nearByFriendsScreenVC
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
    @IBAction func btnFilterAct(_ sender: Any) {
        self.app.isFilterFriend = false
        addChildViewController(objofFilter!)
        self.view.addSubview(objofFilter!.view)
        
        objofFilter!.didMove(toParentViewController: self)
    }
    @objc func cancel(){
        objofFilter!.willMove(toParentViewController: nil)
        objofFilter!.view.removeFromSuperview()
        objofFilter!.removeFromParentViewController()
        
        
    }
    func retriveDataForRestaurant(latitude : String , longitude : String){
        
//        if self.app.zomatoAPIuserKEy != nil
//        {
//            if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
//            {
//                UserDefaults.standard.set("20000", forKey: Constants.UserDefaults.FilterDistance)
//                UserDefaults.standard.synchronize()
//            }
//
//            if let mytestBudsID = UserDefaults.standard.object(forKey: Constants.UserDefaults.SelectedZomatoTestBudsID),let radius = UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance),self.currebntlyRetriveRestuarant == false
//            {
//
//                let mainLink = "https://developers.zomato.com/api/v2.1/search?start=0&count=30&lat=\(latitude)&lon=\(longitude)&radius=\(radius)&cuisines=\(mytestBudsID)"
//                self.currebntlyRetriveRestuarant = true
//                Webservices_Alamofier.postZomatoWithURL(serverlink: mainLink, param: NSDictionary(), key: self.app.zomatoAPIuserKEy!, successStatusCode: 200) { (success, response) in
//                    self.currebntlyRetriveRestuarant = false
//                    if success == true
//                    {
//                        if let restaurant = response.object(forKey: "restaurants") as? NSArray
//                        {
//
//                            if restaurant.count != 0
//                            {
//                                let openRest = NSMutableArray()
//                                let closeRest = NSMutableArray()
//
//                                for i in 0..<restaurant.count
//                                {
//                                    if let restDict = restaurant.object(at: i) as? NSDictionary
//                                    {
//                                        if let dict = restDict.object(forKey: "restaurant") as? NSDictionary
//                                        {
//                                            if let is_delivering_now = dict.object(forKey: "is_delivering_now") {
//                                                if "\(is_delivering_now)" == "1"{
//                                                    openRest.add(restDict)
//                                                }else{
//                                                    closeRest.add(restDict)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//
//                                openRest.addObjects(from: closeRest as! [Any])
//
//                                self.arrForRestaurantData = openRest as! [[String : AnyObject]]
//                                self.arrForAllRestaurantData = openRest as! [[String : AnyObject]]
//                                self.aMapView.clear()
//                                self.retriveTimeDataForRestaurantByCar(latitude : latitude , longitude : longitude)
//                            }
//                            else
//                            {
//                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                                self.app.window?.rootViewController?.view.makeToast("Current no restuarant available in your area.")
//                            }
//
//                        }
//
//                        let userLoacation = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!)
//                        let camera = GMSCameraPosition.camera(withTarget: userLoacation, zoom: 14)
//                        self.aMapView.camera = camera
//                        self.setmap()
//                        // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//
//                    }
//                    else
//                    {
//                        MBProgressHUD.showAdded(to: self.view, animated: true)
//                        if let msg = response.object(forKey: "message") as? String
//                        {
//                            self.view.makeToast(msg)
//                        }
//                        else
//                        {
//                            self.view.makeToast("Something went to wrong. Please try after sometime.")
//                        }
//
//                        print("error : \(response)")
//                    }
//
//                }
//
//
//
//            }
//            else
//            {
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "interestedScreenVC") as! interestedScreenVC
//
//                Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
//            }
//        }
//        else
//        {
//            self.currebntlyRetriveRestuarant = true
//            self.app.getZomatoKEY { (success) in
//                self.currebntlyRetriveRestuarant = false
//                if success == true
//                {
//                    self.retriveDataForRestaurant(latitude: latitude, longitude: longitude)
//                }
//            }
//        }
        
        
        if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
        {
            UserDefaults.standard.set("20000", forKey: Constants.UserDefaults.FilterDistance)
            UserDefaults.standard.synchronize()
        }
        
        if let mytestBudsID = UserDefaults.standard.object(forKey: Constants.UserDefaults.SelectedZomatoTestBudsID),let dist = UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance)
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            print("test buds :- \(mytestBudsID), Distance :- \(dist)")
            var myUrl = String()
            myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(dist)&type=\("restaurant")&keyword=\(mytestBudsID)&key=\(Constants.GoogleKey.kGoogle_Key)"
            WebService.CallRequestUrl(myUrl) { (success, response) -> () in
                print(response)
                if success == true {
                    let token = response["next_page_token"] as? String
                    let arr = response["results"]! as! NSArray
                    self.arrForRestaurantData = arr as! [[String : AnyObject]]
                    self.arrForAllRestaurantData = arr   as! [[String : AnyObject]]
                    print(token as Any)
                    self.retriveTimeDataForRestaurantByCar(latitude : latitude , longitude : longitude)
                    self.setmap()
                    // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }}
        }
        

    }
    func retriveTimeDataForRestaurantByCar(latitude : String , longitude : String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        arrDuration.removeAllObjects()
        arrPlaces.removeAllObjects()
        for i in arrForRestaurantData{
            arrPlaces.add(i)
        }
        for (index,_) in self.arrPlaces.enumerated() {
            
            if let dict : NSDictionary = self.arrPlaces.object(at: index) as? NSDictionary {
                
                let newData = NSMutableDictionary(dictionary: dict)
                newData.setObject("\(index+1)", forKey: "IndexNumber" as NSCopying)
                self.arrPlaces.replaceObject(at: index, with: newData)
                
                self.arrDuration.add(NSDictionary())
                
                let latOfPlace : String = String(format: "%f", ((((dict.object(forKey: "geometry") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "lat")! as AnyObject).doubleValue)!)

                let longOfPlace : String = String(format: "%f", ((((dict.object(forKey: "geometry") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "lng")! as AnyObject).doubleValue)!)
                
//                let latOfPlace : String = String(format: "%f", ((((dict.object(forKey: "restaurant") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "latitude")! as AnyObject).doubleValue)!)
//
//                let longOfPlace : String = String(format: "%f", ((((dict.object(forKey: "restaurant") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "longitude")! as AnyObject).doubleValue)!)
                
                
                var firstStartLat = ""
                var firstStartLong = ""
                var secondStartLat = ""
                var secondStartLong = ""
                var myURL = ""
                firstStartLat = latitude
                firstStartLong = longitude
                secondStartLat = latOfPlace
                secondStartLong = longOfPlace
                
                myURL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(firstStartLat),\(firstStartLong)&destinations=\(secondStartLat),\(secondStartLong)&mode=driving&language=EN&key=\(Constants.GoogleKey.kGoogle_Key)"
                WebService.CallRequestUrl(myURL) { (success, response) in
                    if success == true {
                        if let tempData : NSDictionary = self.arrDuration.object(at: index) as? NSDictionary {
                            if let rows : NSArray = response.object(forKey: "rows") as? NSArray {
                                if rows.count > 0 {
                                    if let elements : NSArray = (rows.object(at: 0) as AnyObject).object(forKey: "elements") as? NSArray {
                                        if elements.count > 0 {
                                            
                                            if let durationDict : NSDictionary = (elements.object(at: 0) as AnyObject).object(forKey: "duration") as? NSDictionary {
                                                if let differ : String = durationDict.object(forKey: "text") as? String {
                                                    let dict = ["Difference":differ]
                                                    let myData = NSMutableDictionary(dictionary: tempData)
                                                    myData.setObject(dict, forKey: "CarFirst" as NSCopying)
                                                    self.arrDuration.replaceObject(at: index, with: myData)
                                                    self.perform(#selector(self.tempFuncForDelay), with: nil, afterDelay: 2)
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func tempFuncForDelay(){
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        self.collectionViewNearByRestaurants.reloadData()
    }
    
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
    
    func fetchtestBuds(_ searchname : String)
    {
       
        
        let result =  self.arrAllTestBudsPlaces.filter({ (data) -> Bool in
            let stringname = data["name"] as! String
            return stringname.lowercased().contains(searchname.lowercased())
            
        })
        
        
        
        self.arrSearchTestBuds = NSMutableArray.init(array: result as [Any])
        if self.arrSearchTestBuds.count > 0
        {
            self.tblViewAddress.isHidden = false
        }
        self.tblViewAddress.reloadData()
    }
    
    
    func getPlaceDetail(googlePlaceID:String) {
        
        WebService.GetPlaceDetailByPlaceId(googlePlaceID) { (success, response) -> () in
            if success == true {
                if (response.object(forKey: "result") != nil) {
                    let arr = response.object(forKey: "result") as! NSDictionary
                    let dict = arr["geometry"] as? NSDictionary
                    if let loc = dict!["location"] as? NSDictionary{
                        let lat = String(describing:loc["lat"]!)
                        let lng = String(describing:loc["lng"]!)
                        self.retriveDataForRestaurant(latitude: lat , longitude: lng)
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        }}

    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRestaurantData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        cell.viewBack.layer.shadowOpacity = 0.7
        cell.viewBack.layer.shadowOffset = CGSize.zero
        cell.viewBack.layer.shadowRadius = 3.0
        cell.viewBack.layer.shadowColor = UIColor.lightGray.cgColor
        cell.lblRestroName.text = arrForRestaurantData[indexPath.row]["name"] as? String
        if let dict = (arrDuration.object(at: indexPath.row) as AnyObject).object(forKey: "CarFirst") as? NSDictionary{
            if let str = dict["Difference"] as? String{
                cell.lblAwayTiming.text = "\(str) from you"}}
        if let dict = arrForRestaurantData[indexPath.row]["opening_hours"] as? NSDictionary{
            if dict["open_now"] as? Bool == true{
                cell.lblOpenOrClose.text = "Open"
            }else{
                cell.lblOpenOrClose.text = "Close"
            }}else{
            cell.lblOpenOrClose.text = "Open"
        }
        cell.lblDistanceFromRestro.setTitle(arrForRestaurantData[indexPath.row]["vicinity"] as? String, for: .normal)
        
        if let photos = arrForRestaurantData[indexPath.row]["photos"] as? [[String:Any]]{
            let strRefre = photos.first
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
            cell.imgViewRestaurants.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height:  self.collectionViewNearByRestaurants.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "selectedRestaurantDeatilsScreenVC") as! selectedRestaurantDeatilsScreenVC
        if let dict = (arrDuration.object(at: indexPath.row) as AnyObject).object(forKey: "CarFirst") as? NSDictionary{
            if let str = dict["Difference"] as? String{
                obj.strTime = str }}
        obj.arrOfRestaurantData = arrForRestaurantData[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: false)
    }
    func reloadTableWithRestDetailArray(restDetailArray  : NSArray){
        
    }
    
    
    
    
}
extension nearByRestaurantsScreenVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if IsSearchTestBuds == true
        {
            return arrSearchTestBuds.count
        }
        else
        {
            return arrForAddress.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.init(name: "GillSans", size: 16.0)
        cell?.textLabel?.frame = CGRect(x: 20, y: 5, width: tableView.frame.size.width - 40, height: 21)
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.textColor = UIColor.white
        
        if IsSearchTestBuds == true
        {
            if let dict = self.arrSearchTestBuds.object(at: indexPath.row) as? NSDictionary
            {
                cell?.textLabel?.text = dict["name"] as? String
            }
        }
        else
        {
            if arrForAddress.count > indexPath.row {
                cell?.textLabel?.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
            } else {
                cell?.textLabel?.text = ""
            }
        }
       
        cell?.textLabel?.sizeToFit()
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//          UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isCurrentLocationRestro)
       
//        txtFieldLocation.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
        
        if IsSearchTestBuds == true
        {
            if let dict = self.arrSearchTestBuds.object(at: indexPath.row) as? NSDictionary
            {
                self.SearchTestbudsDict = NSDictionary.init(dictionary: dict)
                
                if let name = self.SearchTestbudsDict!.object(forKey: "name") as? String
                {
                    self.txtSearchTestBuds.text = name
                }
            }
        }
        else
        {
            print(arrForAddress)
            if let dict = self.arrForAddress.object(at: indexPath.row) as? NSDictionary
            {
                self.SearchLocationDict = NSDictionary.init(dictionary: dict)
                
                if let description = self.SearchLocationDict?.object(forKey: "description") as? String
                {
                    self.txtFieldLocation.text = description
                }
            }
            
        }
        
        self.tblViewAddress.isHidden = true
        txtFieldLocation.resignFirstResponder()
    }
}
extension nearByRestaurantsScreenVC : GMUClusterManagerDelegate,GMUClusterRendererDelegate{
    
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
            
            self.arrForRestaurantData.removeAll()
            
            for data in poiItem.items
            {
                if let data = data as? POIItem
                {
                    self.arrForRestaurantData.append(self.arrForAllRestaurantData[data.arryIndex])
                }
                
            }
            
            self.collectionViewNearByRestaurants.reloadData()
            
//            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    

    /// cluster manager.
    private func generateClusterItems() {
        for index in 0..<arrForRestaurantData.count {
            print(index)
            print(arrForRestaurantData[index])
            if let dict = arrForRestaurantData[index]["geometry"] as? NSDictionary{
                if let loc = dict["location"] as? NSDictionary{
                    let lat = loc["lat"] as! Double
                    let lng = loc["lng"] as! Double
                    let name = "Item \(index)"
                    let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name, arryIndex: index)
                    clusterManager.add(item)
                }
            }
        }
    }
}


