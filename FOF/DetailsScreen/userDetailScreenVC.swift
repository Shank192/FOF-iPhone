//
//  userDetailScreenVC.swift
//  FOF
//
//

import UIKit

class userDetailScreenVC: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var startTime = Timer()
    @IBOutlet weak var nslcHightOfCollView: NSLayoutConstraint!
    @IBOutlet weak var collectionViewProfileImages: UICollectionView!
    @IBOutlet weak var collectionViewCuisine: UICollectionView!
    
    
    @IBOutlet weak var lblRelationShipStatus: UITextField!
    @IBOutlet weak var lblOccupation: UITextField!
    @IBOutlet weak var lblGender: UITextField!
    @IBOutlet weak var lblEducation: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblImageCount: UILabel!
    
    @IBOutlet weak var lblAbout: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
   
    var isShowRecomended = false
    var arrTestBudsData = [String]()
    var arrOfImages = [String]()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        startTimer()
        collectionViewCuisine.layoutIfNeeded()
        nslcHightOfCollView.constant = self.collectionViewCuisine.contentSize.height + 10

        if let arrtestbuds = UserDefaults.standard.object(forKey: Constants.UserDefaults.MyTestBuds) as? NSArray
        {
            arrTestBudsData.removeAll()
            for (_,i)  in arrtestbuds.enumerated()
            {
                let dict = i as! NSDictionary
                
                if let name = dict.object(forKey: "name") as? String
                {
                    arrTestBudsData.append(name)
                }
            }
            
            self.collectionViewCuisine.reloadData()

        }
        

        if self.app.userDetail.firstName == nil
        {
            if let dataDict = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData)
            {
                self.app.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
            }
        }
        
        print(self.app.userDetail.firstName)
        if self.app.userDetail.profilepic1 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic1)
        }
        else if self.app.userDetail.profilepic2 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic2)
        }
        else if self.app.userDetail.profilepic3 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic3)
        }
        else if self.app.userDetail.profilepic4 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic4)
        }
        else if self.app.userDetail.profilepic5 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic5)
        }
        else if self.app.userDetail.profilepic6 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic6)
        }
        else if self.app.userDetail.profilepic7 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic7)
        }
        else if self.app.userDetail.profilepic8 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic8)
        }
        else if self.app.userDetail.profilepic9 != ""
        {
            self.arrOfImages.append(self.app.userDetail.profilepic9)
        }
        else
        {
            if arrOfImages.count == 0
            {
                arrOfImages.append("NoImage")
            }
        }




        self.lblName.text = "\(self.app.userDetail.firstName!) \(self.app.userDetail.lastName!)"
        self.lblEducation.text = self.app.userDetail.education
        self.lblGender.text = self.app.userDetail.gender.capitalized
        self.lblOccupation.text = self.app.userDetail.occupation
        self.lblLocation.text = self.app.userDetail.locationString
        self.lblAbout.text = self.app.userDetail.aboutMe
    }
    override func viewDidLayoutSubviews() {
        
        print(self.collectionViewCuisine.contentSize.height)
        nslcHightOfCollView.constant = self.collectionViewCuisine.contentSize.height + 10
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        startTime.invalidate()
    }
  
 
    @IBAction func btnEditAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "userProfileEditScreenVC") as! userProfileEditScreenVC
       
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewProfileImages{
            return arrOfImages.count
        }else{
            return arrTestBudsData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        if collectionView == collectionViewProfileImages{
            if arrOfImages[indexPath.row] == "NoImage" || arrOfImages[indexPath.row] == ""
            {
                cell.imgViewOfProfilePic.image = UIImage.init(named: "male")
            }
            else
            {
                cell.imgViewOfProfilePic.sd_setImage(with: URL.init(string: arrOfImages[indexPath.row]), placeholderImage: UIImage.init(named: "male"), options: .continueInBackground)
            }
            
            
        }else{
             cell.lblCuisineName.text =  arrTestBudsData[indexPath.row]
        }
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProfileImages{
           return CGSize(width: self.collectionViewProfileImages.frame.width, height: self.collectionViewProfileImages.frame.height + 20)
        }else{
            let size = (arrTestBudsData[indexPath.row] as NSString).size(withAttributes: nil)
            let number:Double = Double(size.width)
            
            return CGSize(width: number.rounded() + 30, height: 30)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
