//
//  photoCollectionViewCell.swift
//  FOF
//
//  Created by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class photoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgViewMale: UIImageView!
    
    override func awakeFromNib() {
        initialSetup()
    }
    func initialSetup(){
      if  let str = Constants.GlobalConstants.appDelegate.userDetail.profilepic1 as? String{
        self.imgViewMale.sd_setImage(with: URL.init(string: str), placeholderImage: UIImage.init(named: "male"))
        }
    }
}
