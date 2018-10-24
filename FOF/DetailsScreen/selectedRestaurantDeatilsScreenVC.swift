//
//  selectedRestaurantDeatilsScreenVC.swift
//  FOF
//
//

import UIKit



class selectedRestaurantDeatilsScreenVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewProfileImages: UICollectionView!
    @IBOutlet weak var imgPrsnGiveReview: UIImageView!
    var startTime = Timer()
    var phoneNumber = String()
    var arrOfImages = [String]()
    var arrOfRestaurantData = [String:AnyObject]()
    var arrResponseForDetail = [[String:AnyObject]]()
    var arrResponseForReviews = NSMutableArray()
   var strTime = String()
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblReviewerName: UILabel!
    @IBOutlet weak var lblRestaurantNumber: UIButton!
    @IBOutlet weak var lblRestaurantWebsite: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var btnTimeOut: UIButton!
    
    @IBOutlet weak var btnStar5Out: UIButton!
    @IBOutlet weak var btnStar4Out: UIButton!
    @IBOutlet weak var btnStar3Out: UIButton!
    @IBOutlet weak var btnStar2Out: UIButton!
    @IBOutlet weak var btnStar1Out: UIButton!
    @IBOutlet weak var lblNumberOfImages: UILabel!
    
    @IBOutlet weak var ViewNoReview: UIView!
    @IBOutlet weak var btnReadAllReview: UIButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(arrOfRestaurantData)
        
        if let CarFirst = self.arrOfRestaurantData["CarFirst"] as? NSDictionary
        {
            if let Difference = CarFirst.object(forKey: "Difference") as? String
            {
                self.btnTimeOut.setTitle(" \(Difference)", for: .normal)
            }
            
        }
        
        self.GetRestuarantReview()
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        startTimer()

    }
    override func viewDidDisappear(_ animated: Bool) {
    startTime.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   
    // MARK: - Button Actions
    
    @IBAction func btnNumberAct(_ sender: Any) {
        let mynumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(mynumber)") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (finished) in
                    })
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    @IBAction func btnReadAllReviewAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "allReviewsScreenVC") as! allReviewsScreenVC
       obj.arrForReviews = arrResponseForReviews
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInviteFrndAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "chatScreenVC") as! chatScreenVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - Set Details
    func startTimer() {
     startTime = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
    func setReviewsDetails(){
        
        if self.arrResponseForReviews.count > 0
        {
            
            
            if let dataDict = self.arrResponseForReviews.object(at: 0) as? NSDictionary
            {
                self.ViewNoReview.isHidden = true
                self.btnReadAllReview.isHidden = false
                
                if let reviewDict = dataDict.object(forKey: "review") as? NSDictionary
                {
                    if let dict = reviewDict.object(forKey: "user") as? NSDictionary
                    {
                        lblReviewerName.text = dict.object(forKey: "name") as? String
                        lblReview.text = reviewDict.object(forKey: "review_text") as? String
                        if let rating = reviewDict.object(forKey: "rating") as? Int
                        {
                            switch rating {
                            case 1:
                                self.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar2Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                self.btnStar3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                self.btnStar4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                self.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                break
                            case 2:
                                self.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                self.btnStar4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                self.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                break
                            case 3:
                                self.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                self.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                break
                            case 4:
                                self.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                break
                            case 5:
                                self.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                self.btnStar5Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                break
                            default:
                                break
                            }
                        }
                        
                        if let str = dict.object(forKey: "profile_image") as? String
                        {
                            imgPrsnGiveReview.cornerRadius = imgPrsnGiveReview.frame.width/2
                            imgPrsnGiveReview.clipsToBounds = true
                            let url = NSURL(string:  str)!  as URL
                            imgPrsnGiveReview.sd_setImage(with: url)
                        }
                        
                    }
                }
                
            }
        }
        else
        {
            self.ViewNoReview.isHidden = false
            self.btnReadAllReview.isHidden = true
        }
    }
  
    func setRestuarantData(dict : NSDictionary)
    {
        
        print(dict)
       self.lblRestaurantWebsite.isHidden = true
        self.lblRestaurantNumber.isHidden = true
        
        if let addDict = dict.object(forKey: "location") as? NSDictionary
        {
            if let address = addDict.object(forKey: "address") as? String
            {
                self.lblRestaurantAddress.text = address
            }
        }
        
        
        if let featured_image = dict.object(forKey: "thumb") as? String
        {
            self.arrOfImages.append(featured_image)
        }
        
        self.lblNumberOfImages.text = "\(1)/\(self.arrOfImages.count)"
        
        
        self.collectionViewProfileImages.reloadData()
        self.setReviewsDetails()
        
    }
    
    
//    func getplaceDetails(placeId : String){
//        if placeId != "" {
//            let GdetailLink : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid="  + placeId  + "&key=\(Constants.GoogleKey.kGoogle_Key)"
//            WebService.CallRequestUrl(GdetailLink) { (success, response) in
//                print(response)
//                let dict = response["result"] as! NSDictionary
//                if let str = dict["website"] as? String{
//                    self.lblRestaurantWebsite.text = str
//                }else{
//                   self.lblRestaurantWebsite.text = "No website"
//                }
//                if let strPhone = dict["international_phone_number"] as? String{
//                    self.phoneNumber = strPhone
//                    self.lblRestaurantNumber.setTitle(strPhone, for: .normal)
//                }else{
//                     self.lblRestaurantNumber.setTitle("No phone number", for: .normal)
//                }
//                self.lblRestaurantAddress.text = dict["vicinity"] as? String
//                self.arrOfImages = dict["photos"] as! [[String:AnyObject]]
//                self.lblNumberOfImages.text = "\(1)/\(self.arrOfImages.count)"
//                self.arrResponseForReviews = dict["reviews"] as! [[String:AnyObject]]
//
//                self.collectionViewProfileImages.reloadData()
//                self.setReviewsDetails()
//            }
//        }
//    }
    
    //MARK:- Webservice
    
    func GetRestuarantReview()
    {
        if self.app.zomatoAPIuserKEy != nil
        {
            if let dataDict = self.arrOfRestaurantData["isSelected"] as? NSDictionary
            {
                if let restID = dataDict.object(forKey: "id")
                {
                    let mainLink = "https://developers.zomato.com/api/v2.1/reviews?res_id=\(restID)&start=0&count=10"
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    Webservices_Alamofier.postZomatoWithURL(serverlink: mainLink, param: NSDictionary(), key: self.app.zomatoAPIuserKEy!, successStatusCode: 200) { (success, response) in
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if success == true
                        {
                            if let arryData = response.object(forKey: "user_reviews") as? [[String:AnyObject]]
                            {
                                self.arrResponseForReviews = NSMutableArray(array: arryData)
                                
                            }
                            
                            if let dict = self.arrOfRestaurantData["isSelected"] as? NSDictionary
                            {
                                self.setRestuarantData(dict: dict)
                            }
                            
                        }
                        else
                        {
                            if let msg = response.object(forKey: "message") as? String
                            {
                                self.view.makeToast(msg)
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                self.GetRestuarantReview()
                            }
                            
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
                    self.GetRestuarantReview()
                }
            }
        }
        
    }
    
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
//        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(arrOfImages[indexPath.row]["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
//        cell.imgViewOfRestaurant.sd_setImage(with: url, placeholderImage: UIImage(named: "placeHolderRestraunt"), options: .retryFailed)
        
        
        if let str = self.arrOfImages[indexPath.row] as? String
        {
            if str != ""
            {
                cell.imgViewOfRestaurant.sd_setImage(with: URL.init(string: str)!, placeholderImage: UIImage(named: "placeHolderRestraunt"), options: .retryFailed)
            }
            else
            {
                cell.imgViewOfRestaurant.image = UIImage(named: "placeHolderRestraunt")
            }
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewProfileImages.frame.width, height: self.collectionViewProfileImages.frame.height)
        
    }
    @objc  func scrollToNextCell(){
        let cellSize =  CGSize(width: self.view.frame.width, height: self.view.frame.height)
        let contentOffset = collectionViewProfileImages.contentOffset;
        if collectionViewProfileImages.contentSize.width <= collectionViewProfileImages.contentOffset.x + cellSize.width
        {
            collectionViewProfileImages.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        } else {
            collectionViewProfileImages.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewProfileImages{
            for i in 1..<arrOfImages.count+1{
                if scrollView.contentOffset.x == collectionViewProfileImages.frame.width*CGFloat(i){
                        lblNumberOfImages.text = "\(i+1)/\(arrOfImages.count)"
                }
            }
        }
    }
}
