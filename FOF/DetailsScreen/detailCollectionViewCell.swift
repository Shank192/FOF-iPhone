//
//  detailCollectionViewCell.swift
//  FOF
//
//  Created by 360dts on 16/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import MBProgressHUD

class detailCollectionViewCell: UICollectionViewCell,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var nslcHightOfViewGender: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewOfPicker: UIView!
    @IBOutlet weak var viewOfGender: UIView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var relationPickerView: UIPickerView!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var lblCharacterLength: UILabel!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var lblLGBT: UILabel!
    @IBOutlet weak var btnLGBTout: UIButton!
    @IBOutlet weak var btnFemaleOut: UIButton!
    @IBOutlet weak var btnMaleOut: UIButton!
    @IBOutlet weak var txtViewAboutMe: UITextView!
    
    @IBOutlet weak var txtFieldGender: UITextField!
    @IBOutlet weak var txtFieldBirthDay: UITextField!
    
    @IBOutlet weak var txtFieldEducation: UITextField!
    @IBOutlet weak var txtFieldOccupation: UITextField!
    
    @IBOutlet weak var txtFieldEthnicity: UITextField!
    @IBOutlet weak var txtFieldRelation: UITextField!
    var isGenderViewOpen = false
    var arrRelationship = ["Single","In a relationship","Engaged","Married","In a civil partnership","In a domestic partnership","In a open relation ship","It's complicated","Separated","Divorced","Widow"]
   
    var arrProfileData = [String:AnyObject]()
    var strRelationship = String()
    var strBirthday = String()
    var strGender = String()
    var strEthnicity = String()
    var strOccupation = String()
    var strEducation = String()
    var strFirstname = String()
    var strLastName = String()
  
    
    override func awakeFromNib() {
        initialSetUp()
    }
    // MARK: - Set data

    func initialSetUp(){

        NotificationCenter.default.addObserver(self, selector: #selector(self.saveDetails), name: Constants.UserDefaults.notificationName, object: nil)

        nslcHightOfViewGender.constant = -viewOfGender.frame.size.height
        let placesData = UserDefaults.standard.object(forKey: Constants.UserDefaults.ProfileData) as? NSData
   
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [ Any]
            arrProfileData = placesArray![0] as! [String:AnyObject]
            print(arrProfileData)
        }
        
        self.txtFieldEducation.text = Constants.GlobalConstants.appDelegate.userDetail.education
        self.txtFieldOccupation.text = Constants.GlobalConstants.appDelegate.userDetail.occupation
        self.txtViewAboutMe.text = Constants.GlobalConstants.appDelegate.userDetail.aboutMe
        self.txtFieldBirthDay.text = Constants.GlobalConstants.appDelegate.userDetail.dob
       self.txtFieldEthnicity.text = Constants.GlobalConstants.appDelegate.userDetail.ethnicity
        if let strFirstName = arrProfileData["first_name"] as? String{
            txtFirstName.text = strFirstName}
        if let strLastName =  arrProfileData["last_name"] as? String{
            txtLastName.text = strLastName}
        if let strRelation = arrProfileData["relationship"] as? String {
            txtFieldRelation.text = strRelation}
       setTextView()
        if let strGender = arrProfileData["gender"]  as? String  {
            txtFieldGender.text = strGender.capitalized
            switch (strGender) {
            case "male":
                btnLGBTout.isSelected = false
                btnMaleOut.isSelected = true
                btnFemaleOut.isSelected = false
                
                lblMale.textColor = Utility.UIColorFromHex(0xAC192E)
                lblFemale.textColor = UIColor.black
                lblLGBT.textColor = UIColor.black
                break;
            case "female":
                btnLGBTout.isSelected = false
                btnMaleOut.isSelected = false
                btnFemaleOut.isSelected = true
                
                lblMale.textColor = UIColor.black
                lblFemale.textColor = Utility.UIColorFromHex(0xAC192E)
                lblLGBT.textColor = UIColor.black
                break;
            case "lgbt":
                btnLGBTout.isSelected = true
                btnMaleOut.isSelected = false
                btnFemaleOut.isSelected = false
                
                lblMale.textColor = UIColor.black
                lblFemale.textColor = UIColor.black
                lblLGBT.textColor = Utility.UIColorFromHex(0xAC192E)
                break;
            default:
                break;
            }
        }
        viewOfGender.isHidden = true
        relationPickerView.delegate = self
        relationPickerView.dataSource = self
    }
  @objc  func saveDetails(){
        
    let dictEditProfilePara = ["action":"editprofile","userid":UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String,"first_name":txtFirstName.text as Any ,"last_name":txtLastName.text as Any ,"dob":txtFieldBirthDay.text as Any,"sessionid":UserDefaults.standard.object(forKey: Constants.UserDefaults.session_ID) as! String,"showme":txtFieldGender.text as Any,"distance_unit":"miles","search_min_age":Constants.GlobalConstants.appDelegate.userDetail.searchMinAge,"search_max_age":Constants.GlobalConstants.appDelegate.userDetail.searchMaxAge,"search_distance":Constants.GlobalConstants.appDelegate.userDetail.searchDistance,"isreviewed":(0),"occupation":txtFieldOccupation.text as Any,"relationship":txtFieldRelation.text as Any,"ethnicity":txtFieldEthnicity.text as Any,"education":txtFieldEducation.text as! String,"about_me":txtViewAboutMe.text,"fields":"first_name,last_name,dob,showme,search_distance,search_max_age,search_min_age,distance_unit,isreviewed,occupation,relationship,ethnicity,education,about_me"] as [String : Any]
    
        WebService.postURL(Constants.WebServiceUrl.mainUrl, param: dictEditProfilePara as NSDictionary) { (success, response) in
            if success == true
            {
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    if dataArray.count != 0
                    {
                        if let dict = dataArray.object(at: 0) as? NSDictionary
                        {
                            Constants.GlobalConstants.appDelegate.userDetail = UserDetail.modelObject(with: dict as! [AnyHashable : Any])
                            let placesData = NSKeyedArchiver.archivedData(withRootObject: dataArray)
                            
                            UserDefaults.standard.set(placesData, forKey: Constants.UserDefaults.ProfileData)
                            UserDefaults.standard.set(dict.object(forKey: "testbuds"), forKey: Constants.UserDefaults.MyTestBuds)
                            if let sessionid = dict.object(forKey: "sessionid")
                            {
                                UserDefaults.standard.set("\(sessionid)", forKey: Constants.UserDefaults.session_ID)
                            }
                        }
                    }
                    
                }
            }
            
        }
        
        
        
        
        
    }
    func setTextView(){
       
        if txtViewAboutMe.text == ""{
            txtViewAboutMe.text = "About Me"
            txtViewAboutMe.textColor = UIColor.gray
        }else{
            txtViewAboutMe.textColor = UIColor.black
            
        }
    }
    func setKeyboard(){
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtViewAboutMe.resignFirstResponder()
        txtFieldBirthDay.resignFirstResponder()
        txtFieldRelation.resignFirstResponder()
        txtFieldGender.resignFirstResponder()
        txtFieldEthnicity.resignFirstResponder()
        txtFieldOccupation.resignFirstResponder()
        txtFieldEducation.resignFirstResponder()
    }
    func setPickerView(txtField : UITextField){
        setKeyboard()
        if isGenderViewOpen{
            setCloseGender()
        }
        if txtField == txtFieldBirthDay{
            viewOfPicker.isHidden = false
            datePickerView.isHidden = false
            relationPickerView.isHidden = true
        }else{
            viewOfPicker.isHidden = false
            datePickerView.isHidden = true
            relationPickerView.isHidden = false
        }
    }
    func setCloseGender(){
        viewOfPicker.isHidden = true
        nslcHightOfViewGender.constant = -viewOfGender.frame.size.height
        viewOfGender.isHidden = true
        isGenderViewOpen = false
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
    func setOpenGender(){
        viewOfPicker.isHidden = true
        isGenderViewOpen = true
        nslcHightOfViewGender.constant = 0.130342
        UIView.animate(withDuration: 0.4) {
            self.viewOfGender.isHidden = false
            
            self.layoutIfNeeded()
        }
    }
    // MARK: - Button action method

    @IBAction func btnDropDownAct(_ sender: Any) {
        setPickerView(txtField: txtFieldBirthDay)
    }
    
    @IBAction func btnDropDownGenderAct(_ sender: Any) {
        setKeyboard()
        if isGenderViewOpen{
           setCloseGender()
        }else{
         setOpenGender()
        }
    }
    
    
    @IBAction func btnRelationshipAct(_ sender: Any) {
     setPickerView(txtField: txtFieldRelation)
    }
    @IBAction func btnMaleAct(_ sender: Any) {
        if btnMaleOut.isSelected == true{
            btnMaleOut.isSelected = false
            lblMale.textColor = UIColor.black
        }else{
            btnMaleOut.isSelected = true
            btnFemaleOut.isSelected = false
            btnLGBTout.isSelected = false
            lblMale.textColor = Utility.UIColorFromHex(0xAC192E)
            lblFemale.textColor = UIColor.black
            lblLGBT.textColor = UIColor.black
            strGender = "male"
            txtFieldGender.text = strGender.capitalized
        }
    }
    
    @IBAction func btnLGBTAct(_ sender: Any) {
        if btnLGBTout.isSelected == true{
            btnLGBTout.isSelected = false
            lblLGBT.textColor = UIColor.black
        }else{
            btnMaleOut.isSelected = false
            btnFemaleOut.isSelected = false
            btnLGBTout.isSelected = true
            lblMale.textColor = UIColor.black
            lblFemale.textColor = UIColor.black
            lblLGBT.textColor = Utility.UIColorFromHex(0xAC192E)
            strGender = "lgbt"
            txtFieldGender.text = strGender.capitalized
            
        }
    }
    @IBAction func btnFemaleAct(_ sender: Any) {
        if btnFemaleOut.isSelected == true{
            btnFemaleOut.isSelected = false
            lblFemale.textColor = UIColor.black
        }else{
            btnMaleOut.isSelected = false
            btnFemaleOut.isSelected = true
            btnLGBTout.isSelected = false
            lblMale.textColor = UIColor.black
            lblFemale.textColor = Utility.UIColorFromHex(0xAC192E)
            lblLGBT.textColor = UIColor.black
            strGender = "female"
            txtFieldGender.text = strGender.capitalized

        }
    }
    
    @IBAction func btnTestBudsAct(_ sender: Any){
        NotificationCenter.default.post(name: Constants.UserDefaults.pushNotificationName, object: nil)

    }
    @IBAction func btnDoneAct(_ sender: Any) {
        viewOfPicker.isHidden = true

        if datePickerView.isHidden{
            txtFieldRelation.text = strRelationship
            if txtFieldRelation.text != ""{
               
            }else{
                 txtFieldRelation.text = "Single"
            }
        }else{
            txtFieldBirthDay.text = datePicker()
            
        }
    }
    @IBAction func btnCancelAct(_ sender: Any) {
        viewOfPicker.isHidden = true

    }
   
    func datePicker() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        strBirthday = formatter.string(from: datePickerView.date)
        return strBirthday
    }
    
    // MARK: - TextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFieldRelation || textField == txtFieldBirthDay{
            
            if (textField == txtFieldRelation){
                setPickerView(txtField: txtFieldRelation)
            }else{
                setPickerView(txtField: txtFieldBirthDay)
            }
           
        }else if textField == txtFieldGender{
            setKeyboard()
            if isGenderViewOpen{
                setCloseGender()
            }else{
                setOpenGender()}
        }else{
            viewOfPicker.isHidden = true
            if isGenderViewOpen{
                setCloseGender()
            }        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        strRelationship = txtFieldRelation.text!
        strGender = txtFieldGender.text!
        strEthnicity = txtFieldEthnicity.text!
        strOccupation = txtFieldOccupation.text!
        strEducation = txtFieldEducation.text!
        strBirthday = txtFieldBirthDay.text!
        strFirstname = txtFirstName.text!
        strLastName = txtLastName.text!
    }
    
    // MARK: - TextView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
      
        if textView.text == "About Me"{
            textView.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
 
        lblCharacterLength.text = "\(textView.text.count)/250"
        textView.textColor = UIColor.black
        textView.autoresizingMask = .flexibleHeight

    }
    func textViewDidEndEditing(_ textView: UITextView) {
        setTextView()
    }
    
    // MARK: - Pickerview delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrRelationship.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let str = arrRelationship[row]
        return str
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strRelationship = arrRelationship[row]
    }
}
