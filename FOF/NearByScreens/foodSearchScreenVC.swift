//
//  foodSearchScreenVC.swift
//  FOF
//


import UIKit

class foodSearchScreenVC: UIViewController , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var constSearchLocationTextfieldViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewFoodSearch: UICollectionView!
    
    @IBOutlet weak var tblViewAddress: UITableView!
    @IBOutlet weak var viewFood: UIView!
    @IBOutlet weak var txtFieldFoodSearch: UITextField!
    @IBOutlet weak var txtFeildAddressSearch: UITextField!
    var arrData = NSMutableArray()
    var arrForRestaurants = [[String:AnyObject]]()
    var arrPlaces = NSMutableArray()
    var arrDuration = NSMutableArray()
    var arrTime = NSMutableArray()
    var arrForAddress = NSMutableArray()
    var arrSearchTestBuds = NSMutableArray()
    var arrAllTestBudsPlaces = [[String : AnyObject]]()
    var latitude : String?
    var longitude : String?
    
    var isService = false
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    
    var searchTestBuds : NSDictionary?
    var searchLocatioData : NSDictionary?
    var isSearchTestBuds = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let TestArray = UserDefaults.standard.object(forKey: Constants.UserDefaults.AllTestBudsArrayFromYourLocation) as? NSArray
        {
            self.arrAllTestBudsPlaces = TestArray as! [[String : AnyObject]]
        }
        
        if self.searchTestBuds != nil
        {
            if let name = self.searchTestBuds?.object(forKey: "name") as? String
            {
                self.txtFieldFoodSearch.text = name
            }
        }
        
        if self.searchLocatioData != nil
        {
            if let description = self.searchLocatioData?.object(forKey: "description") as? String
            {
                self.txtFeildAddressSearch.text = description
            }
        }
        
        setCurrentDeatils()
        self.hideKeyboardWhenTappedAround()
        self.constSearchLocationTextfieldViewHeight.constant = 0
        tblViewAddress.layoutMargins = UIEdgeInsets.zero
        tblViewAddress.tableFooterView = UIView(frame: CGRect.zero)
        tblViewAddress.separatorInset = UIEdgeInsets.zero
        txtFeildAddressSearch.delegate = self
        txtFieldFoodSearch.delegate = self
        
        txtFieldFoodSearch.addTarget(self, action: #selector(textFieldTouchTestbuds(textField:)), for: UIControlEvents.allTouchEvents)
        
        txtFeildAddressSearch.addTarget(self, action: #selector(textFieldTouchLocation(textField:)), for: UIControlEvents.allTouchEvents)
        
        txtFeildAddressSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        txtFieldFoodSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Button Action
    @IBAction func btnActionSearch(_ sender: Any)
    {
        if self.searchLocatioData != nil && self.searchTestBuds != nil
        {
            self.getPlaceDetail(googlePlaceID: self.searchLocatioData!.object(forKey: "place_id") as! String)
        }
        else if self.searchLocatioData != nil
        {
            self.getPlaceDetail(googlePlaceID: self.searchLocatioData!.object(forKey: "place_id") as! String)
        }
        else if self.searchTestBuds != nil
        {
            if self.latitude != nil && self.longitude != nil
            {
                self.setZomatoRest(latitude: "\(self.latitude!)", longitude: "\(self.longitude!)", StrtCounty: 0, EndCount: 50)
            }
            else
            {
                self.retriveDataForRestaurants()
            }
            
        }
    }
    
    
    @IBAction func btnCancelAct(_ sender: Any) {
        if self.constSearchLocationTextfieldViewHeight.constant == 0{
            self.navigationController?.popViewController(animated: true)
        }else{
            
            self.searchLocatioData = nil
            self.searchTestBuds = nil
            
            self.txtFeildAddressSearch.text = ""
            self.txtFieldFoodSearch.text = ""
            
            self.constSearchLocationTextfieldViewHeight.constant = 0
            
//            if self.latitude != nil && self.longitude != nil
//            {
//                self.setZomatoRest(latitude: "\(self.latitude!)", longitude: "\(self.longitude!)", StrtCounty: 0, EndCount: 50)
//            }
//            else
//            {
//                self.retriveDataForRestaurants()
//            }
//
        }
    }
    func setCurrentDeatils(){
        
        self.tblViewAddress.isHidden = true
        self.collectionViewFoodSearch.isHidden = false
        self.viewFood.isHidden = false
        
        let obj = nearByRestaurantsScreenVC()
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
        NotificationCenter.default.addObserver(self, selector: #selector(retriveDataForRestaurants), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
    }
    @IBAction func btnSearchAct(_ sender: Any) {
        
    }
    @IBAction func btnClearForFoodAct(_ sender: Any) {
        txtFieldFoodSearch.text = ""
        self.tblViewAddress.isHidden = true
        self.collectionViewFoodSearch.isHidden = false
        self.viewFood.isHidden = false
    }
    @IBAction func btnClearAct(_ sender: Any) {
        txtFeildAddressSearch.text = ""
        self.tblViewAddress.isHidden = true
        self.collectionViewFoodSearch.isHidden = false
        self.viewFood.isHidden = false
    }
    
    @IBAction func btnCurrentLocation(_ sender: Any) {
        
        self.searchLocatioData = nil
        self.searchTestBuds = nil
        
        self.txtFeildAddressSearch.text = ""
        self.txtFieldFoodSearch.text = ""
        
        self.constSearchLocationTextfieldViewHeight.constant = 0
        
        if self.latitude != nil && self.longitude != nil
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.setZomatoRest(latitude: "\(latitude!)", longitude: "\(longitude!)", StrtCounty: 0, EndCount: 50)
            
        }
        else
        {
            self.retriveDataForRestaurants()
        }
    }
    
    @IBDesignable
    class CardView: UIView {
        
        @IBInspectable var cornerRadius1: CGFloat = 2
        @IBInspectable var shadowOffsetWidth: Int = 0
        @IBInspectable var shadowOffsetHeight: Int = 3
        @IBInspectable var shadowColor: UIColor? = UIColor.black
        @IBInspectable var shadowOpacity: Float = 0.5
        
        override func layoutSubviews() {
            layer.cornerRadius = cornerRadius1
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius1)
            layer.masksToBounds = false
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.cgPath
        }
        
    }
    
    //MARK:- Zomato API to get Restuarant
    
    func setZomatoRest(latitude: String,longitude : String,StrtCounty : Int,EndCount : Int)
    {
        
        if self.app.zomatoAPIuserKEy != nil
        {
            var selectedBudsID = ""
            if self.searchTestBuds != nil
            {
                if let zomato_id = self.searchTestBuds?.object(forKey: "zomato_id")
                {
                    selectedBudsID = "\(zomato_id)"
                }
            }
            
            if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
            {
                UserDefaults.standard.set("20000", forKey: Constants.UserDefaults.FilterDistance)
                UserDefaults.standard.synchronize()
            }
            
            if let mytestBudsID = UserDefaults.standard.object(forKey: Constants.UserDefaults.SelectedZomatoTestBudsID),let radius = UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance)
            {
                if selectedBudsID == ""
                {
                    selectedBudsID = "\(mytestBudsID)"
                }
                
                let mainLink = "https://developers.zomato.com/api/v2.1/search?start=\(StrtCounty)&count=\(EndCount)&lat=\(latitude)&lon=\(longitude)&radius=\(radius)&cuisines=\(selectedBudsID)"
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Webservices_Alamofier.postZomatoWithURL(serverlink: mainLink, param: NSDictionary(), key: self.app.zomatoAPIuserKEy!, successStatusCode: 200)  { (success, response) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if success == true
                    {
                        if let restaurants = response.object(forKey: "restaurants") as? NSArray
                        {
                            if StrtCounty == 0
                            {
                                self.arrForRestaurants.removeAll()
                                
                                let openRest = NSMutableArray()
                                let closeRest = NSMutableArray()
                                
                                for i in 0..<restaurants.count
                                {
                                    if let restDict = restaurants.object(at: i) as? NSDictionary
                                    {
                                        if let dict = restDict.object(forKey: "restaurant") as? NSDictionary
                                        {
                                            if let is_delivering_now = dict.object(forKey: "is_delivering_now") {
                                                if "\(is_delivering_now)" == "1"{
                                                    openRest.add(restDict)
                                                }else{
                                                    closeRest.add(restDict)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                openRest.addObjects(from: closeRest as! [Any])
                                
                                
                                self.arrForRestaurants = openRest as! [[String : AnyObject]]
                            }
                            else
                            {
                                if restaurants.count != 0
                                {
                                    for (_,data) in restaurants.enumerated()
                                    {
                                        if let dataDict = data as? [String : AnyObject]
                                        {
                                            self.arrForRestaurants.append(dataDict)
                                        }
                                    }
                                }
                                else
                                {
                                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                    self.app.window?.rootViewController?.view.makeToast("Current no restuarant available in your area.")
                                }
                                
                                
                            }
                        }
                        
                        self.retriveDataForRestaurantByCarAndWalking(lat: latitude, Longi: longitude)
                    }
                    else
                    {
                        if let msg = response.object(forKey: "message") as? String
                        {
                            self.view.makeToast(msg)
                        }
                        else
                        {
                            self.view.makeToast("Something went to wrong. Please try after some time.")
                        }
                    } 
                }
            }
        }
        else
        {
            self.app.getZomatoKEY { (success) in
                
                if success == true
                {
                    self.setZomatoRest(latitude: latitude, longitude: longitude, StrtCounty: StrtCounty, EndCount: EndCount)
                }
            }
        }
    }
    
    
    
    // MARK: - Google Api
    @objc func retriveDataForRestaurants(){
        
        
        if self.latitude == nil && self.longitude == nil
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            if self.searchLocatioData != nil
            {
                self.getPlaceDetail(googlePlaceID: self.searchLocatioData!.object(forKey: "place_id") as! String)
            }
            else
            {
                self.latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as? String
                self.longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as? String
                //            setData(latitude: latitude!, longitude: longitude!)
                
                self.setZomatoRest(latitude: "\(latitude!)", longitude: "\(longitude!)", StrtCounty: 0, EndCount: 50)
            }
            
        }
        
        self.latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as? String
        self.longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as? String
        
        
    }
    func getPlaceDetail(googlePlaceID:String) {
        
        WebService.GetPlaceDetailByPlaceId(googlePlaceID) { (success, response) -> () in
            if success == true {
                if (response.object(forKey: "result") != nil) {
                    let arr = response.object(forKey: "result") as! NSDictionary
                    let dict = arr["geometry"] as? NSDictionary
                    if let loc = dict!["location"] as? NSDictionary{
//                        self.latitude = String(describing:loc["lat"]!)
//                        self.longitude = String(describing:loc["lng"]!)
                        self.setZomatoRest(latitude: "\(String(describing:loc["lat"]!))", longitude: "\(String(describing:loc["lng"]!))", StrtCounty: 0, EndCount: 50)
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        }}
//    func setData(latitude: String,longitude : String){
//        var myUrl = String()
//        myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&key=\(Constants.GoogleKey.kGoogle_Key)"
//        WebService.CallRequestUrl(myUrl) { (success, response) -> () in
//            print(response)
//            if success == true {
//                //let token = response["next_page_token"] as? String
//                let arr = response["results"]! as! NSArray
//                self.arrForRestaurants  = arr as! [[String : AnyObject]]
//                self.retriveDataForRestaurantByCarAndWalking()
//            }}
//    }
    
    func fetchBusinessFromGoogle (_ searchname : String){
        if searchname.count > 0 {
            WebService.GetAutoCompletePlaces(searchname, locationString: "\(latitude!),\(longitude!)", radiusString: "20000", CompletionHandler: { (success, response) in
                if success == true {
                    self.tblViewAddress.isHidden = false
                    self.collectionViewFoodSearch.isHidden = true
                    self.viewFood.isHidden = true
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
            self.collectionViewFoodSearch.isHidden = true
            self.viewFood.isHidden = true
        }
        self.tblViewAddress.reloadData()
    }
    
    
    
    func retriveDataForRestaurantByCarAndWalking(lat : String, Longi : String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.isService = false
        
        arrDuration.removeAllObjects()
        arrTime.removeAllObjects()
        arrPlaces.removeAllObjects()
        for i in arrForRestaurants{
            arrPlaces.add(i)
        }
        for (index,_) in self.arrPlaces.enumerated() {
            
            if let dict : NSDictionary = self.arrPlaces.object(at: index) as? NSDictionary {
                
                let newData = NSMutableDictionary(dictionary: dict)
                newData.setObject("\(index+1)", forKey: "IndexNumber" as NSCopying)
                self.arrPlaces.replaceObject(at: index, with: newData)
                
                self.arrDuration.add(NSDictionary())
                self.arrTime.add(NSDictionary())
                
//                let latOfPlace : String = String(format: "%f", ((((dict.object(forKey: "geometry") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "lat")! as AnyObject).doubleValue)!)
//
//                let longOfPlace : String = String(format: "%f", ((((dict.object(forKey: "geometry") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "lng")! as AnyObject).doubleValue)!)
                
                let latOfPlace : String = String(format: "%f", ((((dict.object(forKey: "restaurant") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "latitude")! as AnyObject).doubleValue)!)

                let longOfPlace : String = String(format: "%f", ((((dict.object(forKey: "restaurant") as AnyObject).object(forKey: "location") as AnyObject).object(forKey: "longitude")! as AnyObject).doubleValue)!)
                
                var firstStartLat = ""
                var firstStartLong = ""
                var secondStartLat = ""
                var secondStartLong = ""
                var myURL = ""
                firstStartLat = lat
                firstStartLong = Longi
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
                                                }}}}}}}}
                    myURL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(firstStartLat),\(firstStartLong)&destinations=\(secondStartLat),\(secondStartLong)&mode=walking&language=EN&key=\(Constants.GoogleKey.kGoogle_Key)"
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
                                                        myData.setObject(dict, forKey: "WalkFirst" as NSCopying)
                                                        self.arrDuration.replaceObject(at: index, with: myData)
                                                        self.perform(#selector(self.tempFuncForDelay), with: nil, afterDelay: 2)
                                                    }
                                                    //self.setData()
                                                }
                                            }}}}}}}}}}}
    
    @objc func tempFuncForDelay(){
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        arrData.removeAllObjects()
        if isService{}else{
            isService = true
            for i in arrForRestaurants{
                arrData.add(i)
            }
            setData()
        }
        
        self.collectionViewFoodSearch.reloadData()
    }
    
    func setData(){
        arrForRestaurants.removeAll()
        for i in 0..<arrData.count{
            
            if let BudsDict = self.arrDuration.object(at: i) as? NSDictionary
            {
                if let dataDict = self.arrData.object(at: i) as? NSDictionary
                {
                    if let dict = dataDict.object(forKey: "restaurant") as? NSDictionary
                    {
                        let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
                        MuteBudsDict.setValue(dict, forKey: "isSelected")
                        arrData.replaceObject(at: i, with: MuteBudsDict)

                    }
                }
            }
        }
        
        for i in arrData{
            arrForRestaurants.append(i as! [String : AnyObject] )
        }
        
//        print(arrForRestaurants)
        
        self.arrForRestaurants = arrForRestaurants.sorted { (obj1, obj2) -> Bool in
            let str = ((obj1["CarFirst"] as! NSDictionary)["Difference"] as! String).components(separatedBy: " ")
            let str2 = ((obj2["CarFirst"] as! NSDictionary)["Difference"] as! String).components(separatedBy: " ")
            return (str[0]) > (str2[0])
        }
    }
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        if arrDuration.count == arrForRestaurants.count{
            cell.viewBack.layer.shadowOpacity = 0.7
            cell.viewBack.layer.shadowOffset = CGSize.zero
            cell.viewBack.layer.shadowRadius = 3.0
            cell.viewBack.layer.shadowColor = UIColor.lightGray.cgColor
            
            if let dict = arrForRestaurants[indexPath.row]["WalkFirst"] as? NSDictionary{
                if let str = dict["Difference"] as? String{
                    cell.btnFoodDistanceOut.setTitle("\(str)", for: .normal)}}
            if let dict = arrForRestaurants[indexPath.row]["CarFirst"] as? NSDictionary{
                if let str = dict["Difference"] as? String{
                    cell.btnFoodDistanceForCarOut.setTitle("\(str)", for: .normal)}}
            
//            if let dict1 = arrForRestaurants[indexPath.row]["isSelected"] as? NSDictionary{
//                cell.lblSearchFood.text = dict1["name"] as? String
//                if let photos = dict1["photos"] as? [[String:Any]]{
//                    let strRefre = photos.first
//                    let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
//                    cell.imgViewFoodRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)}}
            
            print(arrForRestaurants[indexPath.row])
            if let dict1 = arrForRestaurants[indexPath.row]["isSelected"] as? NSDictionary
            {
                
                if let name = dict1.object(forKey: "name") as? String
                {
                    cell.lblSearchFood.text = name
                }
                
                if let thumb = dict1.object(forKey: "thumb") as? String
                {
                    if thumb != ""
                    {
                        cell.imgViewFoodRestro.sd_setImage(with: URL.init(string: thumb)!, placeholderImage: UIImage(named: ""), options: .retryFailed)
                    }
                    else
                    {
                        cell.imgViewFoodRestro.image = UIImage.init(named: "placeHolderRestraunt")
                    }
                    
                }
                
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "selectedRestaurantDeatilsScreenVC") as! selectedRestaurantDeatilsScreenVC
        if self.latitude != nil && self.longitude != nil
        {
            obj.usercurrentLocation = CLLocation.init(latitude: Double(self.latitude!)!, longitude: Double(self.longitude!)!)
        }
        obj.arrOfRestaurantData = arrForRestaurants[indexPath.row]
        if let dict = arrForRestaurants[indexPath.row]["CarFirst"] as? NSDictionary{
            if let str = dict["Difference"] as? String{
                obj.strTime = str }}
        self.navigationController?.pushViewController(obj, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionViewFoodSearch.frame.width
            / 2) - 5, height: 197)
        
    }
}
extension foodSearchScreenVC : UITextFieldDelegate {
    @objc func textFieldTouchLocation(textField: UITextField) {
        
        self.isSearchTestBuds = false
        UIView.animate(withDuration: 0.5) {
            self.constSearchLocationTextfieldViewHeight.constant = 45
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func textFieldTouchTestbuds(textField: UITextField) {
        
        self.isSearchTestBuds = true
        UIView.animate(withDuration: 0.5) {
            self.constSearchLocationTextfieldViewHeight.constant = 45
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    @objc func textFieldDidChange(textField : UITextField){
        
        if (textField.text?.count)! > 0 {
            if textField == txtFieldFoodSearch{
                
                
                if self.txtFieldFoodSearch.text == ""
                {
                    self.searchTestBuds = nil
                }
                else if self.txtFieldFoodSearch.text != ""
                {
                    if self.searchTestBuds != nil
                    {
                        if let name = self.searchTestBuds?.object(forKey: "name") as? String
                        {
                            if self.txtFieldFoodSearch.text != name
                            {
                                self.searchTestBuds = nil
                            }
                        }
                    }
                }
                
                self.fetchtestBuds(textField.text!)
                
            }else{
                
                
                if self.txtFeildAddressSearch.text == ""
                {
                    self.searchLocatioData = nil
                }
                else if self.txtFeildAddressSearch.text != ""
                {
                    if self.searchLocatioData != nil
                    {
                        if let name = self.searchLocatioData?.object(forKey: "description") as? String
                        {
                            if self.txtFeildAddressSearch.text != name
                            {
                                self.searchLocatioData = nil
                            }
                        }
                    }
                }
                
                self.fetchBusinessFromGoogle(textField.text!)
                
            }
        }
        
    }
    
    func textFieldShouldReturn(_ txtFieldSearchBar : UITextField) -> Bool {
        if txtFieldSearchBar == txtFieldFoodSearch{
            
        }else{
            
        }
        txtFieldSearchBar.resignFirstResponder()
        return true
    }
    
}
extension foodSearchScreenVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchTestBuds == true
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
        
        cell?.textLabel?.font = UIFont.init(name: "GillSans", size: 16.0)
        cell?.textLabel?.frame = CGRect(x: 20, y: 5, width: tableView.frame.size.width - 40, height: 21)
        cell?.textLabel?.numberOfLines = 0
        
        if isSearchTestBuds == true
        {
            if let dict = self.arrSearchTestBuds.object(at: indexPath.row) as? NSDictionary
            {
                if let name = dict.object(forKey: "name") as? String
                {
                    cell?.textLabel?.text = name
                }
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
        if isSearchTestBuds == true
        {
            
            if let dict = self.arrSearchTestBuds.object(at: indexPath.row) as? NSDictionary
            {
                self.searchTestBuds = NSDictionary.init(dictionary: dict)
                
                if let description = self.searchTestBuds?.object(forKey: "name") as? String
                {
                    self.txtFieldFoodSearch.text = description
                }
            }
        }
        else
        {
            if let dict = self.arrForAddress.object(at: indexPath.row) as? NSDictionary
            {
                self.searchLocatioData = NSDictionary.init(dictionary: dict)
                
                if let description = self.searchLocatioData?.object(forKey: "description") as? String
                {
                    self.txtFeildAddressSearch.text = description
                }
            }
            
           
            txtFeildAddressSearch.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
        }
       
        self.tblViewAddress.isHidden = true
        self.collectionViewFoodSearch.isHidden = false
        viewFood.isHidden = false
        txtFeildAddressSearch.resignFirstResponder()
    }
}
