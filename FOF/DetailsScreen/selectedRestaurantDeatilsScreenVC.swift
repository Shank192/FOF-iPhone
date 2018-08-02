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
    var arrOfImages = [[String:AnyObject]]()
    var arrOfRestaurantData = [String:AnyObject]()
    var arrResponseForDetail = [[String:AnyObject]]()
    var arrResponseForReviews = [[String:AnyObject]]()
   var strTime = String()
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblReviewerName: UILabel!
    @IBOutlet weak var lblRestaurantNumber: UIButton!
    @IBOutlet weak var lblRestaurantWebsite: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var btnTimeOut: UIButton!
    
    @IBOutlet weak var lblNumberOfImages: UILabel!
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(arrOfRestaurantData)
        lblRestaurantName.text = arrOfRestaurantData["name"] as? String
        if let str = strTime as? String{
            btnTimeOut.setTitle(" \(str)", for: .normal)}else{
           btnTimeOut.setTitle("18 mins", for: .normal)
        }
        getplaceDetails(placeId: arrOfRestaurantData["place_id"] as! String)
    }
    override func viewWillAppear(_ animated: Bool) {
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
        lblReviewerName.text = arrResponseForReviews[0]["author_name"] as? String
        lblReview.text = arrResponseForReviews[0]["text"] as? String
        imgPrsnGiveReview.cornerRadius = imgPrsnGiveReview.frame.width/2
        imgPrsnGiveReview.clipsToBounds = true
        let url = NSURL(string: arrResponseForReviews[0]["profile_photo_url"] as! String)!  as URL
        imgPrsnGiveReview.sd_setImage(with: url)
    }
  
    func getplaceDetails(placeId : String){
        if placeId != "" {
            let GdetailLink : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid="  + placeId  + "&key=\(Constants.GoogleKey.kGoogle_Key)"
            WebService.CallRequestUrl(GdetailLink) { (success, response) in
                print(response)
                let dict = response["result"] as! NSDictionary
                if let str = dict["website"] as? String{
                    self.lblRestaurantWebsite.text = str
                }else{
                   self.lblRestaurantWebsite.text = "No website"
                }
                if let strPhone = dict["international_phone_number"] as? String{
                    self.phoneNumber = strPhone
                    self.lblRestaurantNumber.setTitle(strPhone, for: .normal)
                }else{
                     self.lblRestaurantNumber.setTitle("No phone number", for: .normal)
                }
                self.lblRestaurantAddress.text = dict["vicinity"] as? String
                self.arrOfImages = dict["photos"] as! [[String:AnyObject]]
                self.lblNumberOfImages.text = "\(1)/\(self.arrOfImages.count)"
                self.arrResponseForReviews = dict["reviews"] as! [[String:AnyObject]]
                self.collectionViewProfileImages.reloadData()
                self.setReviewsDetails()
            }
        }}
    
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(arrOfImages[indexPath.row]["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
        cell.imgViewOfRestaurant.sd_setImage(with: url, placeholderImage: UIImage(named: "placeHolderRestraunt"), options: .retryFailed)
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
