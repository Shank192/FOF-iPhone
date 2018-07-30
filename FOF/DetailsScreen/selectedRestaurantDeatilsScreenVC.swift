//
//  selectedRestaurantDeatilsScreenVC.swift
//  FOF
//
//

import UIKit

class selectedRestaurantDeatilsScreenVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewProfileImages: UICollectionView!
    var startTime = Timer()
    @IBOutlet weak var imgPrsnGiveReview: UIImageView!
    var arrOfImages = ["res.jpeg","rest.jpg","Restro.jpg","res.jpg"]
    var arrOfRestaurantData = [String:AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPrsnGiveReview.cornerRadius = imgPrsnGiveReview.frame.width/2
        imgPrsnGiveReview.clipsToBounds = true
        imgPrsnGiveReview.image = UIImage(named: "Mens.jpg")
        print(arrOfRestaurantData)
        // Do any additional setup after loading the view.
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
    
   
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInviteFrndAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "chatScreenVC") as! chatScreenVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    func startTimer() {
     startTime = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        cell.imgViewOfRestaurant.image = UIImage(named: arrOfImages[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewProfileImages.frame.width, height: self.collectionViewProfileImages.frame.height)
        
    }
}
