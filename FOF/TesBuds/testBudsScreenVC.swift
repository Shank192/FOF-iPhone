//
//  testBudsScreenVC.swift
//  FOF
//

//

import UIKit

class testBudsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var testBudsCollectionView: UICollectionView!
    var arrTestBudsData = ["Italian","Chienese","Punjabi","Continetal","Goan","Greek","Backery","American","Cafe","Dessert","Coffee and Tea"]
    var sizingCell = testBudsCollectionViewCell()
    var size = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTestBudsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
       
        cell.lblTestbudsName.text = arrTestBudsData[indexPath.row]
         size = cell.lblTestbudsName.intrinsicContentSize.width
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = (arrTestBudsData[indexPath.row] as NSString).size(withAttributes: nil)
        
        let number:Double = Double(size.width)
        return CGSize(width: number.rounded() + 30, height: 32)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
