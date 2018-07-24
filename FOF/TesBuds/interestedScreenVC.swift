//
//  interestedScreenVC.swift
//  FOF
//


import UIKit

class interestedScreenVC: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionViewIntresetedTestBuds: UICollectionView!
    var arrTestBudsData = ["Italian","Chienese","Punjabi","Continetal","Goan","Greek","Backery","American","Cafe","Dessert","Coffee and Tea"]
    
    @IBOutlet weak var btnSingleOut: UIButton!
    
    @IBOutlet weak var btnGroupOut: UIButton!
    
    @IBOutlet weak var lblSingleOut: UILabel!
    
    @IBOutlet weak var lblGroupOut: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 // MARK: - Button action method
    
    @IBAction func btnSingleAct(_ sender: Any) {
    }
    
    @IBAction func btnGroupAct(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC  = mainStoryboard.instantiateViewController(withIdentifier: "FoFTabBarScreenVC") as! FoFTabBarScreenVC
        nextVC.selectedIndex = 1
        Constants.GlobalConstants.appDelegate.window?.rootViewController = nextVC
    }
    
    @IBAction func btnGrabABiteAct(_ sender: Any) {
        
        
    }
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTestBudsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        cell.lblTestbudsName.text = arrTestBudsData[indexPath.row]
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
