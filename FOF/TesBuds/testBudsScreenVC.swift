//
//  testBudsScreenVC.swift
//  FOF
//

//

import UIKit
import CoreLocation


class testBudsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var testBudsCollectionView: UICollectionView!
    @IBOutlet weak var btnSaveTestbuds: UIButton!
    
    var arrTestBudsData = NSMutableArray()
    var MyArrTestBudsData = NSMutableArray()
    var userLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    
    var rightNowGetAllTEstBuds = false
    var sizingCell = testBudsCollectionViewCell()
    var size = CGFloat()
    
    var isSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user_id = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
        {
            let param = ["user_id":"\(user_id)"]
            self.GetMyTestBuds(param as NSDictionary)
        }
        
        if isSave == true
        {
            self.btnSaveTestbuds.setTitle("Save Testbuds", for: .normal)
        }
        else
        {
            self.btnSaveTestbuds.setTitle("GRAB A BITE", for: .normal)
        }
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
                        if let city = UserDefaults.standard.object(forKey: Constants.UserDefaults.CurrentCity)
                        {
                            let param = ["user_id":"\(UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!)","latitude":self.userLocation!.latitude,"longitude":self.userLocation!.longitude,"city":"\(city)"] as [String : Any]
                            self.GetAllTestBuds(param as NSDictionary)
                        }
                        else
                        {
                            self.getCurrentCity(lat: "\(self.userLocation!.latitude)", laongi: "\(self.userLocation!.longitude)")
                        }
                    }
                    else
                    {
                        self.checkData()
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
                    if let city = UserDefaults.standard.object(forKey: Constants.UserDefaults.CurrentCity)
                    {
                        let param = ["user_id":"\(UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!)","latitude":self.userLocation!.latitude,"longitude":self.userLocation!.longitude,"city":"\(city)"] as [String : Any]
                        self.GetAllTestBuds(param as NSDictionary)
                    }
                    else
                    {
                        self.getCurrentCity(lat: "\(self.userLocation!.latitude)", laongi: "\(self.userLocation!.longitude)")
                    }
                }
                else
                {
                    self.checkData()
                }
            }
            
            
        }
    }
    
    func getCurrentCity(lat : String, laongi : String)
    {
        Webservices_Alamofier.GetPlaceDetailByLatAndLong(lat, longitude: laongi) { (success, response) in
            
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
                    
                    UserDefaults.standard.set(city, forKey: Constants.UserDefaults.CurrentCity)
                    UserDefaults.standard.synchronize()
                    
                    self.checkData()
                    
                }
                else
                {
                    print("City not get in google api")
                }
            }
            else
            {
                self.getCurrentCity(lat : lat, laongi : laongi)
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
                    UserDefaults.standard.set("\(dataDict)", forKey: Constants.UserDefaults.ProfileData)
                    
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
                }
                else
                {
                }
            }
            
            self.checkData()
        }
    }
    
    func GetAllTestBuds(_ param:NSDictionary) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if rightNowGetAllTEstBuds == false
        {
            self.rightNowGetAllTEstBuds = true
            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetTestBuds, param: param as NSDictionary, key: "", successStatusCode: 200, CompletionHandler: { (success, response) in
                
                if success == true
                {
                    if let dict = response.object(forKey: "response_data") as? NSDictionary
                    {
                        if let dataArray = dict.object(forKey: "testbuds") as? NSArray
                        {
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
                    if let msg = response.object(forKey: "message") as? String
                    {
                        
                    }
                    else
                    {
                        
                    }
                }
                
                self.rightNowGetAllTEstBuds = false
                self.setTestBuds()
            })
        }
        
    }
    
    
    //MARK:- Custome method
    func setTestBuds()
    {
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
        self.testBudsCollectionView.reloadData()
    }
    func setMyBuds()
    {
        if let userid = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
        {
            
            var selectedBudsID = ""
            var ZomatoID = ""
            var selectedBudsArray = NSMutableArray()
            for i in 0..<self.arrTestBudsData.count
            {
                if let dict = self.arrTestBudsData.object(at: i) as? NSDictionary
                {
                    if let isSelected = dict.object(forKey: "isSelected")
                    {
                        if "\(isSelected)" == "1"
                        {
                            selectedBudsArray.add(dict)
                            if let ID = dict.object(forKey: "id")
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
            
            if selectedBudsID != ""
            {
                UserDefaults.standard.set(selectedBudsArray, forKey: Constants.UserDefaults.MyTestBuds)
                UserDefaults.standard.synchronize()
                
                let param = ["user_id":"\(userid)","tastebud_ids":selectedBudsID]
                
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Webservices_Alamofier.postWithURL(serverlink:Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.SaveUserTestbuds, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                    
                    
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    if success == true
                    {
                        UserDefaults.standard.set(selectedBudsID, forKey: Constants.UserDefaults.MySelectedTEstBudsID)
                        
                        UserDefaults.standard.set(ZomatoID, forKey: Constants.UserDefaults.SelectedZomatoTestBudsID)
                        UserDefaults.standard.synchronize()
                        
                        if let dataArray = response.object(forKey: "data") as? NSArray
                        {
                            if dataArray.count != 0
                            {
                                if let dict = dataArray.object(at: 0) as? NSDictionary
                                {
                                    self.app.userDetail = UserDetail.modelObject(with: (dict as! [AnyHashable : Any]))
                                    
                                    
                                }
                            }
                            
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
                        self.dismiss(animated: true, completion: nil)
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
            else
            {
                self.view.makeToast("Please select at least one tastebuds.")
            }
        }
    }
    @IBAction func btnBackAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnGrabABiteAct(_ sender: Any) {
        setMyBuds()
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
                cell.lblInterestedTestBudsName.text = name
            }
            
            if let isSelected = dict.object(forKey: "isSelected")
            {
                if "\(isSelected)" == "1"
                {
                    cell.backgroundColor = UIColor.clear
                    cell.lblInterestedTestBudsName.textColor = UIColor.white
                    
                }
                else
                {
                    cell.backgroundColor =  UIColor.white
                    cell.lblInterestedTestBudsName.textColor = Utility.UIColorFromHex(0xa32e43)
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
        
        self.testBudsCollectionView.reloadItems(at: [indexPath])
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//MARK:- Location Delegate
extension testBudsScreenVC : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLocation = locValue
        
        if self.userLocation != nil
        {
            app.userLocation = self.userLocation!
            if let city = UserDefaults.standard.object(forKey: Constants.UserDefaults.CurrentCity)
            {
                let param = ["user_id":"\(UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!)","latitude":self.userLocation!.latitude,"longitude":self.userLocation!.longitude,"city":"\(city)"] as [String : Any]
                self.GetAllTestBuds(param as NSDictionary)
            }
            else
            {
                self.getCurrentCity(lat: "\(self.userLocation!.latitude)", laongi: "\(self.userLocation!.longitude)")
            }
            
        }
        
        manager.stopUpdatingLocation()
        
    }
    
}
