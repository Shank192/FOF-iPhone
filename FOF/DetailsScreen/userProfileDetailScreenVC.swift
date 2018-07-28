//
//  userProfileDetailScreenVC.swift
//  FOF

import UIKit

class userProfileDetailScreenVC: UIViewController
    ,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var startTime = Timer()
    @IBOutlet weak var viewRecomendedRest: UIView!
    @IBOutlet weak var constHeightOfViewRecomendedRest: NSLayoutConstraint!
    @IBOutlet weak var nslcHightOfCollView: NSLayoutConstraint!
    @IBOutlet weak var collectionViewProfileImages: UICollectionView!
    @IBOutlet weak var collectionViewTestBuds: UICollectionView!
    @IBOutlet weak var collectionViewFood: UICollectionView!
    
    @IBOutlet weak var lblRelationShipStatus: UITextField!
    @IBOutlet weak var lblOccupation: UITextField!
    @IBOutlet weak var lblGender: UITextField!
    @IBOutlet weak var lblEducation: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblImageCount: UILabel!
    
    @IBOutlet weak var lblAbout: UILabel!
    
    var isShowRecomended = false
    var arrTestBudsData = [String]()
    var arrOfImages = [String]()
    var UserDetailData = NSDictionary()
    @IBOutlet weak var lblName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewTestBuds.layoutIfNeeded()
        nslcHightOfCollView.constant = 0
        
        if isShowRecomended == true
        {
            self.constHeightOfViewRecomendedRest.constant = 230
            self.viewRecomendedRest.isHidden = false
        }
        else
        {
            self.constHeightOfViewRecomendedRest.constant = 0
            self.viewRecomendedRest.isHidden = true
        }
        
        if let testbuds = UserDetailData.object(forKey: "testbuds") as? String
        {
            arrTestBudsData = (testbuds as NSString).components(separatedBy: ",")
            self.collectionViewTestBuds.reloadData()
            
        }
        
        for i in 0..<9 {
            
            //  NSLog(@"%d",i);
            let keyName = "profilepic\(i+1)"
            if let imageName = UserDetailData.object(forKey: keyName) as? String
            {
                if !((imageName as NSString).isKind(of: NSNull.self)) && imageName != ""
                {
                    self.arrOfImages.append(imageName)
                }
            }
            
            self.collectionViewProfileImages.reloadData()
        }
        
        
        
        self.startTimer()
        
        if let about_me = UserDetailData.object(forKey: "about_me") as? String
        {
            self.lblAbout.text = about_me
        }
        
        if let education = UserDetailData.object(forKey: "education") as? String
        {
            self.lblEducation.text = education
        }
        
        if let gender = UserDetailData.object(forKey: "gender") as? String
        {
            self.lblGender.text = gender
        }
        
        if let first_name = UserDetailData.object(forKey: "first_name") as? String,let last_name = UserDetailData.object(forKey: "last_name") as? String
        {
            self.lblName.text = "\(first_name) \(last_name)"
        }
        
        if let relationship = UserDetailData.object(forKey: "relationship") as? String
        {
            self.lblRelationShipStatus.text = relationship
        }
        
        if let location_string = UserDetailData.object(forKey: "location_string") as? String
        {
            self.lblLocation.text = location_string
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        print(self.collectionViewTestBuds.contentSize.height)
        nslcHightOfCollView.constant = self.collectionViewTestBuds.contentSize.height + 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackAct(_ sender: Any) {
self.navigationController?.popViewController(animated: true)
    }
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewProfileImages{
            return arrOfImages.count
        }else if collectionView == collectionViewFood{
            return 9
        }else{
            return arrTestBudsData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        if collectionView == collectionViewProfileImages{
            cell.imgViewOtherUserProfilePic.sd_setImage(with: URL.init(string: arrOfImages[indexPath.row]), placeholderImage: UIImage.init(named: "male"), options: .continueInBackground)
        }else if collectionView == collectionViewTestBuds{
            cell.lblOtherPersonTestbudName.text =  arrTestBudsData[indexPath.row]
        }else{
            cell.lblOtherRestrauntName.text = "Le Bernardin"
            cell.btnOtherPrsnWalkingOut.setTitle("15 km", for: .normal)
            cell.btnOtherPrsnCarOut.setTitle("15 km", for: .normal)
            cell.imgOtherPrsnRestraunt.image = UIImage(named: "rest.jpg")
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProfileImages{
            return CGSize(width: self.collectionViewProfileImages.frame.width, height: self.collectionViewProfileImages.frame.height + 20)
        }else if collectionView == collectionViewTestBuds{
            let size = (arrTestBudsData[indexPath.row] as NSString).size(withAttributes: nil)
            let number:Double = Double(size.width)
            
            return CGSize(width: number.rounded() + 30, height: 30)
        }else{
                return CGSize(width: 155, height: collectionViewFood.frame.height)
        }
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
        
        let numOf = collectionViewProfileImages.contentOffset.x/self.collectionViewProfileImages.frame.size.width
        
        self.lblImageCount.text = "\(Int(numOf)+1)/\(self.arrOfImages.count)"
    }
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }

}
