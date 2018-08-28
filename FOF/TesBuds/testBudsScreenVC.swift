//
//  testBudsScreenVC.swift
//  FOF
//

//

import UIKit
import CoreLocation
import MBProgressHUD

class testBudsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var testBudsCollectionView: UICollectionView!
    var arrTestBudsData = NSMutableArray()
    var MyArrTestBudsData = NSMutableArray()
    var userLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    
    
    var sizingCell = testBudsCollectionViewCell()
    var size = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let param = ["action":"mytestbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!] as NSDictionary
        self.GetMyTestBuds(param)
        
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
                        let param = ["action":"testbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!,"latlng":"\(self.userLocation!.latitude),\(self.userLocation!.longitude)"] as NSDictionary
                        self.GetAllTestBuds(param)
                    }
                    else
                    {
                        let param = ["action":"testbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!,"latlng":"\(0),\(0)"] as NSDictionary
                        self.GetAllTestBuds(param)
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
                    let param = ["action":"testbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!,"latlng":"\(self.userLocation!.latitude),\(self.userLocation!.longitude)"] as NSDictionary
                    self.GetAllTestBuds(param)
                }
                else
                {
                    let param = ["action":"testbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!,"latlng":"\(0),\(0)"] as NSDictionary
                    self.GetAllTestBuds(param)
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
        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: param) { (success, response) in
            
            if success == true
            {
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    self.MyArrTestBudsData = NSMutableArray(array: dataArray)
                    UserDefaults.standard.set(dataArray, forKey: Constants.UserDefaults.MyTestBuds)
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
            else
            {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if let settings = response.object(forKey: "settings") as? NSDictionary
                {
                    if let  errormessage = settings.object(forKey:"errormessage") as? String
                    {
                        if errormessage ==  "invalid session"
                        {
                            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
                            UserDefaults.standard.synchronize()
                            
                            self.app.SetMyRootBy()
                        }
                    }
                }
            }
            
            self.checkData()
            
            
            
        }
    }
    
    func GetAllTestBuds(_ param:NSDictionary) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: param) { (success, response) in
            
            if success == true
            {
                if let dataArray = response.object(forKey: "data") as? NSArray
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
            else
            {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if let settings = response.object(forKey: "settings") as? NSDictionary
                {
                    if let  errormessage = settings.object(forKey:"errormessage") as? String
                    {
                        if errormessage ==  "invalid session"
                        {
                            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
                            UserDefaults.standard.synchronize()
                            
                            self.app.SetMyRootBy()
                        }
                    }
                }
            }
            
            self.setTestBuds()
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
                    if let myBudsID = myBudsDict.object(forKey: "id")
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
        var selectedBuds = ""
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
                        if let name = dict.object(forKey: "name") as? String
                        {
                            if selectedBuds != ""
                            {
                                selectedBuds = "\(selectedBuds),\(name)"
                            }
                            else
                            {
                                selectedBuds = "\(name)"
                            }
                            
                        }
                    }
                }
            }
        }
        
        UserDefaults.standard.set(selectedBudsArray, forKey: Constants.UserDefaults.MyTestBuds)
        UserDefaults.standard.synchronize()
        var strGender = String()
        if let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.gender) as? String{
            strGender = str
        }else{
            strGender = "all"
        }
        let dictEditProfilePara = ["action":"editprofile","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID),"testbuds":selectedBuds,"showme":strGender,"distance_unit":"miles","search_min_age":18,"search_max_age":40,"search_distance":40,"isreviewed":(0),"fields":"testbuds,showme,search_min_age,distance_unit,search_max_age,search_distance,isreviewed"]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if success == true
            {
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    if dataArray.count != 0
                    {
                        if let dict = dataArray.object(at: 0) as? NSDictionary
                        {
                            self.app.userDetail = UserDetail.modelObject(with: dict as! [AnyHashable : Any])
                            
                            if let sessionid = dict.object(forKey: "sessionid")
                            {
                                UserDefaults.standard.set("\(sessionid)", forKey: Constants.UserDefaults.session_ID)
                            }
                        }
                    }
                    
                }
                
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                if let settings = response.object(forKey: "settings") as? NSDictionary
                {
                    if let  errormessage = settings.object(forKey:"errormessage") as? String
                    {
                        if errormessage ==  "invalid session"
                        {
                            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
                            UserDefaults.standard.synchronize()
                            
                            self.app.SetMyRootBy()
                        }
                    }
                }
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
                    cell.backgroundColor = Utility.UIColorFromHex(0xa32e43)
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
            let param = ["action":"testbuds","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID)!,"latlng":"\(self.userLocation!.latitude),\(self.userLocation!.longitude)"] as NSDictionary
            self.GetAllTestBuds(param)
            
        }
        
        manager.stopUpdatingLocation()
        
    }
    
}
