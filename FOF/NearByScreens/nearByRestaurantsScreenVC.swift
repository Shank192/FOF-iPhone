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

class nearByRestaurantsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSMapViewDelegate {
    
    @IBOutlet weak var collectionViewNearByRestaurants: UICollectionView!
    
    
    @IBOutlet weak var aMapView: GMSMapView!
    var latitude = String()
    var longitude = String()
    var arrForRestaurantData = [[String:AnyObject]]()
    var clusterManager: GMUClusterManager!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let obj = nearByRestaurantsScreenVC()
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
        NotificationCenter.default.addObserver(self, selector: #selector(retriveDataForRestaurant), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(Constants.UserDefaults.currentLongitude + Constants.UserDefaults.currentLatitude)
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
    }
    
    
    // MARK: - Button Actions
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        
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
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    @objc func retriveDataForRestaurant(){
        
        if latitude == UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String{
            
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
            longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
            
            var myUrl = String()
            myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&key=\(Constants.GoogleKey.kGoogle_Key)"
            WebService.CallRequestUrl(myUrl) { (success, response) -> () in
                print(response)
                if success == true {
                    let token = response["next_page_token"] as? String
                    let arr = response["results"]! as! NSArray
                    self.arrForRestaurantData = arr as! [[String : AnyObject]]
                    print(token as Any)
                    self.collectionViewNearByRestaurants.reloadData()
                    self.setmap()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }}}
    }
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
        cell.lblAwayTiming.text = "5 Min from you"
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
        obj.arrOfRestaurantData = arrForRestaurantData[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: false)
    }
    func reloadTableWithRestDetailArray(restDetailArray  : NSArray){
        
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


