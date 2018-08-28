//
//  filterScreenVC.swift
//  FOF
//
//

import UIKit
import MBProgressHUD

class filterScreenVC: UIViewController {
    
    @IBOutlet weak var rangeSlider: NMRangeSlider!
    @IBOutlet weak var rangeDistanceSlider: UISlider!
    
//    @IBOutlet weak var btnLowerAgeOut: UIButton!
   // @IBOutlet weak var btnHigherAgeOut: UIButton!
//    @IBOutlet weak var btnFriendsOut: UIButton!
//    @IBOutlet weak var btnNearByPeopleOut: UIButton!
    @IBOutlet weak var btnMaleOut: UIButton!
    @IBOutlet weak var btnFemaleOut: UIButton!
    @IBOutlet weak var btnLGBTOut: UIButton!
   
    @IBOutlet weak var lblGenderLimit: UILabel!
    @IBOutlet weak var lblAgeLimit: UILabel!
    @IBOutlet weak var lblDistanceUnitOut: UILabel!
    @IBOutlet weak var lblMaleOut: UILabel!
    @IBOutlet weak var lblLgbtOut: UILabel!
    @IBOutlet weak var lblFemaleOut: UILabel!
    
    var strGender = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.isFriend){
//            btnFriendsOut.isSelected = true
//        }else{
//            btnNearByPeopleOut.isSelected = true
//        }
        if let range = String(describing:UserDefaults.standard.object(forKey: "strDistance")!) as? String{
            lblDistanceUnitOut.text = "\(range) mi"
            rangeDistanceSlider.setValue(Float(range)!, animated: false)
        }
        if let gender = UserDefaults.standard.object(forKey: Constants.UserDefaults.gender) as? String{
            strGender = gender
            switch gender{
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
        configureMetalTheme(slider: rangeSlider)
        setSlider()
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
        if let str3 = UserDefaults.standard.object(forKey: "strLowerValue") as? String{
            rangeSlider .lowerValue = Float(Int(str3)! - 16)
            if let str2 = UserDefaults.standard.object(forKey: "strUpperValue") as? String{
                lblAgeLimit.text = "\(str3) - \(str2) Years"
                rangeSlider.upperValue = Float(Int(str2)! - 16)
            }}
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
        UserDefaults.standard.set(strLowerValue, forKey:"strLowerValue")
        UserDefaults.standard.set(strUpperValue, forKey:"strUpperValue")
       // btnHigherAgeOut.setTitle("  \(strUpperValue) Years  ", for: .normal)
       // btnLowerAgeOut.setTitle("  \(strLowerValue) Years  ", for: .normal)
        lblAgeLimit.text = "\(strLowerValue) - \(strUpperValue) Years"
    }
   
    @IBAction func rangeSlider(_ sender: Any) {
        
        lblDistanceUnitOut.text = "\(Int(rangeDistanceSlider.value)) mi"
        //UserDefaults.standard.set(Int(rangeDistanceSlider.value), forKey:"strDistance")

    }
    
    @IBAction func btnCloseAct(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Cancel"), object: nil)
    }
    @IBAction func btnApplyAct(_ sender: Any) {
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
        UserDefaults.standard.set(strGender, forKey: Constants.UserDefaults.gender)
       
        
        let dictEditProfilePara = ["action":"editprofile","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID),"showme":strGender,"distance_unit":"miles","search_min_age": UserDefaults.standard.object(forKey:"strLowerValue") as! String,"search_max_age":UserDefaults.standard.object(forKey:"strUpperValue") as! String,"search_distance":lblDistanceUnitOut.text,"isreviewed":(0),"fields":"showme,search_min_age,distance_unit,search_max_age,search_distance,isreviewed"]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if success == true
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "Cancel"), object: nil)
            }
            
        }
        
       
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
