//
//  nearByFriendsScreenVC.swift
//  FOF
//


import UIKit

class nearByFriendsScreenVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewNearByFrnds: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
         wsSetFriendsList()
    }
    
     // MARK: - Button Actions
    @IBAction func btnFoodAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "foodSearchScreenVC") as! foodSearchScreenVC
        
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any) {
        
    }
    
    @IBAction func btnFilterAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "filterScreenVC") as! filterScreenVC
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnSingleToggleAct(_ sender: Any) {
         let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByRestaurantsScreenVC") as! nearByRestaurantsScreenVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(obj, animated: false)
    }
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! testBudsCollectionViewCell
        
        cell.lblFriendName.text = "William Hibbler"
        cell.lblDistance.setTitle("5 km", for: .normal)
        cell.imgViewFriendProfile.cornerRadius = cell.imgViewFriendProfile.frame.width/2
        cell.imgViewFriendProfile.clipsToBounds = true
        
        cell.imgViewFriendProfile.image = UIImage(named: "Mens.jpg")
        cell.imgViewMutualFriend.cornerRadius = cell.imgViewMutualFriend.frame.width/2
        cell.imgViewMutualFriend.clipsToBounds = true
        cell.imgViewMutualFriend.image = UIImage(named: "Wavy.jpg")
        cell.viewMatchProfileRate.value = 50
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height:  self.collectionViewNearByFrnds.frame.height)
    
    }
    // MARK: - webService
    func wsSetFriendsList(){
            let param = ["action":"myfriends","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID)]
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
                //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if success == true {
                    if (response.object(forKey: "data") != nil)  {
                        
                        
                        
                    }
                } else if response.object(forKey: "message") != nil {
                    //self.view.makeToast(response.object(forKey: "message") as! String)
                }
                    
                else {
                    if response.object(forKey: "message") != nil {
                        //self.view.makeToast(response.object(forKey: "message") as! String)
                    }
                }})}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
