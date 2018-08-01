//
//  foodSearchScreenVC.swift
//  FOF
//


import UIKit
import MBProgressHUD

class foodSearchScreenVC: UIViewController , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionViewFoodSearch: UICollectionView!
    
    @IBOutlet weak var tblViewAddress: UITableView!
    
    @IBOutlet weak var txtFieldFoodSearch: UITextField!
    @IBOutlet weak var txtFeildAddressSearch: UITextField!
    var arrForRestaurants = [[String:AnyObject]]()
    var arrForAddress = NSMutableArray()
    var latitude = String()
    var longitude = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setCurrentDeatils()
        txtFeildAddressSearch.delegate = self
        txtFeildAddressSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Button Action
    func setCurrentDeatils(){
        let obj = nearByRestaurantsScreenVC()
        Constants.GlobalConstants.appDelegate.locateLocationManager(view: obj)
        NotificationCenter.default.addObserver(self, selector: #selector(retriveDataForRestaurants), name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
    }
    @IBAction func btnSearchAct(_ sender: Any) {
        
    }
    @IBAction func btnClearForFoodAct(_ sender: Any) {
        txtFieldFoodSearch.text = ""
    }
    @IBAction func btnClearAct(_ sender: Any) {
        txtFeildAddressSearch.text = ""
    }
    
    @IBAction func btnCurrentLocation(_ sender: Any) {
        
        setCurrentDeatils()
    }
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        cell.viewBack.layer.shadowOpacity = 0.7
        cell.viewBack.layer.shadowOffset = CGSize.zero
        cell.viewBack.layer.shadowRadius = 3.0
        cell.viewBack.layer.shadowColor = UIColor.lightGray.cgColor
        
        cell.lblSearchFood.text = arrForRestaurants[indexPath.row]["name"] as? String
        cell.btnFoodDistanceOut.setTitle("15 km", for: .normal)
        cell.btnFoodDistanceForCarOut.setTitle("15 km", for: .normal)
        if let photos = arrForRestaurants[indexPath.row]["photos"] as? [[String:Any]]{
            let strRefre = photos.first
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
            cell.imgViewFoodRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionViewFoodSearch.frame.width
            / 2) - 15, height: 197)
        
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
    // MARK: - Google Api
    @objc func retriveDataForRestaurants(){
        if latitude == UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String{
            
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            latitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) as! String
            longitude = UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) as! String
            setData(latitude: latitude, longitude: longitude)
          }
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
                        self.setData(latitude: lat, longitude: lng)
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        }}
    func setData(latitude: String,longitude : String){
        var myUrl = String()
        myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&key=\(Constants.GoogleKey.kGoogle_Key)"
        WebService.CallRequestUrl(myUrl) { (success, response) -> () in
            print(response)
            if success == true {
                let token = response["next_page_token"] as? String
                let arr = response["results"]! as! NSArray
                self.arrForRestaurants  = arr as! [[String : AnyObject]]
                print(token as Any)
                self.collectionViewFoodSearch.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }}
    }
    func fetchBusinessFromGoogle (_ searchname : String){
        if searchname.count > 0 {
            WebService.GetAutoCompletePlaces(searchname, locationString: "\(latitude),\(longitude)", radiusString: "20000", CompletionHandler: { (success, response) in
                if success == true {
                    self.tblViewAddress.isHidden = false
                    self.collectionViewFoodSearch.isHidden = true
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
    @objc func retriveDataForRestaurant(strType : String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var myUrl = String()
        myUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=20000&type=\("restaurant")&keyword=\(strType)&key=\(Constants.GoogleKey.kGoogle_Key)"
        WebService.CallRequestUrl(myUrl) { (success, response) -> () in
            print(response)
            if success == true {
                // let token = response["next_page_token"] as? String
                let arr = response["results"]! as! NSArray
                self.arrForRestaurants = arr as! [[String:AnyObject]]
                self.collectionViewFoodSearch.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }}}
  
}
extension foodSearchScreenVC : UITextFieldDelegate {
    @objc func textFieldDidChange(textField : UITextField){
        
        if (textField.text?.count)! > 0 {
            if textField == txtFieldFoodSearch{
                
            }else{
                self.fetchBusinessFromGoogle(textField.text!)
            }
        }}
    
    func textFieldShouldReturn(_ txtFieldSearchBar : UITextField) -> Bool {
        if txtFieldSearchBar == txtFieldFoodSearch{
            retriveDataForRestaurant(strType: txtFieldSearchBar.text!)
        }else{
            
        }
        txtFieldFoodSearch.resignFirstResponder()
        return true
    }
    
}
extension foodSearchScreenVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.font = UIFont.init(name: "GillSans", size: 16.0)
        cell?.textLabel?.frame = CGRect(x: 20, y: 5, width: tableView.frame.size.width - 40, height: 21)
        cell?.textLabel?.numberOfLines = 0
        
        if arrForAddress.count > indexPath.row {
            cell?.textLabel?.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
        } else {
            cell?.textLabel?.text = ""
        }
        cell?.textLabel?.sizeToFit()
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getPlaceDetail(googlePlaceID:(arrForAddress.object(at: indexPath.row)as AnyObject).object(forKey: "place_id") as! String)
        txtFeildAddressSearch.text = (arrForAddress.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String
        self.tblViewAddress.isHidden = true
        self.collectionViewFoodSearch.isHidden = false
        txtFeildAddressSearch.resignFirstResponder()
    }
}
