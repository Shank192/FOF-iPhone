//
//  nearByRestaurantsScreenVC.swift
//  FOF
//


import UIKit
import GoogleMaps
import GooglePlaces
import MBProgressHUD

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}

class nearByRestaurantsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSMapViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tblViewAddress: UITableView!
    @IBOutlet weak var collectionViewNearByRestaurants: UICollectionView!
    @IBOutlet weak var txtFieldLocation: UITextField!
    @IBOutlet weak var btnSearchOut: UIButton!
    @IBOutlet weak var nslcHieghtOfButton: NSLayoutConstraint!
    @IBOutlet weak var btnCancelOut: UIButton!
    @IBOutlet weak var aMapView: GMSMapView!

    var objofFilter : filterScreenVC?
    var arrForAddress = NSMutableArray()
    var latitude = String()
    var longitude = String()
    var arrForRestaurantData = [[String:AnyObject]]()
    var clusterManager: GMUClusterManager!
    var arrPlaces = NSMutableArray()
    var arrDuration = NSMutableArray()
    //var isCurrentLocation = true
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
        txtFieldLocation.addTarget(self, action: #selector(myTargetFunction(textField:)), for: UIControlEvents.allTouchEvents)
        txtFieldLocation.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        hideKeyboardWhenTappedAround()
        //if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isCurrentLocationRestro){
            let obj = nearByRestaurantsScreenVC()
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
   NotificationCenter.default.addObserver(self, selector: #selector(setLocation), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
      //  }
        
       
      
        self.objofFilter = (self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC)

    }
    @objc func setLocation(){
        latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
        longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
            retriveDataForRestaurant(latitude: latitude, longitude: longitude)
    }
    override func viewWillAppear(_ animated: Bool) {
        nslcHieghtOfButton.constant = 10
        btnCancelOut.setTitle("", for: .normal)
        btnSearchOut.setTitle("", for: .normal)
        txtFieldLocation.text = ""
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
        let userLoacation = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!)
        let camera = GMSCameraPosition.camera(withTarget: userLoacation, zoom: 14)
        aMapView.camera = camera
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
    @objc func myTargetFunction(textField: UITextField) {
        UIView.animate(withDuration: 0.20) {
            let transition = CATransition()
            transition.duration = 0.20
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            self.nslcHieghtOfButton.constant = 30
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
        let obj = nearByRestaurantsScreenVC()
        txtFieldLocation.text = ""
       Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj) 
          UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isCurrentLocationRestro)
    }
    
    @IBAction func btnSearchAct(_ sender: Any) {
       
       tblViewAddress.isHidden = true
        txtFieldLocation.resignFirstResponder()

    }
    
    @IBAction func btnClearAllAct(_ sender: Any) {

        NotificationCenter.default.addObserver(self, selector: #selector(setLocation), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
        txtFieldLocation.text = ""
        tblViewAddress.isHidden = true
    }
    @IBAction func btnCancelAct(_ sender: Any) {
        nslcHieghtOfButton.constant = 10
        btnCancelOut.setTitle("", for: .normal)
        btnSearchOut.setTitle("", for: .normal)
       tblViewAddress.isHidden = true
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
        
            MBProgressHUD.showAdded(to: self.view, animated: true)

            var myUrl = String()
            myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&key=\(Constants.GoogleKey.kGoogle_Key)"
            WebService.CallRequestUrl(myUrl) { (success, response) -> () in
                print(response)
                if success == true {
                    let token = response["next_page_token"] as? String
                    let arr = response["results"]! as! NSArray
                    self.arrForRestaurantData = arr as! [[String : AnyObject]]
                    print(token as Any)
                    self.retriveTimeDataForRestaurantByCar(latitude : latitude , longitude : longitude)
                    self.setmap()
                   // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }}
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

                                                }}}}}}}}}}}}
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
            if dict["open_now"] as! Bool == true{
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
          UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isCurrentLocationRestro)
        getPlaceDetail(googlePlaceID:(arrForAddress.object(at: indexPath.row)as AnyObject).object(forKey: "place_id") as! String)
        txtFieldLocation.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
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
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
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
                    let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
                    clusterManager.add(item)
                }
            }
            
        }
    }
}


