//
//  sentRestaurantsScreenVC.swift
//  FOF
//

import UIKit

class sentRestaurantsScreenVC: UIViewController,UISearchBarDelegate {
  
    @IBOutlet weak var txtViewMessage: UITextView!
    var arrForRestaurants = [[String:AnyObject]]()
    var arrSelectedRestaurants = NSMutableArray()

    @IBOutlet weak var nsTextViewBottome: NSLayoutConstraint!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var lblSelectUpToFive: UILabel!
    @IBOutlet weak var btnBackOut: UIButton!
    @IBOutlet weak var viewBlure: UIView!
    var arrDuration = NSMutableArray()
    var arrPlaces = NSMutableArray()
    var arrTime = NSMutableArray()
    var arrData = NSMutableArray()
    var latitude = String()
    var longitude = String()
    var dictUserDetail = NSDictionary()

    var arrAllTestBudsPlaces = [[String : AnyObject]]()
    var arrSearchTestBuds = NSMutableArray()
    var searchTestBuds : NSDictionary?
    
    var isService = false
    var isfrind = Bool()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionViewRestaurants: UICollectionView!
    var selectedCount = 0
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var isREstAPICall = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearch.layoutMargins = UIEdgeInsets.zero
        tblSearch.tableFooterView = UIView(frame: CGRect.zero)
        tblSearch.separatorInset = UIEdgeInsets.zero
        
        self.registerForKeyboardNotifications()
        setCurrentDeatils()
        
    }

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setCurrentDeatils(){
        
        self.tblSearch.isHidden = true
        self.collectionViewRestaurants.isHidden = false
    
        let obj = sentRestaurantsScreenVC()
        
    
        if let str = dictUserDetail.object(forKey: "first_name") as? String{
            txtViewMessage.text = "Hi \(str) Wanna grab a bite?"
            self.lblSelectUpToFive.text = "Select upto 5 restaurants and share with \(str)."
        }
        else if let str = dictUserDetail.object(forKey: "name") as? String{
            
            txtViewMessage.text = "Hi \(str) Wanna grab a bite?"
            self.lblSelectUpToFive.text = "Select upto 5 restaurants and share with \(str)."
            
        }
        
        if let TestArray = UserDefaults.standard.object(forKey: Constants.UserDefaults.AllTestBudsArrayFromYourLocation) as? NSArray
        {
            self.arrAllTestBudsPlaces = TestArray as! [[String : AnyObject]]
        }
        
        
        
        if self.searchTestBuds != nil
        {
            if let name = self.searchTestBuds?.object(forKey: "name") as? String
            {
                self.searchBar.text = name
            }
        }
        
        
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
        NotificationCenter.default.addObserver(self, selector: #selector(retriveDataForRestaurants), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
    }
    func setRestaurantScreen(){
        
    }
    
    //MARK:-
    func registerForKeyboardNotifications () {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWasHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWasHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    
    @objc func keyboardWasHide(_ aNotification: Notification) {
        let _: NSDictionary = aNotification.userInfo! as NSDictionary
        
        nsTextViewBottome.constant  = 0 // Move view to original position
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        }, completion: { (finished : Bool) -> Void in
            
        })
    }
    
    @objc func keyboardWasShown(_ aNotification: Notification) {
        let info: NSDictionary = aNotification.userInfo! as NSDictionary
        let kbSize : CGRect = (info.object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        
        if #available(iOS 11.0, *) {
            nsTextViewBottome.constant = kbSize.height - self.view.safeAreaInsets.bottom
        } else {
            nsTextViewBottome.constant = kbSize.height - 40
            
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
        }, completion: { (finished : Bool) -> Void in
            
        })
    }
    
    // MARK: - Google Api
    @objc func retriveDataForRestaurants(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
        longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
        
//        setData(latitude: latitude, longitude: longitude)
        if longitude != "" && longitude != "" && self.isREstAPICall == false
        {
            self.setZomatoRest(latitude: latitude, longitude: longitude, StrtCounty: 0, EndCount: 50)
        }
        
        
        
    }
    
    
    func setZomatoRest(latitude: String,longitude : String,StrtCounty : Int,EndCount : Int)
    {
        self.isREstAPICall = true
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
                            
                            if restaurants.count == 0
                            {
                                Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast("No resturant available right now. Please try after sometime.")
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                            
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
                                
                                
                                
                                
                                self.arrForRestaurants  = openRest as! [[String : AnyObject]]
                                self.collectionViewRestaurants.reloadData()
                                
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
                        
                        if self.arrForRestaurants.count != 0
                        {
                            self.retriveDataForRestaurantByCarAndWalking()
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
                            self.view.makeToast("Something went to wrong. Please try after some time.")
                        }
                    }
                    self.isREstAPICall = false
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
    
    
//    func setData(latitude: String,longitude : String){
//        var myUrl = String()
//        myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&key=\(Constants.GoogleKey.kGoogle_Key)"
//        WebService.CallRequestUrl(myUrl) { (success, response) -> () in
//            print(response)
//            if success == true {
//                //let token = response["next_page_token"] as? String
//                let arr = response["results"]! as! NSArray
//                self.arrForRestaurants  = arr as! [[String : AnyObject]]
//                self.collectionViewRestaurants.reloadData()
//                self.retriveDataForRestaurantByCarAndWalking()
//            }}
//    }
    @objc func retriveDataForRestaurant(strType : String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var myUrl = String()
        myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&keyword=\(strType)&key=\(Constants.GoogleKey.kGoogle_Key)"
        WebService.CallRequestUrl(myUrl) { (success, response) -> () in
            print(response)
            if success == true {
                let arr = response["results"]! as! NSArray
                self.arrForRestaurants = arr as! [[String:AnyObject]]
                self.retriveDataForRestaurantByCarAndWalking()
            }}}
    func retriveDataForRestaurantByCarAndWalking(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.isService = false
        
        arrDuration.removeAllObjects()
       // arrTime.removeAllObjects()
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
                                                }
                                            }
                                            else
                                            {
                                                let dict = ["Difference":"No data Available"]
                                                let myData = NSMutableDictionary(dictionary: tempData)
                                                myData.setObject(dict, forKey: "CarFirst" as NSCopying)
                                                self.arrDuration.replaceObject(at: index, with: myData)
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if let error_message = response.object(forKey: "error_message") as? String
                                    {
                                        Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast(error_message)
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    }
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
                                                else
                                                {
                                                    let dict = ["Difference":"No data Available"]
                                                    let myData = NSMutableDictionary(dictionary: tempData)
                                                    myData.setObject(dict, forKey: "CarFirst" as NSCopying)
                                                    self.arrDuration.replaceObject(at: index, with: myData)
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
        
        self.collectionViewRestaurants.reloadData()
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
                        MuteBudsDict.setValue(dict, forKey: "RestaurantData")
                        MuteBudsDict.setValue("0", forKey: "isSelected")
                        arrData.replaceObject(at: i, with: MuteBudsDict)
                        
                    }
                }
            }
        }
        
        
        
        for i in arrData{
            print(i)
            arrForRestaurants.append(i as! [String : AnyObject] )
        }
        
        
        
        self.arrForRestaurants = arrForRestaurants.sorted { (obj1, obj2) -> Bool in
            
            if obj1["CarFirst"] != nil && obj2["CarFirst"] != nil
            {
                let str = ((obj1["CarFirst"] as! NSDictionary)["Difference"] as! String).components(separatedBy: " ")
                let str2 = ((obj2["CarFirst"] as! NSDictionary)["Difference"] as! String).components(separatedBy: " ")
                return (str[0]) > (str2[0])
            }
            
            
            return false
            
        }
    }
    
    //MARK:- Custome method
    func fetchtestBuds(_ searchname : String)
    {
        let result =  self.arrAllTestBudsPlaces.filter({ (data) -> Bool in
            let stringname = data["name"] as! String
            return stringname.lowercased().contains(searchname.lowercased())

        })

        self.arrSearchTestBuds = NSMutableArray.init(array: result as [Any])
        if self.arrSearchTestBuds.count > 0
        {
            self.tblSearch.isHidden = false
            self.collectionViewRestaurants.isHidden = true
            
        }
        self.tblSearch.reloadData()
    }
    
    
// MARK: - Button Action Method
    
    
    @IBAction func btnBackAct(_ sender: Any) {
        if isfrind{
        let objConvo : conversationScreenVC = parent as! conversationScreenVC
            objConvo.backButtonRestraunt()}else{
            self.navigationController?.popViewController(animated: true)

            }
    }
    
    @IBAction func btnSendAct(_ sender: Any) {
         let objConvo : conversationScreenVC = parent as! conversationScreenVC
        if isfrind{
        for i in arrForRestaurants{
            if  i["isSelected"] as! String == "1"{
                arrSelectedRestaurants.add(i)
            }
        }
        objConvo.sendRestaurants(arrRestaurants: arrSelectedRestaurants, strMessage: "")
            self.dismiss(animated: true, completion: nil)
            objConvo.backButtonRestraunt()
        }else{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "sentRequestRestaurantScreenVC") as! sentRequestRestaurantScreenVC
            
            obj.isRequestSent = true
            for i in arrForRestaurants{
                if  i["isSelected"] as! String == "1"{
                    arrSelectedRestaurants.add(i)
                    obj.arrForRestaurants.append(i)
                }
            }
            obj.isSent = false
            obj.dictUserDetails = dictUserDetail
            obj.strMessage = (txtViewMessage?.text)!
           self.navigationController?.pushViewController(obj, animated: false)
           // self.dismiss(animated: true, completion: nil)
        }
  }
    
    
    
    
}
extension sentRestaurantsScreenVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! photoCollectionViewCell
        if arrDuration.count == arrForRestaurants.count{
            cell.viewBack.layer.shadowOpacity = 0.7
            cell.viewBack.layer.shadowOffset = CGSize.zero
            cell.viewBack.layer.shadowRadius = 3.0
            cell.viewBack.layer.shadowColor = UIColor.lightGray.cgColor
           
//            if let dict = arrForRestaurants[indexPath.row]["WalkFirst"] as? NSDictionary{
//                if let str = dict["Difference"] as? String{
//                    cell.btnFoodDistanceOut.setTitle("\(str)", for: .normal)}}
            if let dict = arrForRestaurants[indexPath.row]["CarFirst"] as? NSDictionary{
                if let str = dict["Difference"] as? String{
                    cell.lblTimeRestaurant.text = str }}
            if let dict1 = arrForRestaurants[indexPath.row]["RestaurantData"] as? NSDictionary{
                cell.lblRestaurant.text = dict1["name"] as? String
                if let photos = dict1["thumb"] as? String //[[String:Any]]
                {
                    //                    let strRefre = photos.first
                    //                    let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
                    if photos != ""
                    {
                        let url = URL.init(string: photos)
                        cell.imgViewRestaurant.sd_setImage(with: url, placeholderImage: UIImage.init(named: "placeHolderRestraunt"), options: .retryFailed)
                    }
                    else
                    {
                        cell.imgViewRestaurant.image = UIImage.init(named: "placeHolderRestraunt")
                    }
                }
                
            }
            if let strSelect = arrForRestaurants[indexPath.row]["isSelected"] as? String{
                if strSelect == "0"{
                    cell.viewBlure.isHidden = true
                    cell.btnTickMarkOut.isHidden = true
                }else{
                    cell.viewBlure.isHidden = false
                    cell.btnTickMarkOut.isHidden = false
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let obj = storyboard?.instantiateViewController(withIdentifier: "selectedRestaurantDeatilsScreenVC") as! selectedRestaurantDeatilsScreenVC
//        obj.arrOfRestaurantData = arrForRestaurants[indexPath.row]
//        if let dict = (arrDuration.object(at: indexPath.row) as AnyObject).object(forKey: "CarFirst") as? NSDictionary{
//            if let str = dict["TimeDifference"] as? String{
//                obj.strTime = str }}
//        self.navigationController?.pushViewController(obj, animated: false)
       
        if let dict = self.arrForRestaurants[indexPath.row] as? NSDictionary
        {
            print(dict)
            if let isSelected = dict.object(forKey: "isSelected")
            { if "\(isSelected)" == "1" {
                if selectedCount > 0
                {
                    selectedCount = selectedCount - 1
                }
                let muteDict = NSMutableDictionary(dictionary: dict)
                muteDict.setValue("0", forKey: "isSelected")
                arrForRestaurants.remove(at: indexPath.row)
                arrForRestaurants.insert(muteDict as! [String : AnyObject], at: indexPath.row)
            }else{
                if selectedCount < 5
                {
                    let muteDict = NSMutableDictionary(dictionary: dict)
                    muteDict.setValue("1", forKey: "isSelected")
                    selectedCount = selectedCount + 1
                    arrForRestaurants.remove(at: indexPath.row)
                    arrForRestaurants.insert(muteDict as! [String : AnyObject], at: indexPath.row)
                }
                else
                {
                    Constants.GlobalConstants.appDelegate.window?.rootViewController!.view.makeToast("You have select only 5 restaurants.")
                }
                
                }
            }
            
        }
      
        self.collectionViewRestaurants.reloadItems(at: [indexPath])

        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionViewRestaurants.frame.width
            / 2) - 20, height: 148)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText == ""
        {
            self.searchTestBuds = nil
        }
        else if searchText != ""
        {
            if self.searchTestBuds != nil
            {
                if let name = self.searchTestBuds?.object(forKey: "name") as? String
                {
                    if searchText != name
                    {
                        self.searchTestBuds = nil
                    }
                }
            }
            
            self.fetchtestBuds(searchText)
        }
        
        
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        
        if searchBar.text == ""
        {
           self.searchTestBuds = nil
        }
        
        if self.searchTestBuds != nil
        {
            if self.latitude != "" && self.longitude != ""
            {
                self.setZomatoRest(latitude: "\(self.latitude)", longitude: "\(self.longitude)", StrtCounty: 0, EndCount: 50)
            }
            else
            {
                self.retriveDataForRestaurants()
            }
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
       searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchTestBuds = nil
        if self.latitude != "" && self.longitude != ""
        {
            self.setZomatoRest(latitude: "\(self.latitude)", longitude: "\(self.longitude)", StrtCounty: 0, EndCount: 50)
        }
        else
        {
            self.retriveDataForRestaurants()
        }
        self.tblSearch.isHidden = true
        self.collectionViewRestaurants.isHidden = false
        
        
    }
}


extension sentRestaurantsScreenVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return arrSearchTestBuds.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.font = UIFont.init(name: "GillSans", size: 16.0)
        cell?.textLabel?.frame = CGRect(x: 20, y: 5, width: tableView.frame.size.width - 40, height: 21)
        cell?.textLabel?.numberOfLines = 0
        
        
        if let dict = self.arrSearchTestBuds.object(at: indexPath.row) as? NSDictionary
        {
            if let name = dict.object(forKey: "name") as? String
            {
                cell?.textLabel?.text = name
            }
        }
        
        
        cell?.textLabel?.sizeToFit()
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let dict = self.arrSearchTestBuds.object(at: indexPath.row) as? NSDictionary
        {
            self.searchTestBuds = NSDictionary.init(dictionary: dict)
            
            if let description = self.searchTestBuds?.object(forKey: "name") as? String
            {
                self.searchBar.text = description
            }
        }
        
        if self.latitude != "" && self.longitude != ""
        {
            self.setZomatoRest(latitude: "\(self.latitude)", longitude: "\(self.longitude)", StrtCounty: 0, EndCount: 50)
        }
        else
        {
            self.retriveDataForRestaurants()
        }
        
        self.tblSearch.isHidden = true
        self.collectionViewRestaurants.isHidden = false
        
        self.searchBar.resignFirstResponder()
        
    }
}
