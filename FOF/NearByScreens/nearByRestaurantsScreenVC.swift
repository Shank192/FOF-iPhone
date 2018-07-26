//
//  nearByRestaurantsScreenVC.swift
//  FOF
//


import UIKit

class nearByRestaurantsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

@IBOutlet weak var collectionViewNearByRestaurants: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Button Actions
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        
    }
    
    @IBAction func btnFriendToggleAct(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromLeft
        navigationController?.view.layer.add(transition, forKey:kCATransition)
        let _ = navigationController?.popViewController(animated: false)
    }
    @IBAction func btnFilterAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        cell.lblRestroName.text = "Carmine's Italian Restaurant"
        cell.lblAwayTiming.text = "5 Min from you"
        cell.lblOpenOrClose.text = "Open"
        cell.lblDistanceFromRestro.setTitle("200 W 44th St, New York", for: .normal)
        
        cell.imgViewRestaurants.image = UIImage(named: "Restro.jpg")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height:  self.collectionViewNearByRestaurants.frame.height)
        
    }
}
