//
//  chatTableviewCell.swift
//  FOF
//
//

import UIKit

class chatTableviewCell: UITableViewCell {
    @IBOutlet weak var btnAcceptRequestOut: UIButton!
    @IBOutlet weak var btnCancelRequestOut: UIButton!
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var btnNotificationOut: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    //Start Chat
    @IBOutlet weak var imgViewProfilePicChat: UIImageView!
    @IBOutlet weak var lblContactNameChat: UILabel!
    @IBOutlet weak var btnCheckBoxOut: UIButton!
    
    //Group chat
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblContactNameGroup: UILabel!
    @IBOutlet weak var btnCrossOut: UIButton!
   
    //Conversation screen
    
    //sender
    
    @IBOutlet weak var imgSenderReadTick: UIButton!
    @IBOutlet weak var lblMessages: UILabel!
    @IBOutlet weak var imgSenderDp: UIImageView!
    @IBOutlet weak var lblSenderTime: UILabel!
    //restro
    
    @IBOutlet weak var lblRestroTime: UILabel!
    @IBOutlet weak var imgReadRestroTick: UIButton!
    @IBOutlet weak var imgRestro: UIImageView!
    @IBOutlet weak var lblRestroName: UILabel!
    @IBOutlet weak var lblRestroAddress: UILabel!
    @IBOutlet weak var btnSta1Out: UIButton!
    @IBOutlet weak var btnSta5Out: UIButton!
    @IBOutlet weak var btnSta4Out: UIButton!
    @IBOutlet weak var btnSta3Out: UIButton!
    @IBOutlet weak var btnSta2Out: UIButton!
    
    //receiver
    
    @IBOutlet weak var imgReadTick: UIButton!
    @IBOutlet weak var lblReceiverTime: UILabel!
    @IBOutlet weak var imgReceiverDp: UIImageView!
    @IBOutlet weak var lblReceiverMessage: UILabel!
    //Review screen
    
    @IBOutlet weak var lblReviewrName: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var imgViewReviewer: UIImageView!
    @IBOutlet weak var btnStar1Out: UIButton!
    
    @IBOutlet weak var btnStar2Out: UIButton!
    
    @IBOutlet weak var btnStar3Out: UIButton!
    
    @IBOutlet weak var btnStar4Out: UIButton!
    
    @IBOutlet weak var btnStar5Out: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
