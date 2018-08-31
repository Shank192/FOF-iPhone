//
//  sentRequestRestaurantScreenVC.swift
//  FOF
//
//  Created by 360dts on 30/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class sentRequestRestaurantScreenVC: UIViewController {

    var arrForRestaurants = [[String:AnyObject]]()
    
    @IBOutlet weak var imgFrnd: UIImageView!
    @IBOutlet weak var lblMessageDetail: UILabel!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var collectionViewFriendSuggestion: UICollectionView!
    var strMessage = String()
    var dictUserDetails = NSDictionary()
    
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var btnAcceptOut: UIButton!
    
    @IBOutlet weak var lblContinueChat: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnRejectOut: UIButton!
    var isSent = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessageDetail.text = strMessage
        viewAccept.isHidden = true
        btnAcceptOut.isHidden = true
        btnRejectOut.isHidden = true
        lblContinueChat.isHidden = true
        if let dict = dictUserDetails.object(forKey: "details") as? [[String:AnyObject]]{
            if let  strPicUrl = dict[0]["profilepic1"] as? String{
                let url = NSURL(string: strPicUrl)!  as URL
            imgFrnd.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
        }
        if let firstName = dict[0]["first_name"] as? String,let lastName = dict[0]["last_name"] as? String{
            lblFriendName.text = "\(firstName) \(lastName)"
            lblDetails.text = "\(firstName) \(lastName) has not shown interest in you yet"
        }
        }else{
            if let  strPicUrl = dictUserDetails.object(forKey: "profilepic1")! as? String{
                let url = NSURL(string: strPicUrl)!  as URL
                imgFrnd.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
            }
            if let firstName = dictUserDetails.object(forKey: "first_name") as? String,let lastName = dictUserDetails.object(forKey: "last_name") as? String{
                lblFriendName.text = "\(firstName) \(lastName)"
                lblDetails.text = "\(firstName) \(lastName) has not shown interest in you yet"
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAcceptAct(_ sender: Any) {
    }
    
    @IBAction func btnRejectAct(_ sender: Any) {
    }
 }
extension sentRequestRestaurantScreenVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! photoCollectionViewCell
            cell.viewBackCard.layer.shadowOpacity = 0.7
            cell.viewBackCard.layer.shadowOffset = CGSize.zero
            cell.viewBackCard.layer.shadowRadius = 3.0
            cell.viewBackCard.layer.shadowColor = UIColor.lightGray.cgColor
            
        
            if let dict1 = arrForRestaurants[indexPath.row]["RestaurantData"] as? NSDictionary{
                cell.lblFrndRestroName.text = dict1["name"] as? String
                if let photos = dict1["photos"] as? [[String:Any]]{
                    let strRefre = photos.first
                    let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
                    cell.imgFrndRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)}}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionViewFriendSuggestion.frame.width
            / 2) - 25, height: self.collectionViewFriendSuggestion.frame.height)
        
    }
  
}
