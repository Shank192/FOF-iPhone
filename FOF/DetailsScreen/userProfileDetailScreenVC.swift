//
//  userProfileDetailScreenVC.swift
//  FOF

import UIKit

class userProfileDetailScreenVC: UIViewController
    ,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var startTime = Timer()
    @IBOutlet weak var nslcHightOfCollView: NSLayoutConstraint!
    @IBOutlet weak var collectionViewProfileImages: UICollectionView!
    @IBOutlet weak var collectionViewTestBuds: UICollectionView!
    @IBOutlet weak var collectionViewFood: UICollectionView!
    var arrTestBudsData = ["Italian","Chienese","Punjabi","Continetal","Goan","Greek","Backery","American","Cafe","Dessert","Coffee and Tea"]
    var arrOfImages = ["rachel.jpg","Mens.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewTestBuds.layoutIfNeeded()
        nslcHightOfCollView.constant = self.collectionViewTestBuds.contentSize.height + 10
        // Do any additional setup after loading the view.
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
            cell.imgViewOtherUserProfilePic.image = UIImage(named: arrOfImages[indexPath.row])
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
    }
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }

}
