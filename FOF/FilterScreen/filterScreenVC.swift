//
//  filterScreenVC.swift
//  FOF
//
//

import UIKit


class filterScreenVC: UIViewController {
    
    @IBOutlet weak var rangeSlider: NMRangeSlider!
    @IBOutlet weak var rangeDistanceSliderFriend: UISlider!
    @IBOutlet weak var rangeDistanceSliderResturant: UISlider!
    
//    @IBOutlet weak var btnLowerAgeOut: UIButton!
   // @IBOutlet weak var btnHigherAgeOut: UIButton!
//    @IBOutlet weak var btnFriendsOut: UIButton!
//    @IBOutlet weak var btnNearByPeopleOut: UIButton!
    @IBOutlet weak var btnMaleOut: UIButton!
    @IBOutlet weak var btnFemaleOut: UIButton!
    @IBOutlet weak var btnLGBTOut: UIButton!
   
    @IBOutlet weak var lblGenderLimit: UILabel!
    @IBOutlet weak var lblAgeLimit: UILabel!
    @IBOutlet weak var lblDistanceUnitOutFriend: UILabel!
    @IBOutlet weak var lblDistanceUnitOutResturant: UILabel!
    @IBOutlet weak var lblMaleOut: UILabel!
    @IBOutlet weak var lblLgbtOut: UILabel!
    @IBOutlet weak var lblFemaleOut: UILabel!
    
    @IBOutlet weak var SwitchShowOnlyyFriend: UISwitch!
    @IBOutlet weak var viewFilterResturant: UIView!
    @IBOutlet weak var viewFilterFriend: UIView!
    
    
    var strGender = String()
    
    var miInt = 0
    var metersInt = 0
    var AgeLowerValue = 16
    var AgeUpperValue = 40
    var isFilterFriend = false
    
    var isKM = false
    var DistanceUnit = "mi."
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isFriend){
//            btnFriendsOut.isSelected = true
//        }else{
//            btnNearByPeopleOut.isSelected = true
//        }
        
        SwitchShowOnlyyFriend.addTarget(self, action: #selector(SwitchActionShowFriend(sender:)), for: .valueChanged)
        
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isFriend)
        {
            self.SwitchShowOnlyyFriend.isOn = true
        }
        else
        {
            self.SwitchShowOnlyyFriend.isOn = false
        }
        
        if self.app.isFilterFriend == true
        {
            self.viewFilterFriend.isHidden = false
            self.viewFilterResturant.isHidden = true
        }
        else
        {
            self.viewFilterFriend.isHidden = true
            self.viewFilterResturant.isHidden = false
        }
       
        if UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) == nil
        {
            UserDefaults.standard.set("20000", forKey: Constants.UserDefaults.FilterDistance)
            UserDefaults.standard.synchronize()
        }
        
        
        if let dict = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSDictionary
        {
            if let distance_unit = dict.object(forKey: "distance_unit") as? String
            {
                if distance_unit == "miles"
                {
                    self.isKM = false
                    self.DistanceUnit = "mi."
                }
                else
                {
                    self.isKM = true
                    self.DistanceUnit = "km."
                }
            }
        }
        
        
        let range = Int("\(UserDefaults.standard.object(forKey: Constants.UserDefaults.FilterDistance) ?? "20000")")!
        
        if range == 0
        {
            self.lblDistanceUnitOutResturant.text = "0 \(self.DistanceUnit)"
            self.lblDistanceUnitOutFriend.text = "0 \(self.DistanceUnit)"
            rangeDistanceSliderResturant.setValue(0, animated: false)
            rangeDistanceSliderFriend.setValue(0, animated: false)
            
            miInt = 0
            metersInt = 0
        }
        else
        {
            metersInt = range
            if self.isKM == true
            {
                miInt = metersInt/1000
            }
            else
            {
                miInt = metersInt/1610
            }
            
            
            self.lblDistanceUnitOutResturant.text = "\(miInt) \(self.DistanceUnit)"
            self.lblDistanceUnitOutFriend.text = "\(miInt) \(self.DistanceUnit)"
            rangeDistanceSliderResturant.setValue(Float(miInt), animated: false)
            rangeDistanceSliderFriend.setValue(Float(miInt), animated: false)
        }
        
        if let dict = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSDictionary
        {
            if let show_friends = dict.object(forKey: "show_friends")
            {
                if "\(show_friends)" == "1"
                {
                    self.SwitchShowOnlyyFriend.isOn = true
                    
                    UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isFriend)
                }
                else
                {
                    self.SwitchShowOnlyyFriend.isOn = false
                    UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isFriend)
                }
                UserDefaults.standard.synchronize()
            }
            if let showme = dict.object(forKey: "showme") as? String
            {
                strGender = showme
                
                switch strGender{
                case "all" :
                    
                    btnLGBTOut.isSelected = true
                    btnMaleOut.isSelected = true
                    btnFemaleOut.isSelected = true
                    
                    lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    break
                    
                case "male" :
                    btnLGBTOut.isSelected = false
                    btnMaleOut.isSelected = true
                    btnFemaleOut.isSelected = false
                    
                    lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblFemaleOut.textColor = UIColor.black
                    lblLgbtOut.textColor = UIColor.black
                    break
                case "female" :
                    btnLGBTOut.isSelected = false
                    btnMaleOut.isSelected = false
                    btnFemaleOut.isSelected = true
                    
                    lblMaleOut.textColor = UIColor.black
                    lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblLgbtOut.textColor = UIColor.black
                    break
                case "lgbt" :
                    btnLGBTOut.isSelected = true
                    btnMaleOut.isSelected = false
                    btnFemaleOut.isSelected = false
                    
                    lblMaleOut.textColor = UIColor.black
                    lblFemaleOut.textColor = UIColor.black
                    lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    break
                case "lgbt,male" :
                    btnLGBTOut.isSelected = true
                    btnMaleOut.isSelected = true
                    btnFemaleOut.isSelected = false
                    
                    lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblFemaleOut.textColor = UIColor.black
                    lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    
                    break
                case "lgbt,femal" :
                    btnLGBTOut.isSelected = true
                    btnMaleOut.isSelected = false
                    btnFemaleOut.isSelected = true
                    
                    lblMaleOut.textColor = UIColor.black
                    lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    break
                case "female,mal" :
                    btnLGBTOut.isSelected = false
                    btnMaleOut.isSelected = true
                    btnFemaleOut.isSelected = true
                    
                    lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                    lblLgbtOut.textColor = UIColor.black
                    break
                default:
                    break
                    
                }
                
            }
            
            
            if let showsearch_max_ageme = dict.object(forKey: "search_max_age"),let search_min_age = dict.object(forKey: "search_min_age")
            {
                if "\(showsearch_max_ageme)" != "" && "\(showsearch_max_ageme)" != "0"
                {
                    self.AgeUpperValue = Int("\(showsearch_max_ageme)")!
                }
                
                if "\(search_min_age)" != "" && "\(search_min_age)" != "0"
                {
                    self.AgeLowerValue = Int("\(search_min_age)")!
                }
                
            }
        }
        

        configureMetalTheme(slider: rangeSlider)
        setSlider()
    }
    
    @objc func SwitchActionShowFriend(sender : UISwitch)
    {
        if sender.isOn
        {
            self.SwitchShowOnlyyFriend.isOn = true
        }
        else
        {
            self.SwitchShowOnlyyFriend.isOn = false
        }
    }
    
    
    func configureMetalTheme(slider : NMRangeSlider){
        var image = UIImage(named: "imgSeprator")
        //slider back ground image
        let Img : UIImage = makeImageForTrackColor(aColor: Utility.UIColorFromHex(0xB5B5B5), height: 3, width: NSInteger(self.view.frame.size.width - 32))
        image = Img.resizableImage(withCapInsets: UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0))
        slider.trackBackgroundImage = image;
        //slider track image
        image =  makeImageForTrackColor(aColor: Utility.UIColorFromHex(0xAC192E), height: 2, width: 30)
        image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0))
        slider.trackImage = image;
        //slider track Crossoverd image
        image =  makeImageForTrackColor(aColor: Utility.UIColorFromHex(0xAC192E), height: 2, width: 30)
        image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0))
        slider.trackCrossedOverImage = image;
        //slider poiter image
        image = UIImage(named: "sliderIcon")
        image = image?.withAlignmentRectInsets(UIEdgeInsetsMake(-1, 2, 1, 2))
        slider.lowerHandleImageNormal = image;
        slider.upperHandleImageNormal = image;
        //slider highlighted image
        image = UIImage(named: "sliderIcon")
        image = image?.withAlignmentRectInsets(UIEdgeInsetsMake(-1, 2, 1, 2))
        slider.lowerHandleImageHighlighted = image;
        slider.upperHandleImageHighlighted = image;
    }
    func makeImageForTrackColor(aColor : UIColor, height : NSInteger,width : NSInteger) -> UIImage {
        let aView = UIView.init(frame: CGRect (x: 0, y: 0, width: width, height: height))
        aView.backgroundColor=aColor;
        UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.isOpaque, 0.0)
        aView.layer.render(in: UIGraphicsGetCurrentContext()!)
       let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func setSlider(){
        
        rangeSlider.maximumValue = 84
        rangeSlider.minimumRange = -100
       
        rangeSlider .lowerValue = Float(self.AgeLowerValue - 16)
        rangeSlider.upperValue = Float(self.AgeUpperValue - 16)
        
        lblAgeLimit.text = "\(self.AgeLowerValue) - \(self.AgeUpperValue) Years"
        
   
    }

//    @IBAction func btnFriendsAct(_ sender: Any) {
//        if btnFriendsOut.isSelected == true{
//            btnFriendsOut.isSelected = false
//            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isFriend)
//        }else{
//            btnFriendsOut.isSelected = true
//            btnNearByPeopleOut.isSelected = false
//            UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isFriend)
//        }
//
//    }
    
//    @IBAction func btnNearByPeopleAct(_ sender: Any) {
//        if btnNearByPeopleOut.isSelected == true{
//            btnNearByPeopleOut.isSelected = false
//            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isFriend)
//
//        }else{
//            btnNearByPeopleOut.isSelected = true
//            btnFriendsOut.isSelected = false
//            UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isFriend)
//        }
//    }
    
    
    @IBAction func btnMaleAct(_ sender: Any) {
        if btnMaleOut.isSelected == true{
            btnMaleOut.isSelected = false
            lblMaleOut.textColor = UIColor.black
        }else{
            btnMaleOut.isSelected = true
            //btnFemaleOut.isSelected = false
            //btnLGBTOut.isSelected = false
            lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
           // lblFemaleOut.textColor = UIColor.black
            //lblLgbtOut.textColor = UIColor.black

        }
    }
    
    @IBAction func btnFemaleAct(_ sender: Any) {
        if btnFemaleOut.isSelected == true{
            btnFemaleOut.isSelected = false
            lblFemaleOut.textColor = UIColor.black
        }else{
            //btnMaleOut.isSelected = false
           btnFemaleOut.isSelected = true
            //btnLGBTOut.isSelected = false
            //lblMaleOut.textColor = UIColor.black
            lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
            //lblLgbtOut.textColor = UIColor.black
        }
    }
    
    @IBAction func btnLGBTAct(_ sender: Any) {
        if btnLGBTOut.isSelected == true{
            btnLGBTOut.isSelected = false
            lblLgbtOut.textColor = UIColor.black
        }else{
            btnLGBTOut.isSelected = true
            lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
        }
    }

    @IBAction func scrollRangeSlider(_ sender: NMRangeSlider) {
        let intUpperValue = sender.upperValue
        let intLowerValue = sender.lowerValue
        let strUpperValue = "\(String(describing: Int(intUpperValue) + 16))"
        let strLowerValue =
        "\(String(describing: Int(intLowerValue) + 16))"
        
        self.AgeLowerValue = Int(intLowerValue) + 16
        self.AgeUpperValue = Int(intUpperValue) + 16
        

       // btnHigherAgeOut.setTitle("  \(strUpperValue) Years  ", for: .normal)
       // btnLowerAgeOut.setTitle("  \(strLowerValue) Years  ", for: .normal)
        lblAgeLimit.text = "\(strLowerValue) - \(strUpperValue) Years"
    }
   
    @IBAction func rangeSlider(_ sender: Any) {
        
        if self.app.isFilterFriend == true
        {
            lblDistanceUnitOutFriend.text = "\(Int(rangeDistanceSliderFriend.value)) \(self.DistanceUnit)"
            miInt = Int(rangeDistanceSliderFriend.value)
        }
        else
        {
            lblDistanceUnitOutResturant.text = "\(Int(rangeDistanceSliderResturant.value)) \(self.DistanceUnit)"
            miInt = Int(rangeDistanceSliderResturant.value)
        }
        
        
        if self.isKM == true
        {
            metersInt = miInt * 1000
        }
        else
        {
            metersInt = miInt * 1610
        }
        
        
    }
    
    @IBAction func btnCloseAct(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Cancel"), object: nil)
    }
    @IBAction func btnApplyAct(_ sender: Any) {
       
       //user_id,first_name,last_name,about_me,dob,gender,relationship,ethnicity,occupation,education , showme,search_min_age,search_max_age,distance_unit,search_distance,is_show_location,is_receive_messages_notifications,is_receive_invitation_notifications
        print(UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!)
        print(UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as! NSDictionary)
        if self.app.zomatoAPIuserKEy != nil
        {
            if let user_id = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),let ProfileData = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSDictionary
            {
                var param = [String :  AnyObject]()
                
                if self.app.isFilterFriend == true
                {
                    if btnLGBTOut.isSelected && btnFemaleOut.isSelected  && btnMaleOut.isSelected {
                        strGender = "all"
                    }else if btnLGBTOut.isSelected == false && btnFemaleOut.isSelected  && btnMaleOut.isSelected{
                        strGender = "female,male"
                    }else if btnFemaleOut.isSelected == false && btnLGBTOut.isSelected  && btnMaleOut.isSelected{
                        strGender = "lgbt,male"
                    }else if btnMaleOut.isSelected == false && btnLGBTOut.isSelected  && btnFemaleOut.isSelected{
                        strGender = "lgbt,female"
                    }else if btnLGBTOut.isSelected == false && btnFemaleOut.isSelected == false && btnMaleOut.isSelected{
                        strGender = "male"
                    }else if btnLGBTOut.isSelected == false && btnMaleOut.isSelected == false && btnFemaleOut.isSelected{
                        strGender = "female"
                    }else if btnFemaleOut.isSelected == false && btnMaleOut.isSelected == false && btnLGBTOut.isSelected{
                        strGender = "lgbt"
                    }else{
                        strGender = "all"
                    }
                    
                    
                    param = ["user_id":"\(user_id)","first_name":"\(ProfileData.object(forKey: "first_name") ?? "")","last_name":"\(ProfileData.object(forKey: "last_name") ?? "")","about_me":"\(ProfileData.object(forKey: "about_me") ?? "")","dob":"\(ProfileData.object(forKey: "dob") ?? "")","gender":"\(ProfileData.object(forKey: "gender") ?? "")","relationship":"\(ProfileData.object(forKey: "relationship") ?? "")","ethnicity":"\(ProfileData.object(forKey: "ethnicity") ?? "")","occupation":"\(ProfileData.object(forKey: "occupation") ?? "")","education":"\(ProfileData.object(forKey: "education") ?? "")", "showme":strGender,"search_min_age":self.AgeLowerValue,"search_max_age":self.AgeUpperValue,"distance_unit":"\(ProfileData.object(forKey: "distance_unit") ?? "")","search_distance":self.metersInt,"is_show_location":"\(ProfileData.object(forKey: "is_show_location") ?? "")","is_receive_messages_notifications":"\(ProfileData.object(forKey: "is_receive_messages_notifications") ?? "")","is_receive_invitation_notifications":"\(ProfileData.object(forKey: "is_receive_invitation_notifications") ?? "")","show_friends":self.SwitchShowOnlyyFriend.isOn] as [String : AnyObject]
                    
                }
                else
                {
                    param = ["user_id":"\(user_id)","first_name":"\(ProfileData.object(forKey: "first_name") ?? "")","last_name":"\(ProfileData.object(forKey: "last_name") ?? "")","about_me":"\(ProfileData.object(forKey: "about_me") ?? "")","dob":"\(ProfileData.object(forKey: "dob") ?? "")","gender":"\(ProfileData.object(forKey: "gender") ?? "")","relationship":"\(ProfileData.object(forKey: "relationship") ?? "")","ethnicity":"\(ProfileData.object(forKey: "ethnicity") ?? "")","occupation":"\(ProfileData.object(forKey: "occupation") ?? "")","education":"\(ProfileData.object(forKey: "education") ?? "")", "showme":"\(ProfileData.object(forKey: "showme") ?? "")","search_min_age":"\(ProfileData.object(forKey: "search_min_age") ?? "")","search_max_age":"\(ProfileData.object(forKey: "search_max_age") ?? "")","distance_unit":"\(ProfileData.object(forKey: "distance_unit") ?? "")","search_distance":self.metersInt,"is_show_location":"\(ProfileData.object(forKey: "is_show_location") ?? "")","is_receive_messages_notifications":"\(ProfileData.object(forKey: "is_receive_messages_notifications") ?? "")","is_receive_invitation_notifications":"\(ProfileData.object(forKey: "is_receive_invitation_notifications") ?? "")","show_friends":self.SwitchShowOnlyyFriend.isOn] as [String : AnyObject]
                }
                
                
                
                
                UserDefaults.standard.set(strGender, forKey: Constants.UserDefaults.gender)
                UserDefaults.standard.set(metersInt, forKey: Constants.UserDefaults.FilterDistance)
                UserDefaults.standard.set(self.SwitchShowOnlyyFriend.isOn, forKey: Constants.UserDefaults.isFriend)
                
                UserDefaults.standard.synchronize()
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.updateUserData, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    if success == true
                    {
                        
                        if let dataDict = response.object(forKey: "response_data") as? NSDictionary
                        {
                            Constants.GlobalConstants.appDelegate.userDetail = UserDetail.init(dictionary: dataDict as? [AnyHashable : Any])
                            UserDefaults.standard.set(dataDict, forKey: Constants.UserDefaults.ProfileData)
                            
                            if let tastebuds = dataDict.object(forKey: "testbuds") as? NSArray
                            {
                                UserDefaults.standard.set(tastebuds, forKey: Constants.UserDefaults.MyTestBuds)
                                UserDefaults.standard.synchronize()
                            }
                        }
                        
                        UserDefaults.standard.synchronize()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Cancel"), object: nil)
                    }
                    else
                    {
                        if let msg = response.object(forKey: "message") as? String
                        {
                            self.view.makeToast(msg)
                        }
                        else
                        {
                            self.view.makeToast("Something went to wrong. Please try after sometimes.")
                        }
                    }
                    
                    
                }
                
            }
        }
        else
        {
            self.app.getZomatoKEY { (success) in
                
                if success == true
                {
                    self.btnApplyAct(sender)
                }
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
