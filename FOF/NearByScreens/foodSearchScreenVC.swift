//
//  foodSearchScreenVC.swift
//  FOF
//


import UIKit

class foodSearchScreenVC: UIViewController , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionViewFoodSearch: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        cell.lblSearchFood.text = "Le Bernardin"
        cell.btnFoodDistanceOut.setTitle("15 km", for: .normal)
        cell.btnFoodDistanceForCarOut.setTitle("15 km", for: .normal)
        cell.imgViewFoodRestro.image = UIImage(named: "rest.jpg")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewFoodSearch.frame.width
            / 6 * 2.8, height: 197)
        
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
}
