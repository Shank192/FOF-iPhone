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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
