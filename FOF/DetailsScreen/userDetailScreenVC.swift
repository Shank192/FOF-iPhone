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
    var arrTestBudsData = ["Italian","Chienese","Punjabi","Continetal","Goan","Greek","Backery","American","Cafe","Dessert","Coffee and Tea"]
    var arrOfImages = ["rachel.jpg","Mens.jpg"]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        startTimer()
        collectionViewCuisine.layoutIfNeeded()
        nslcHightOfCollView.constant = self.collectionViewCuisine.contentSize.height + 10
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        startTime.invalidate()
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
             cell.imgViewOfProfilePic.image = UIImage(named: arrOfImages[indexPath.row])
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
    }
    
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
