//
//  testBudsCollectionViewCell.swift
//  FOF
//

//

import UIKit
import MBCircularProgressBar

class testBudsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTestbudsName: UILabel!
    
    //NearByFriendsScreen
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgViewFriendProfile: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var lblDistance: UIButton!
    @IBOutlet weak var imgViewMutualFriend: UIImageView!
    @IBOutlet weak var viewMatchProfileRate: MBCircularProgressBarView!
    @IBOutlet weak var lblMutualFriend: UILabel!
    @IBOutlet weak var btnMEssage: UIButton!
    
    //NearByRestaurants
    @IBOutlet weak var imgViewRestaurants: UIImageView!
    @IBOutlet weak var lblRestroName: UILabel!
    @IBOutlet weak var lblOpenOrClose: UILabel!
    @IBOutlet weak var lblAwayTiming: UILabel!
    @IBOutlet weak var lblDistanceFromRestro: UIButton!
    
    //FoodSearchScreenVC
    @IBOutlet weak var imgViewFoodRestro: UIImageView!
    @IBOutlet weak var lblSearchFood: UILabel!
    @IBOutlet weak var btnFoodDistanceOut: UIButton!
    @IBOutlet weak var btnFoodDistanceForCarOut: UIButton!
    
    
    //Selected Restro Details
    @IBOutlet weak var imgViewOfRestaurant: UIImageView!
    
    //User Details
    @IBOutlet weak var imgViewOfProfilePic: UIImageView!
    
    //Cuisine
    @IBOutlet weak var lblCuisineName: UILabel!
    
    //userProfileDetail
    @IBOutlet weak var imgViewOtherUserProfilePic: UIImageView!
    @IBOutlet weak var lblOtherPersonTestbudName: UILabel!
    @IBOutlet weak var imgOtherPrsnRestraunt: UIImageView!
    @IBOutlet weak var lblOtherRestrauntName: UILabel!
    @IBOutlet weak var btnOtherPrsnWalkingOut: UIButton!
    @IBOutlet weak var btnOtherPrsnCarOut: UIButton!
    
}
