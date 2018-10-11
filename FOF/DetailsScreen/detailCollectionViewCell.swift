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
    
    var mutDictUserDetail = NSMutableDictionary()
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
    var strAboutMe = String()
    var strFields = String()

    override func awakeFromNib() {
        initialSetUp()
    }
    // MARK: - Set data

    func initialSetUp(){

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
        lblCharacterLength.text = "\(txtViewAboutMe.text.count)/250"
        
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
        setDictionary()

    }
    func setTextView(){
       
        if txtViewAboutMe.text == ""{
            txtViewAboutMe.text = "About Me"
            strAboutMe = ""
            txtViewAboutMe.textColor = UIColor.gray
        }else{
            txtViewAboutMe.textColor = UIColor.black
            strAboutMe = txtViewAboutMe.text
            
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 251
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
         setDictionary()
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
         setDictionary()
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
         setDictionary()
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
         setDictionary()
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
       
        setDictionary()
    }
    func setDictionary(){
        mutDictUserDetail.setValue(txtFirstName.text!, forKey: "first_name")
        mutDictUserDetail.setValue(txtLastName.text!, forKey: "last_name")
        mutDictUserDetail.setValue(txtFieldEthnicity.text!, forKey: "ethnicity")
        mutDictUserDetail.setValue(txtFieldOccupation.text!, forKey: "occupation")
        mutDictUserDetail.setValue(txtViewAboutMe.text, forKey: "about_me")
        mutDictUserDetail.setValue(txtFieldEducation.text, forKey: "education")
        mutDictUserDetail.setValue(txtFieldRelation.text!, forKey: "RelationShip")
        mutDictUserDetail.setValue(strGender, forKey: "Gender")
        mutDictUserDetail.setValue(txtFieldBirthDay.text!, forKey: "Birthday")

        
        print(mutDictUserDetail)
        let data = NSKeyedArchiver.archivedData(withRootObject: mutDictUserDetail)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey:"mutDictUserDetail")

    }
    // MARK: - TextView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.count > 250{}else{
        if textView.text == "About Me"{
            textView.text = ""
            }}
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 250{}else{
        lblCharacterLength.text = "\(textView.text.count)/250"
        textView.textColor = UIColor.black
            textView.autoresizingMask = .flexibleHeight
        }
        setDictionary()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        setTextView()
        setDictionary()
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
