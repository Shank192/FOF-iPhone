//
//  interestedScreenVC.swift
//  FOF
//


import UIKit
import CoreLocation


class interestedScreenVC: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionViewIntresetedTestBuds: UICollectionView!
    var arrTestBudsData = NSMutableArray()
    var MyArrTestBudsData = NSMutableArray()
    
    @IBOutlet weak var btnSingleOut: UIButton!
    
    @IBOutlet weak var btnGroupOut: UIButton!
    
    @IBOutlet weak var lblSingleOut: UILabel!
    
    @IBOutlet weak var lblGroupOut: UILabel!
    
    var userLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()

    let app = UIApplication.shared.delegate as! AppDelegate
    
    var rightNowGetAllTEstBuds = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        let param = ["action":"mytestbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!] as NSDictionary
//       self.GetMyTestBuds(param)
        
        if let user_id = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
        {
            let param = ["user_id":"\(user_id)"]
            self.GetMyTestBuds(param as NSDictionary)
        }
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    //MARK:- Custome method
    
    
    func checkData()
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                self.showLocationEnableAlert()
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                if userLocation == nil
                {
                    self.locationManager.requestAlwaysAuthorization()
                    
                    // For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                    
                    if CLLocationManager.locationServicesEnabled() {
                        locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        locationManager.startUpdatingLocation()
                    }
                }
                else
                {
                    if self.userLocation != nil
                    {
                        
                        self.GetAllTestBuds(latitude: "\(self.userLocation!.latitude)", longitude: "\(self.userLocation!.longitude)")
                    }
                    else
                    {
                       
                        self.GetAllTestBuds(latitude: "", longitude: "")
                    }
                }
            }
        } else {
            print("Location services are not enabled")
            
            if userLocation == nil
            {
                self.locationManager.requestAlwaysAuthorization()
                
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()
                
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
            }
            else
            {
                if self.userLocation != nil
                {
                    
                    self.GetAllTestBuds(latitude: "\(self.userLocation!.latitude)", longitude: "\(self.userLocation!.longitude)")
                }
                else
                {
                    
                    self.GetAllTestBuds(latitude: "", longitude: "")
                    
                }
            }
            
            
        }
    }
    
    func showLocationEnableAlert()
    {
        
            
            let alert = UIAlertController(title: "FOF needs your location", message: "Please enable your location to get option of your ionterested in", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            let setting = UIAlertAction.init(title: "Go to setting", style: .default) { (act) in
                
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    
                    if #available(iOS 10.0, *)
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else
                    {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
            alert.addAction(setting)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        
        
    }
    
    
    //MARK:- Webservice
    func GetMyTestBuds(_ param:NSDictionary) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetUserProfile, param: param, key: "", successStatusCode: 200) { (success, response) in
            
            if success == true
            {
                if let dataDict = response.object(forKey: "response_data") as? NSDictionary
                {
                 
                    
                    self.app.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
                    
                    UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
                    
                    if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
                    {
                        self.MyArrTestBudsData = NSMutableArray(array: tastebuds)
                        UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
                        UserDefaults.standard.synchronize()
                        self.arrTestBudsData = NSMutableArray(array: self.MyArrTestBudsData)
                        
                        for J in 0..<self.arrTestBudsData.count
                        {
                            if let BudsDict = self.arrTestBudsData.object(at: J) as? NSDictionary
                            {
                                let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
                                MuteBudsDict.setValue("1", forKey: "isSelected")
                                self.arrTestBudsData.replaceObject(at: J, with: MuteBudsDict)
                                
                            }
                        }
                    }
                }
                
                UserDefaults.standard.synchronize()
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
            
            self.checkData()
        }
        
//        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: param) { (success, response) in
//
//            if success == true
//            {
//                if let dataArray = response.object(forKey: "data") as? NSArray
//                {
//                    self.MyArrTestBudsData = NSMutableArray(array: dataArray)
//                    UserDefaults.standard.set(dataArray, forKey: Constants.UserDefaults.MyTestBuds)
//                    UserDefaults.standard.synchronize()
//                    self.arrTestBudsData = NSMutableArray(array: self.MyArrTestBudsData)
//                    for J in 0..<self.arrTestBudsData.count
//                    {
//                        if let BudsDict = self.arrTestBudsData.object(at: J) as? NSDictionary
//                        {
//                            let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
//                            MuteBudsDict.setValue("1", forKey: "isSelected")
//                            self.arrTestBudsData.replaceObject(at: J, with: MuteBudsDict)
//
//                        }
//                    }
//                }
//            }
//            else
//            {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if let settings = response.object(forKey: "settings") as? NSDictionary
//                {
//                    if let  errormessage = settings.object(forKey:"errormessage") as? String
//                    {
//                        if errormessage ==  "invalid session"
//                        {
//                            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
//                            UserDefaults.standard.synchronize()
//
//                            self.app.SetMyRootBy()
//                        }
//                    }
//                }
//            }
//
//
//
//
//
//        }
    }
    
    
    func GetAllTestBuds(latitude : String, longitude : String) {

        MBProgressHUD.showAdded(to: self.view, animated: true)
        if self.rightNowGetAllTEstBuds == false
        {
           self.rightNowGetAllTEstBuds = true
            
            Webservices_Alamofier.GetPlaceDetailByLatAndLong(latitude, longitude: longitude) { (success, response) in
                
                if success == true
                {
                    print(response)
                    
                    var city = ""
                    
                    if let resultsArray = response.object(forKey: "results") as? NSArray
                    {
                        
                        
                        for (_,data) in resultsArray.enumerated()
                        {
                            let dict = data as! NSDictionary
                            
                            if let address_components = dict.object(forKey: "address_components") as? NSArray
                            {
                                for (_,data1) in address_components.enumerated()
                                {
                                    let dict1 = data1 as! NSDictionary
                                    
                                    if let types = dict1.object(forKey: "types") as? NSArray
                                    {
                                        for (_,str) in types.enumerated()
                                        {
                                            let strName = str as! String
                                            
                                            if strName == "locality"
                                            {
                                                if let long_name = dict1.object(forKey: "long_name") as? String
                                                {
                                                    city = long_name
                                                    break
                                                }
                                            }
                                        }
                                        
                                        if city != ""
                                        {
                                            break
                                        }
                                    }
                                }
                                
                                if city != ""
                                {
                                    break
                                }
                                
                            }
                        }
                    }
                    
                    if city != ""
                    {
                        if let user_id = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),self.userLocation != nil
                        {
                            let param = ["user_id":"\(user_id)","latitude":latitude,"longitude":longitude,"city":city]
                            
                            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetTestBuds, param: param as NSDictionary, key: "", successStatusCode: 200, CompletionHandler: { (success, response1) in
                                
                                UserDefaults.standard.set(city, forKey: Constants.UserDefaults.CurrentCity)
                                UserDefaults.standard.synchronize()
                                
                                if success == true
                                {
                                    if let dict = response1.object(forKey: "response_data") as? NSDictionary
                                    {
                                        if let dataArray = dict.object(forKey: "testbuds") as? NSArray
                                        {
                                            UserDefaults.standard.set(dataArray, forKey: Constants.UserDefaults.AllTestBudsArrayFromYourLocation)
                                            
                                            self.arrTestBudsData = NSMutableArray(array: dataArray)
                                            
                                            for J in 0..<self.arrTestBudsData.count
                                            {
                                                if let BudsDict = self.arrTestBudsData.object(at: J) as? NSDictionary
                                                {
                                                    let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
                                                    MuteBudsDict.setValue("0", forKey: "isSelected")
                                                    self.arrTestBudsData.replaceObject(at: J, with: MuteBudsDict)
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if let msg = response1.object(forKey: "message") as? String
                                    {
                                        self.view.makeToast(msg)
                                    }
                                    else
                                    {
                                        self.view.makeToast("Something went to wrong. Please try after sometime")
                                    }
                                }
                                
                                self.rightNowGetAllTEstBuds = false
                                self.setTestBuds()
                            })
                            
                        }
                    }
                    else
                    {
                        self.rightNowGetAllTEstBuds = false
                    }
                    
                }
                else
                {
                    self.rightNowGetAllTEstBuds = false
                    if let msg = response.object(forKey: "message") as? String
                    {
                        if let msg = response.object(forKey: "message") as? String
                        {
                            self.view.makeToast(msg)
                        }
                        else
                        {
                            self.view.makeToast("Something went to wrong. Please try after sometime")
                        }
                    }
                }
                
            }
            
        }



    }
    
    
//    func GetAllTestBuds(_ param:NSDictionary) {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: param) { (success, response) in
//
//            if success == true
//            {
//                if let dataArray = response.object(forKey: "data") as? NSArray
//                {
//                    self.arrTestBudsData = NSMutableArray(array: dataArray)
//
//                    for J in 0..<self.arrTestBudsData.count
//                    {
//                        if let BudsDict = self.arrTestBudsData.object(at: J) as? NSDictionary
//                        {
//                            let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
//                            MuteBudsDict.setValue("0", forKey: "isSelected")
//                            self.arrTestBudsData.replaceObject(at: J, with: MuteBudsDict)
//
//                        }
//                    }
//
//                }
//
//            }
//            else
//            {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if let settings = response.object(forKey: "settings") as? NSDictionary
//                {
//                    if let  errormessage = settings.object(forKey:"errormessage") as? String
//                    {
//                        if errormessage ==  "invalid session"
//                        {
//                            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
//                            UserDefaults.standard.synchronize()
//
//                            self.app.SetMyRootBy()
//                        }
//                    }
//                }
//            }
//
//            self.setTestBuds()
//        }
//    }
    
    
    //MARK:- Custome method
    func setTestBuds()
    {
        print(MyArrTestBudsData)
        print(arrTestBudsData)
        
        if self.MyArrTestBudsData.count != 0
        {
            for i in 0..<self.MyArrTestBudsData.count
            {
                if let myBudsDict = self.MyArrTestBudsData.object(at: i) as? NSDictionary
                {
                    if let myBudsID = myBudsDict.object(forKey: "tastebud_id")
                    {
                        if self.arrTestBudsData.count != 0
                        {
                            for J in 0..<self.arrTestBudsData.count
                            {
                                if let BudsDict = self.arrTestBudsData.object(at: J) as? NSDictionary
                                {
                                    if let BudsID = BudsDict.object(forKey: "id")
                                    {
                                        if "\(myBudsID)" == "\(BudsID)"
                                        {
                                            let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
                                            MuteBudsDict.setValue("1", forKey: "isSelected")
                                            self.arrTestBudsData.replaceObject(at: J, with: MuteBudsDict)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            self.arrTestBudsData.add(myBudsDict)
                        }
                        
                    }
                }
            }
            

        }
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        self.collectionViewIntresetedTestBuds.reloadData()
    }
    
    
    func setMyBuds(isSingleGO : Bool)
    {
        if let userid = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
        {
            var selectedBudsID = ""
            var ZomatoID = ""
            let selectedBudsArray = NSMutableArray()
            for i in 0..<self.arrTestBudsData.count
            {
                if let dict = self.arrTestBudsData.object(at: i) as? NSDictionary
                {
                    if let isSelected = dict.object(forKey: "isSelected")
                    {
                        if "\(isSelected)" == "1"
                        {
                            selectedBudsArray.add(dict)
                            if let ID = dict.object(forKey: "id") as? String
                            {
                                if selectedBudsID != ""
                                {
                                    selectedBudsID = "\(selectedBudsID),\(ID)"
                                }
                                else
                                {
                                    selectedBudsID = "\(ID)"
                                }
                                
                            }
                            
                            if let zomato_id = dict.object(forKey: "name")//zomato_id
                            {
                                if ZomatoID != ""
                                {
                                    ZomatoID = "\(ZomatoID),\(zomato_id)"
                                }
                                else
                                {
                                    ZomatoID = "\(zomato_id)"
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
            
            
            UserDefaults.standard.set(selectedBudsArray, forKey: Constants.UserDefaults.MyTestBuds)
            UserDefaults.standard.synchronize()
//            var strGender = String()
//            if let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.gender) as? String{
//                strGender = str
//            }else{
//                strGender = "all"
//            }
            let param = ["user_id":"\(userid)","tastebud_ids":selectedBudsID]
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            Webservices_Alamofier.postWithURL(serverlink:Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.SaveUserTestbuds, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                
               
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                if success == true
                {
                    if let dataDict = response.object(forKey: "response_data") as? NSDictionary
                    {
                        if let search_distance = dataDict.object(forKey: "search_distance")
                        {
                            if "\(search_distance)" != "" && "\(search_distance)" != "0"
                            {
                                UserDefaults.standard.set("\(search_distance)", forKey: Constants.UserDefaults.FilterDistance)
                            }
                        }
                        
                        if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
                        {
                            UserDefaults.standard.set("20000", forKey: Constants.UserDefaults.FilterDistance)
                            UserDefaults.standard.synchronize()
                        }
                        
                        Constants.GlobalConstants.appDelegate.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
                        UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
                        
                        if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
                        {
                            UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
                            UserDefaults.standard.synchronize()
                        }
                    }
                    
                    UserDefaults.standard.set(selectedBudsID, forKey: Constants.UserDefaults.MySelectedTEstBudsID)
                    
                    UserDefaults.standard.set(ZomatoID, forKey: Constants.UserDefaults.SelectedZomatoTestBudsID)
                    
                    UserDefaults.standard.synchronize()
                    
                    
                    if isSingleGO == true
                    {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
                        self.app.IsGoSingle = true
                        nextVC.selectedIndex = 1
                        Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
                    }
                    else
                    {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
                        self.app.IsGoSingle = false
                        nextVC.selectedIndex = 1
                        Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
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
                        self.view.makeToast("Something went to wrong. Please try after sometime.")
                    }
                }
                
            }
        }

        
        
//        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
//            
//            if success == true
//            {
//                if let dataArray = response.object(forKey: "data") as? NSArray
//                {
//                    if dataArray.count != 0
//                    {
//                        if let dict = dataArray.object(at: 0) as? NSDictionary
//                        {
//                             self.app.userDetail = UserDetail.modelObject(with: dict as! [AnyHashable : Any])
//                            let placesData = NSKeyedArchiver.archivedData(withRootObject: dataArray)
//
//                            UserDefaults.standard.set(placesData, forKey: Constants.UserDefaults.ProfileData)
//                            UserDefaults.standard.set(dict.object(forKey: "testbuds"), forKey: Constants.UserDefaults.MyTestBuds)
//                            if let sessionid = dict.object(forKey: "sessionid")
//                            {
//                                UserDefaults.standard.set("\(sessionid)", forKey: Constants.UserDefaults.session_ID)
//                            }
//                        }
//                    }
//                    
//                }
//                
//                if isSingleGO == true
//                {
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
//                    self.app.IsGoSingle = true
//                    nextVC.selectedIndex = 1
//                    Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
//                }
//                else
//                {
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
//                    self.app.IsGoSingle = false
//                    nextVC.selectedIndex = 1
//                    Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
//                }
//            }
//            else
//            {
//                if let settings = response.object(forKey: "settings") as? NSDictionary
//                {
//                    if let  errormessage = settings.object(forKey:"errormessage") as? String
//                    {
//                        if errormessage ==  "invalid session"
//                        {
//                            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
//                            UserDefaults.standard.synchronize()
//                            
//                            self.app.SetMyRootBy()
//                        }
//                    }
//                }
//            }
//            
//        }
        
    }
    
    
    
 // MARK: - Button action method
    
    @IBAction func btnSingleAct(_ sender: Any)
    {
        
    self.setMyBuds(isSingleGO: true)
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
//        self.app.IsGoSingle = true
//        nextVC.selectedIndex = 1
//        Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
    }
    
    @IBAction func btnGroupAct(_ sender: Any) {
        
        self.setMyBuds(isSingleGO: false)
    }
    
    @IBAction func btnGrabABiteAct(_ sender: Any) {
        
        
    }
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTestBudsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        if let dict = self.arrTestBudsData.object(at: indexPath.row) as? NSDictionary
        {
            if let name = dict.object(forKey: "name") as? String
            {
                cell.lblTestbudsName.text = name
            }
            
            if let isSelected = dict.object(forKey: "isSelected")
            {
                if "\(isSelected)" == "1" {
                    cell.backgroundColor = UIColor.clear
                    cell.lblTestbudsName.textColor = UIColor.white
                }else {
                    cell.backgroundColor = UIColor.white
                    cell.lblTestbudsName.textColor = Utility.UIColorFromHex(0xa32e43)
                }
            }
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if let dict = arrTestBudsData[indexPath.row] as? NSDictionary
        {
            
            if let name = dict.object(forKey: "name") as? String
            {
                let size = name.size(withAttributes: nil)
                let number:Double = Double(size.width)
                return CGSize(width: number.rounded() + 30, height: 32)
            }
        }
       
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let dict = self.arrTestBudsData.object(at: indexPath.row) as? NSDictionary
        {
            print(dict)
            if let isSelected = dict.object(forKey: "isSelected")
            {
                if "\(isSelected)" == "1"
                {
                    let muteDict = NSMutableDictionary(dictionary: dict)
                    muteDict.setValue("0", forKey: "isSelected")
                    self.arrTestBudsData.replaceObject(at: indexPath.row, with: muteDict)
                    
                }
                else
                {
                    let muteDict = NSMutableDictionary(dictionary: dict)
                    muteDict.setValue("1", forKey: "isSelected")
                    self.arrTestBudsData.replaceObject(at: indexPath.row, with: muteDict)
                    
                }
            }
            
        }
        
        self.collectionViewIntresetedTestBuds.reloadItems(at: [indexPath])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//MARK:- Location Delegate
extension interestedScreenVC : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
         self.userLocation = locValue
        
        if self.userLocation != nil
        {
            app.userLocation = self.userLocation!
            
            self.GetAllTestBuds(latitude: "\(self.userLocation!.latitude)", longitude: "\(self.userLocation!.longitude)")
            
        }
       
        manager.stopUpdatingLocation()
        
    }
    
}
