//
//  preferencesCollectionViewCell.swift
//  FOF
//
//  Created by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class preferencesCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var btnMaleOut: UIButton!
    
    @IBOutlet weak var btnFemaleOut: UIButton!
    
    @IBOutlet weak var btnLgbtOut: UIButton!
    
    @IBOutlet weak var locationSwitchOut: UISwitch!
    
    @IBOutlet weak var invitationSwitchOut: UISwitch!
    @IBOutlet weak var messgeSwitchOut: UISwitch!
    @IBOutlet weak var lblMaleOut: UILabel!

    @IBOutlet weak var lblFemaleOut: UILabel!
    
    @IBOutlet weak var lblAgeLimitOut: UILabel!
    
    @IBOutlet weak var lblLgbtOut: UILabel!
    
    @IBOutlet weak var lblDistanceOut: UILabel!
    @IBOutlet weak var rangeSlideOut: NMRangeSlider!
    @IBOutlet weak var lblDistanceUnitOut: UILabel!

    @IBOutlet weak var btnKmOut: UIButton!
    
    @IBOutlet weak var btnMiOut: UIButton!
    var arrProfileData = [String:AnyObject]()
    var locationNom = NSNumber()
    var messageNom = NSNumber()
    var invitationNom = NSNumber()
    var strGender = String()
    var strLowerValue = String()
    var strUpperValue = String()
    @IBOutlet weak var horizontalSlider: UISlider!
    var mutDictUserDetail = NSMutableDictionary()

    var isKm = false
    var meterInt = 20000
    
    override func awakeFromNib() {
        configureMetalTheme(slider: rangeSlideOut)
        
        if let placesData = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSDictionary
        {
            self.arrProfileData = placesData as! [String : AnyObject]
            print(placesData)
        }
        
        self.setData()

    }
    func setData(){
        if let distance_unit = arrProfileData["distance_unit"] as? String{
            lblDistanceUnitOut.text = distance_unit
            if distance_unit == "miles"{
                lblDistanceUnitOut.text = "Mi."
                self.isKm = false
                btnMiOut.backgroundColor = Utility.UIColorFromHex(0xAC192E)
                btnMiOut.setTitleColor(UIColor.white, for: .normal)
                btnKmOut.backgroundColor = UIColor.white
                btnKmOut.setTitleColor(UIColor.black, for: .normal)
                mutDictUserDetail.setValue("miles", forKey: "distance_unit")
               
                
            }else{
                lblDistanceUnitOut.text = "Km."
                self.isKm = true
                btnKmOut.backgroundColor = Utility.UIColorFromHex(0xAC192E)
                btnKmOut.setTitleColor(UIColor.white, for: .normal)
                btnMiOut.backgroundColor = UIColor.white
                btnMiOut.setTitleColor(UIColor.black, for: .normal)
                mutDictUserDetail.setValue("Km", forKey: "distance_unit")
            }
        }
         setSlider()

        if let recieveNoti = String(describing:   arrProfileData["is_receive_invitation_notifications"]!) as? String {
            if recieveNoti == "1"{
                messgeSwitchOut.isOn = true
                messageNom = NSNumber.init(value: true)

                mutDictUserDetail.setValue(NSNumber.init(value: true), forKey:"is_receive_messages_notifications")

            }else{
                messgeSwitchOut.isOn = false
                messageNom = NSNumber.init(value: false)

                mutDictUserDetail.setValue(NSNumber.init(value: false), forKey:"is_receive_messages_notifications")
            }
        }
        if let recieveNoti = String(describing:   arrProfileData["is_show_location"]!) as? String{
            if recieveNoti == "1"{
                locationSwitchOut.isOn = true
                 locationNom = NSNumber.init(value: true)
                mutDictUserDetail.setValue(NSNumber.init(value: true), forKey:"is_show_location")

            }else{
                locationSwitchOut.isOn = false
                 locationNom = NSNumber.init(value: false)
                mutDictUserDetail.setValue(NSNumber.init(value: false), forKey:"is_show_location")
            }
        }
        if let recieveNoti = String(describing:   arrProfileData["is_receive_invitation_notifications"]!) as? String {
            if recieveNoti == "1"{
                invitationSwitchOut.isOn = true
                invitationNom = NSNumber.init(value: true)
                mutDictUserDetail.setValue(NSNumber.init(value: true), forKey:"is_receive_invitation_notifications")

            }else{
                invitationSwitchOut.isOn = false
                 invitationNom = NSNumber.init(value: false)
                mutDictUserDetail.setValue(NSNumber.init(value: false), forKey:"is_receive_invitation_notifications")

            }
        }
        if let gender = arrProfileData["showme"] as? String{
            strGender = gender
            switch gender{
            case "all" :
                
                btnLgbtOut.isSelected = true
                btnMaleOut.isSelected = true
                btnFemaleOut.isSelected = true
                
                lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                break
                
            case "male" :
                btnLgbtOut.isSelected = false
                btnMaleOut.isSelected = true
                btnFemaleOut.isSelected = false
                
                lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblFemaleOut.textColor = UIColor.black
                lblLgbtOut.textColor = UIColor.black
                break
            case "female" :
                btnLgbtOut.isSelected = false
                btnMaleOut.isSelected = false
                btnFemaleOut.isSelected = true
                
                lblMaleOut.textColor = UIColor.black
                lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblLgbtOut.textColor = UIColor.black
                break
            case "lgbt" :
                btnLgbtOut.isSelected = true
                btnMaleOut.isSelected = false
                btnFemaleOut.isSelected = false
                
                lblMaleOut.textColor = UIColor.black
                lblFemaleOut.textColor = UIColor.black
                lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                break
            case "lgbt,male" :
                btnLgbtOut.isSelected = true
                btnMaleOut.isSelected = true
                btnFemaleOut.isSelected = false
                
                lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblFemaleOut.textColor = UIColor.black
                lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                
                break
            case "lgbt,femal" :
                btnLgbtOut.isSelected = true
                btnMaleOut.isSelected = false
                btnFemaleOut.isSelected = true
                
                lblMaleOut.textColor = UIColor.black
                lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
                break
            case "female,mal" :
                btnLgbtOut.isSelected = false
                btnMaleOut.isSelected = true
                btnFemaleOut.isSelected = true
                
                lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
                lblLgbtOut.textColor = UIColor.black
                break
            default:
                break
            }
            setDictionary()
        }
    }
    
    func configureMetalTheme(slider : NMRangeSlider){
        var image = UIImage(named: "imgSeprator")
        //slider back ground image
        let Img : UIImage = makeImageForTrackColor(aColor: Utility.UIColorFromHex(0xB5B5B5), height: 3, width: NSInteger(200))
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
        rangeSlideOut.maximumValue = 84
        rangeSlideOut.minimumRange = -100
        if let str3 = arrProfileData["search_min_age"] as? String{
            rangeSlideOut .lowerValue = Float(Int(str3)! - 16)
            if let str2 = arrProfileData["search_max_age"] as? String{
                lblAgeLimitOut.text = "\(str3) - \(str2) Years"
                strLowerValue = str3
                strUpperValue = str2
                rangeSlideOut.upperValue = Float(Int(str2)! - 16)
                mutDictUserDetail.setValue(str3, forKey: "search_min_age")
                mutDictUserDetail.setValue(str2, forKey: "search_max_age")
            }
        }
        
        if let distance = arrProfileData["search_distance"]
        {
            if "\(distance)" != ""
            {
                self.meterInt = Int("\(distance)")!
                
                if self.isKm == true
                {
                    self.horizontalSlider.value = Float(self.meterInt/1000)
                }
                else
                {
                    self.horizontalSlider.value = Float(self.meterInt/1610)
                }
                
                
                lblDistanceOut.text = "\(Int(horizontalSlider.value)) \(lblDistanceUnitOut.text!)"
            }
        }
    }
    @IBAction func distanceSliderAct(_ sender: Any) {
        lblDistanceOut.text = "\(Int(horizontalSlider.value)) \(lblDistanceUnitOut.text!)"
        //mutDictUserDetail.setValue(lblDistanceOut.text, forKey: "search_distance")
        
        if self.isKm == true
        {
            self.meterInt = Int(Float(self.horizontalSlider.value*1000))
        }
        else
        {
            self.meterInt = Int(Float(self.horizontalSlider.value*1610))
        }
        
        mutDictUserDetail.setObject("\(self.meterInt)", forKey: "search_distance" as NSCopying)
        setDictionary()

    }

    @IBAction func rangeSliderAct(_ sender: NMRangeSlider) {
        let intUpperValue = sender.upperValue
        let intLowerValue = sender.lowerValue
       strUpperValue = "\(String(describing: Int(intUpperValue) + 16))"
        strLowerValue =
        "\(String(describing: Int(intLowerValue) + 16))"
        lblAgeLimitOut.text = "\(strLowerValue) - \(strUpperValue) Years"
        
        mutDictUserDetail.setValue(strLowerValue, forKey: "search_min_age")
        mutDictUserDetail.setValue(strUpperValue, forKey: "search_max_age")
        setDictionary()

    }
    
    
    
    @IBAction func invitationSwitchAct(_ sender: Any) {
        if invitationSwitchOut.isOn{
            mutDictUserDetail.setValue(NSNumber.init(value: 1), forKey:"is_receive_invitation_notifications")
            invitationNom = NSNumber.init(value: true)


        }else{
            mutDictUserDetail.setValue(NSNumber.init(value: 0), forKey:"is_receive_invitation_notifications")
            invitationNom = NSNumber.init(value: false)

        }
        setDictionary()
        

    }

    @IBAction func messageSwitchAct(_ sender: Any) {
        if messgeSwitchOut.isOn{
            mutDictUserDetail.setValue(NSNumber.init(value: 1), forKey:"is_receive_messages_notifications")
            messageNom = NSNumber.init(value: true)

            
        }else{
            mutDictUserDetail.setValue(NSNumber.init(value: 0), forKey:"is_receive_messages_notifications")
            messageNom = NSNumber.init(value: false)

        }
        setDictionary()

    }
    @IBAction func locationSwitchAct(_ sender: Any) {
        if locationSwitchOut.isOn{
            mutDictUserDetail.setValue(NSNumber.init(value: 1), forKey:"is_show_location")
            locationNom = NSNumber.init(value: true)

            
        }else{
            mutDictUserDetail.setValue(NSNumber.init(value: 0), forKey:"is_show_location")
            locationNom = NSNumber.init(value: false)

        }
        setDictionary()

    }
    @IBAction func btnkmAct(_ sender: Any) {
        
        lblDistanceUnitOut.text = "Km."
        lblDistanceOut.text = "\(Int(horizontalSlider.value)) \(lblDistanceUnitOut.text!)"
        btnKmOut.backgroundColor = Utility.UIColorFromHex(0xAC192E)
        btnKmOut.setTitleColor(UIColor.white, for: .normal)
        btnMiOut.backgroundColor = UIColor.white
        btnMiOut.setTitleColor(UIColor.black, for: .normal)
        mutDictUserDetail.setValue("Km", forKey: "distance_unit")
       self.isKm = true
        self.meterInt = Int(self.horizontalSlider.value*1000)
        mutDictUserDetail.setObject("\(self.meterInt)", forKey: "search_distance" as NSCopying)
        setDictionary()

    }
    
    @IBAction func btnMiAct(_ sender: Any) {
        lblDistanceUnitOut.text = "Mi."
        self.isKm = false
        self.meterInt = Int(self.horizontalSlider.value*1610)
        lblDistanceOut.text = "\(Int(horizontalSlider.value)) \(lblDistanceUnitOut.text!)"
        btnMiOut.backgroundColor = Utility.UIColorFromHex(0xAC192E)
        btnMiOut.setTitleColor(UIColor.white, for: .normal)
        btnKmOut.backgroundColor = UIColor.white
        btnKmOut.setTitleColor(UIColor.black, for: .normal)
        mutDictUserDetail.setValue("miles", forKey: "distance_unit")
        mutDictUserDetail.setObject("\(self.meterInt)", forKey: "search_distance" as NSCopying)
        setDictionary()

    }
    
    
    @IBAction func btnMaleAct(_ sender: Any) {
        if btnMaleOut.isSelected == true{
            btnMaleOut.isSelected = false
            lblMaleOut.textColor = UIColor.black
        }else{
            btnMaleOut.isSelected = true
            lblMaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
        }
        setDictionary()
    }
    
    @IBAction func btnFemaleAct(_ sender: Any) {
        if btnFemaleOut.isSelected == true{
            btnFemaleOut.isSelected = false
            lblFemaleOut.textColor = UIColor.black
        }else{
            btnFemaleOut.isSelected = true
            lblFemaleOut.textColor = Utility.UIColorFromHex(0xAC192E)
        }
        setDictionary()

    }
    
    @IBAction func btnLgbtAct(_ sender: Any) {
        if btnLgbtOut.isSelected == true{
            btnLgbtOut.isSelected = false
            lblLgbtOut.textColor = UIColor.black
        }else{
            btnLgbtOut.isSelected = true
            lblLgbtOut.textColor = Utility.UIColorFromHex(0xAC192E)
        }
        setDictionary()

    }
    func setDictionary(){
        if btnLgbtOut.isSelected && btnFemaleOut.isSelected  && btnMaleOut.isSelected {
            strGender = "all"
        }else if btnLgbtOut.isSelected == false && btnFemaleOut.isSelected  && btnMaleOut.isSelected{
            strGender = "female,male"
        }else if btnFemaleOut.isSelected == false && btnLgbtOut.isSelected  && btnMaleOut.isSelected{
            strGender = "lgbt,male"
        }else if btnMaleOut.isSelected == false && btnLgbtOut.isSelected  && btnFemaleOut.isSelected{
            strGender = "lgbt,female"
        }else if btnLgbtOut.isSelected == false && btnFemaleOut.isSelected == false && btnMaleOut.isSelected{
            strGender = "male"
        }else if btnLgbtOut.isSelected == false && btnMaleOut.isSelected == false && btnFemaleOut.isSelected{
            strGender = "female"
        }else if btnFemaleOut.isSelected == false && btnMaleOut.isSelected == false && btnLgbtOut.isSelected{
            strGender = "lgbt"
        }else{
            strGender = "all"
        }
        if lblDistanceUnitOut.text == "Mi."{
            mutDictUserDetail.setValue("miles", forKey: "distance_unit")
        }
        else
        {
            mutDictUserDetail.setValue("Km", forKey: "distance_unit")
        }
        mutDictUserDetail.setValue(strLowerValue, forKey: "search_min_age")
        mutDictUserDetail.setValue(strUpperValue, forKey: "search_max_age")
        mutDictUserDetail.setValue(invitationNom, forKey:"is_receive_invitation_notifications")
        mutDictUserDetail.setValue(messageNom, forKey:"is_receive_messages_notifications")
        mutDictUserDetail.setValue(locationNom, forKey:"is_show_location")
        mutDictUserDetail.setValue(strGender, forKey: "showme")
        
        
        
        print(mutDictUserDetail)
        let data = NSKeyedArchiver.archivedData(withRootObject: mutDictUserDetail)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey:"mutDictUser")
        
    }
}
