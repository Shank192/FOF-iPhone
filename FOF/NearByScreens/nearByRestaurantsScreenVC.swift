//
//  nearByRestaurantsScreenVC.swift
//  FOF
//


import UIKit
import GoogleMaps


class nearByRestaurantsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

@IBOutlet weak var collectionViewNearByRestaurants: UICollectionView!

    let rdistnceMng = RestDistanceManage()
    
    @IBOutlet weak var aMapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        rdistnceMng.delegate = self
        rdistnceMng.currentTotalCounts(0, nextPageToken: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView()
    {
        super.loadView()
        let mainBundle = Bundle.main
        let styleUrl = mainBundle.url(forResource: "style", withExtension: "json")
        
        //Set the map style by passing the URL for style.json.
        
        do
        {
            let style = try GMSMapStyle.init(contentsOfFileURL: styleUrl!)
            aMapView.mapStyle = style;
            aMapView.delegate=self;
            aMapView.isMyLocationEnabled = true;
        }
        catch
        {
            print("The style definition could not be loaded: %@", error);
        }
        
        
    }
    
    
    
    // MARK: - Button Actions
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        
    }
    
    @IBAction func btnFriendToggleAct(_ sender: Any) {
        
        let allviewController = self.navigationController?.viewControllers
        
        if allviewController![0].isKind(of: nearByRestaurantsScreenVC.self)
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByFriendsScreenVC") as! nearByFriendsScreenVC
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade;
            transition.subtype = kCATransitionFromRight;
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(obj, animated: false)
            
            
        }
        else
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            transition.subtype = kCATransitionFromLeft
            navigationController?.view.layer.add(transition, forKey:kCATransition)
            let _ = navigationController?.popViewController(animated: false)
            
        }
        
        
       
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
        
        cell.viewBack.layer.shadowOpacity = 0.7
        cell.viewBack.layer.shadowOffset = CGSize.zero
        cell.viewBack.layer.shadowRadius = 3.0
        cell.viewBack.layer.shadowColor = UIColor.lightGray.cgColor
        
        
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
    
    func reloadTableWithRestDetailArray(restDetailArray  : NSArray){
        
//        [self addToMutableRestaurantArrayFromNewRestaArray:restDetailArray];
//        [[HUDIndicatorManage shredHudIndicator] stopHudIndicator];
//        [self reloadWithSorting];
    }
    
    
   
    
}

extension nearByRestaurantsScreenVC : GMSMapViewDelegate
{
    
}

extension nearByRestaurantsScreenVC : GMUClusterManagerDelegate
{
    
}

extension nearByRestaurantsScreenVC : RestDistanceManageDelegate
{
    func finalRestaurants(withDistance restaurants: [Any]!, andTokenstring token: String!) {
        
        if restaurants.count == 0 {
            self.collectionViewNearByRestaurants.reloadData()
        }else{
            self.reloadTableWithRestDetailArray(restDetailArray: restaurants as NSArray)
        }
        
    }
    
    func stopIndicator() {
        
    }
    
    func reloadAllRestaurants() {
        
    }
    
    func setToZeroResults() {
        
    }
    
    
}
