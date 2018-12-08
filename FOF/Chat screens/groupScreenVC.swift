//
//  groupScreenVC.swift
//  FOF
//
//

import UIKit

class groupScreenVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var btnAddimageGrp: UIButton!
    @IBOutlet weak var txtGroupName: UITextField!
    var selectedFriend = NSMutableArray()
    
    var imagePicker = UIImagePickerController()
    
    var selectImage : UIImage?
    
    let objSendMessage = sendMessageServicesScreenVC()
    var selectedRestadata = NSMutableDictionary()
    
    @IBOutlet weak var tblFriend: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnAddimageGrp.layer.cornerRadius = self.btnAddimageGrp.frame.height / 2
        self.btnAddimageGrp.clipsToBounds = true
        
        self.txtGroupName.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddPhotoAct(_ sender: Any)
    {
        let alert = UIAlertController.init(title: "Select option", message: "Please select option to choose image.", preferredStyle: .actionSheet)
        
        let selectGallery = UIAlertAction.init(title: "Gallery", style: .default) { (act) in
            
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction.init(title: "Camera", style: .default) { (act) in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let canecl = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
     
        alert.addAction(camera)
        alert.addAction(selectGallery)
        alert.addAction(canecl)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func BtnActionCross(sender : UIButton)
    {
        if self.selectedFriend.count > 0
        {
            self.selectedFriend.removeObject(at: sender.tag)
            self.tblFriend.reloadData()
        }
        
    }
    
    @IBAction func btnActionCreateGroup(_ sender: Any)
    {
//        if self.selectedFriend.count >= 2
//        {
            if self.txtGroupName.text != ""
            {
                if self.selectImage != nil
                {
                    
                }
                else
                {
                    var selecteFriendID = ""
                    for i in 0..<self.selectedFriend.count
                    {
                        if let dict = self.selectedFriend.object(at: i) as? NSDictionary
                        {
                            if let friend_id = dict.object(forKey: "friend_id")
                            {
                                if selecteFriendID == ""
                                {
                                    selecteFriendID = "\(UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!),\(friend_id)"
                                }
                                else
                                {
                                    selecteFriendID = "\(selecteFriendID),\(friend_id)"
                                }
                            }
                            
                        }
                    }
                    
                    if selecteFriendID != ""
                    {
                        let param = ["user_id":"\(UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)!)","name":self.txtGroupName.text!,"group_members":selecteFriendID]
                        self.createGroupWithoutImage(dict: param as NSDictionary)
                    }
                    
                }
                
            }
            else
            {
                self.view.makeToast("Please enter group name.")
            }
            
            //CreateGroup
//        }
//        else
//        {
//            self.view.makeToast("Please select at least 2 friend to create group.")
//        }
    }
    
    
    func createGroupWithImage(dict : NSDictionary,grpImage : UIImage)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        
        Webservices_Alamofier.postWithHeaderURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.CreateGroup, param: dict, key: "") { (success, response) in
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if success == true
            {
                
            }
            else
            {
                if let msg = response.object(forKey: "message") as? String
                {
                    self.view.makeToast(msg)
                }
                else
                {
                    self.view.makeToast("Something went to wrong. Please try after sometime.")
                }
            }
            
        }
    }
    

    func createGroupWithoutImage(dict : NSDictionary)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.CreateGroup, param: dict, key: "", successStatusCode: 200) { (success, response) in
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if success == true
            {
                if let response_data = response.object(forKey: "response_data") as? NSDictionary
                {
                    if let group_id = response_data.object(forKey: "group_id")
                    {
                        self.SendFirstMessageInGroup(chatId: "\(group_id)", frndIS: "\(dict.object(forKey: "group_members")!)", grpDataDict: response_data)
                        
                    }
                }
            }
            else
            {
                if let msg = response.object(forKey: "message") as? String
                {
                    self.view.makeToast(msg)
                }
                else
                {
                    self.view.makeToast("Something went to wrong. Please try after sometime.")
                }
            }
            
        }
    }
    
    
    func SendFirstMessageInGroup(chatId : String,frndIS : String,grpDataDict : NSDictionary)
    {
        UserDefaults.standard.set(chatId, forKey: Constants.UserDefaults.matchId)
        
        self.objSendMessage.addObserverForRecipteCHangeWithChatId(chatId: chatId)
        
        
        self.objSendMessage.mutMessageParamDictDetail["contentType"] = "text";
        self.objSendMessage.mutMessageParamDictDetail["msg"] = "Hello group member";
        self.objSendMessage.mutMessageParamDictDetail["recieverDP"] = ""
        self.objSendMessage.mutMessageParamDictDetail["recieverId"] = frndIS
        self.objSendMessage.mutMessageParamDictDetail["senderDp"] = Constants.GlobalConstants.appDelegate.userDetail.profilepic1
        self.objSendMessage.mutMessageParamDictDetail["senderId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
        
        self.objSendMessage.mutMessageParamDictDetail["timeStamp"] = setCurrentTimeToTimestamp()
        
        self.objSendMessage.sendMessageToRecieverId(recieverId: frndIS, isFriend: true, chatGrpID: chatId)
        
        objSendMessage.setDictFormatForWriteDataDefault()
            var strPhotoUrl = String()
            
            if let CarFirst =  self.selectedRestadata["CarFirst"] as? NSDictionary
            {
                if let Difference = CarFirst.object(forKey: "Difference")
                {
                    self.objSendMessage.mutMessageParamDictDetail["timeToReach"] = Difference
                }
            }
            
            if let dataDict =  self.selectedRestadata["isSelected"] as? NSDictionary {
                print(dataDict)
                
                if let photos = dataDict["thumb"] as? String//dataDict["photos"] as? [[String:Any]]
                {
                    if photos != ""
                    {
                        strPhotoUrl = photos
                    }
                    
                    //                            let strRefre = photos.first
                    //                            strPhotoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1080&photoreference=\(strRefre!["photo_reference"] as! String)"
                    
                }
                
                
                self.objSendMessage.mutMessageParamDictDetail["contentType"] = "restaurant"
                self.objSendMessage.mutParamDict["vicinity"] = ""//dataDict.object(forKey: "vicinity") as! String
                self.objSendMessage.mutParamDict["photoReference"] = strPhotoUrl
                self.objSendMessage.mutMessageParamDictDetail["timeStamp"] = setCurrentTimeToTimestamp()
                self.objSendMessage.mutMessageParamDictDetail["recieverId"] = frndIS
                self.objSendMessage.mutParamDict["name"] = dataDict.object(forKey: "name") as! String
                
                if let location = dataDict.object(forKey: "location") as? NSDictionary{
                    self.objSendMessage.mutParamDict["latitude"] = String(describing: location.object(forKey: "latitude")!)
                    self.objSendMessage.mutParamDict["longitude"] = String(describing: location.object(forKey: "longitude")!)
                }
                
                if let rate = dataDict.object(forKey: "user_rating") as? NSDictionary
                {
                    if let aggregate_rating = rate.object(forKey: "aggregate_rating")
                    {
                        self.objSendMessage.mutParamDict["ratings"] = "\(aggregate_rating)"
                    }
                    else
                    {
                        self.objSendMessage.mutParamDict["ratings"] = ""
                    }
                }
                else
                {
                    self.objSendMessage.mutParamDict["ratings"] = ""
                }
                
                self.objSendMessage.mutMessageParamDictDetail["recieverId"] = frndIS
                self.objSendMessage.mutMessageParamDictDetail["senderId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                self.objSendMessage.mutParamDict["phoneNumber"] = ""
                if let rdict = dataDict.object(forKey: "R") as? NSDictionary
                {
                    if let rest_id = rdict.object(forKey: "res_id")
                    {
                        self.objSendMessage.mutParamDict["restid"] = "\(rest_id)"
                    }
                    else
                    {
                        if let reid = dataDict.object(forKey: "id")
                        {
                            self.objSendMessage.mutParamDict["restid"] = "\(reid)"
                        }
                        
                    }
                }
                else
                {
                    if let reid = dataDict.object(forKey: "id")
                    {
                        self.objSendMessage.mutParamDict["restid"] = "\(reid)"
                    }
                }
                self.objSendMessage.mutParamDict["name"] = dataDict.object(forKey: "name") as! String
                
                if let location = dataDict.object(forKey: "location") as? NSDictionary
                {
                    if let address = location.object(forKey: "address") as? String
                    {
                        self.objSendMessage.mutParamDict["formatted_address"] = address
                    }
                }
                self.objSendMessage.mutParamDict["url"] = ""
                self.objSendMessage.mutParamDict["website"] = ""
                self.objSendMessage.mutParamDict["websiteUrl"] = ""
                self.objSendMessage.mutParamDict["open_now"] = ""
                self.objSendMessage.mutMessageParamDictDetail["recieverDP"] = ""//self.dictUserDetails["profilepic1"] as! String
                self.objSendMessage.mutMessageParamDictDetail["senderDp"] = Constants.GlobalConstants.appDelegate.userDetail.profilepic1
                self.objSendMessage.mutParamDict["priceRange"] = NSNumber.init(integerLiteral: 1)
                self.objSendMessage.mutParamDict["posInList"] = NSNumber.init(integerLiteral: 0)
                self.objSendMessage.mutParamDict["isSelected"] = NSNumber.init(booleanLiteral: false)
                self.objSendMessage.mutParamDict["reference"] = ""//dataDict.object(forKey: "reference") as! String
            }
            if let dataTime =  (self.selectedRestadata["CarFirst"]) as? NSDictionary{
                self.objSendMessage.mutParamDict["timeToReach"] = dataTime.object(forKey: "Difference") as! String
            }
            else
            {
                self.objSendMessage.mutParamDict["timeToReach"] = "No data available"
            }
            
            self.objSendMessage.sendMessageToRecieverId(recieverId:frndIS,isFriend : false, chatGrpID: chatId)
        
        if let chjatID = grpDataDict.object(forKey: "group_id")
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "conversationScreenVC") as! conversationScreenVC
            obj.chatGrpId = "\(chjatID)"
            UserDefaults.standard.set(chjatID, forKey: Constants.UserDefaults.matchId)
            obj.dictUserDetail = grpDataDict
            
            obj.isFreind = true
            obj.isGroup = true
            UserDefaults.standard.setValue("", forKey: Constants.UserDefaults.receiverDP)
            
            self.navigationController?.pushViewController(obj, animated: false)
        }
        else
        {
            self.view.makeToast("Sorry... Something went to wrong. please try after sometime.")
        }
    }
    
    
    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedFriend.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
        if let dict = self.selectedFriend.object(at: indexPath.row) as? NSDictionary
        {
            
            if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let profilepic1 = dict.object(forKey: "profilepic1")
            {
                cell.imgProfilePic.cornerRadius = cell.imgProfilePic.frame.width / 2
                cell.imgProfilePic.clipsToBounds = true
                cell.imgProfilePic.image = UIImage.init(named: "disableSingle")
                if "\(profilepic1)" != ""
                {
                    if let proURL = URL.init(string: "\(profilepic1)")
                    {
                        cell.imgProfilePic.sd_setImage(with: proURL, placeholderImage: UIImage.init(named: "disableSingle"))
                    }
                }
                else
                {
                    cell.imgProfilePic.image = UIImage.init(named: "disableSingle")
                }
                cell.lblContactNameGroup.text = "\(first_name) \(last_name)"
                
            }
            
        }
        cell.btnCrossOut.tag = indexPath.row
        cell.btnCrossOut.addTarget(self, action: #selector(BtnActionCross(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dict = self.selectedFriend.object(at: indexPath.row) as? NSDictionary
        {
//            let muteDict = NSMutableDictionary(dictionary: dict)
//            muteDict.setValue("1", forKey: "isSelected")
//            self.ArrayFriendData.replaceObject(at: indexPath.row, with: muteDict)
//            self.tblviewChatScreen.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension groupScreenVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension groupScreenVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let Selectedimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.selectImage = Selectedimage
            self.btnAddimageGrp.setImage(self.selectImage!, for: .normal)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
