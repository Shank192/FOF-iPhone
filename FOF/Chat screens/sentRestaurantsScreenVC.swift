//
//  sentRestaurantsScreenVC.swift
//  FOF
//

import UIKit
import MBProgressHUD

class sentRestaurantsScreenVC: UIViewController,UISearchBarDelegate {
    
    
    
    
    @IBOutlet weak var txtViewMessage: UITextView!
    var arrForRestaurants = [[String:AnyObject]]()
    var arrSelectedRestaurants = NSMutableArray()

    @IBOutlet weak var btnBackOut: UIButton!
    @IBOutlet weak var viewBlure: UIView!
    var arrDuration = NSMutableArray()
    var arrPlaces = NSMutableArray()
    var arrTime = NSMutableArray()
    var arrData = NSMutableArray()

    var latitude = String()
    var longitude = String()
    var dictUserDetail = NSDictionary()

    var isService = false
    var isfrind = Bool()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionViewRestaurants: UICollectionView!
  
override func viewDidLoad() {
        super.viewDidLoad()
    setCurrentDeatils()
    }

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setCurrentDeatils(){
        
    
        let obj = sentRestaurantsScreenVC()
        
      
        if let str = dictUserDetail.object(forKey: "first_name") as? String{
            txtViewMessage.text = "Hi \(str) Wanna grab a bite?"}
   
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
        NotificationCenter.default.addObserver(self, selector: #selector(retriveDataForRestaurants), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
    }
    // MARK: - Google Api
    @objc func retriveDataForRestaurants(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
        longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
        setData(latitude: latitude, longitude: longitude)
    }
    func setData(latitude: String,longitude : String){
        var myUrl = String()
        myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&key=\(Constants.GoogleKey.kGoogle_Key)"
        WebService.CallRequestUrl(myUrl) { (success, response) -> () in
            print(response)
            if success == true {
                //let token = response["next_page_token"] as? String
                let arr = response["results"]! as! NSArray
                self.arrForRestaurants  = arr as! [[String : AnyObject]]
                self.collectionViewRestaurants.reloadData()
                self.retriveDataForRestaurantByCarAndWalking()
            }}
    }
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
        
        self.collectionViewRestaurants.reloadData()
    }
    func setData(){
        arrForRestaurants.removeAll()
        for i in 0..<arrData.count{
            
            if let BudsDict = self.arrDuration.object(at: i) as? NSDictionary
            {
                let MuteBudsDict = NSMutableDictionary(dictionary: BudsDict)
                MuteBudsDict.setValue(self.arrData.object(at: i) as? NSDictionary, forKey: "RestaurantData")
                MuteBudsDict.setValue("0", forKey: "isSelected")
                arrData.replaceObject(at: i, with: MuteBudsDict)
            }
            
        }
        
        for i in arrData{
            arrForRestaurants.append(i as! [String : AnyObject] )
        }
        self.arrForRestaurants = arrForRestaurants.sorted { (obj1, obj2) -> Bool in
            let str = ((obj1["CarFirst"] as! NSDictionary)["Difference"] as! String).components(separatedBy: " ")
            let str2 = ((obj2["CarFirst"] as! NSDictionary)["Difference"] as! String).components(separatedBy: " ")
            return (str[0]) > (str2[0])
        }
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
            
            
            for i in arrForRestaurants{
                if  i["isSelected"] as! String == "1"{
                    arrSelectedRestaurants.add(i)
                    obj.arrForRestaurants.append(i)
                }
            }
            obj.dictUserDetails = dictUserDetail
            obj.strMessage = (txtViewMessage?.text)!
            self.navigationController?.pushViewController(obj, animated: false)
            self.dismiss(animated: true, completion: nil)
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
                if let photos = dict1["photos"] as? [[String:Any]]{
                    let strRefre = photos.first
                    let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
                    cell.imgViewRestaurant.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)}}
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
                    let muteDict = NSMutableDictionary(dictionary: dict)
                    muteDict.setValue("0", forKey: "isSelected")
                    arrForRestaurants.remove(at: indexPath.row)
                    arrForRestaurants.insert(muteDict as! [String : AnyObject], at: indexPath.row)
                }else{
                    let muteDict = NSMutableDictionary(dictionary: dict)
                    muteDict.setValue("1", forKey: "isSelected")
                    arrForRestaurants.remove(at: indexPath.row)
                    arrForRestaurants.insert(muteDict as! [String : AnyObject], at: indexPath.row)
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
        
 
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        retriveDataForRestaurant(strType: searchBar.text!)
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
       searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
    }
}
