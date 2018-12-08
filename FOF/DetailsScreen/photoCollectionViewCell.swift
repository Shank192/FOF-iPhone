//
//  photoCollectionViewCell.swift
//  FOF
//
//  Created by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class photoCollectionViewCell: UICollectionViewCell {
    
    //sentResataurant
    
    @IBOutlet weak var imgViewRestaurant: UIImageView!
    @IBOutlet weak var lblRestaurant: UILabel!
    @IBOutlet weak var lblTimeRestaurant: UILabel!
    @IBOutlet weak var btnTickMarkOut: UIButton!
   
    @IBOutlet weak var viewBlure: UIView!
    @IBOutlet weak var viewBack: UIView!
    //photoEdit
    @IBOutlet weak var btnEditPhoto: UIButton!
    @IBOutlet weak var imgViewMale: UIImageView!
    //SentRequest
    
    @IBOutlet weak var viewBackCard: UIView!
    @IBOutlet weak var imgFrndRestro: UIImageView!
    
    @IBOutlet weak var lblFrndRestroName: UILabel!
    
    @IBOutlet weak var btnStar1Out: UIButton!
    
    @IBOutlet weak var btnStar2Out: UIButton!
    
    @IBOutlet weak var btnStar3Out: UIButton!
    
    @IBOutlet weak var btnStar4Out: UIButton!
    
    
    @IBOutlet weak var btnStar5Out: UIButton!
    
    
    override func awakeFromNib() {
        initialSetup()
    }
    func initialSetup(){
      if  let str = Constants.GlobalConstants.appDelegate.userDetail.profilepic1 as? String{
        if str != ""
        {
//            self.imgViewMale.sd_setImage(with: URL.init(string: str)!, placeholderImage: UIImage.init(named: "male"))
        }
       
        }
    }
}
