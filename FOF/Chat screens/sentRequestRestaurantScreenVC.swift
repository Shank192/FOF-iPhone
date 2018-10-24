//
//  sentRequestRestaurantScreenVC.swift
//  FOF
//
//  Created by 360dts on 30/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class sentRequestRestaurantScreenVC: UIViewController ,FirebaseDelegate{
    
    
    
    var arrForRestaurants = [[String:AnyObject]]()
    
    @IBOutlet weak var imgFrnd: UIImageView!
    @IBOutlet weak var lblMessageDetail: UILabel!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var collectionViewFriendSuggestion: UICollectionView!
    var strMessage = String()
    var dictUserDetails = NSDictionary()
    let objSendMessage = sendMessageServicesScreenVC()
    var arrFetchedMessages = NSMutableArray()
    var strChatId = String()
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var btnAcceptOut: UIButton!
    
    @IBOutlet weak var lblContinueChat: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnRejectOut: UIButton!
    var isSent = Bool()
    var isRequestSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Friend User Dict = :- \(dictUserDetails)")
        
        if isSent{
            setFatchedRestaurantFromCoredata()
        }else{
            sendWsRequest()
        }
        objSendMessage.delegate = self
        lblMessageDetail.text = strMessage
        viewAccept.isHidden = true
        btnAcceptOut.isHidden = true
        btnRejectOut.isHidden = true
        lblContinueChat.isHidden = true
        if let dict = dictUserDetails.object(forKey: "details") as? [[String:AnyObject]]{
            if let  strPicUrl = dict[0]["profilepic1"] as? String{
                let url = NSURL(string: strPicUrl)!  as URL
                imgFrnd.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
            }
            if let firstName = dict[0]["first_name"] as? String,let lastName = dict[0]["last_name"] as? String{
                lblFriendName.text = "\(firstName) \(lastName)"
                lblDetails.text = "\(firstName) \(lastName) has not shown interest in you yet"
            }
        }else{
            if let  strPicUrl = dictUserDetails.object(forKey: "profilepic1")! as? String{
                let url = NSURL(string: strPicUrl)!  as URL
                imgFrnd.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
            }
            if let firstName = dictUserDetails.object(forKey: "first_name") as? String,let lastName = dictUserDetails.object(forKey: "last_name") as? String{
                lblFriendName.text = "\(firstName) \(lastName)"
                lblDetails.text = "\(firstName) \(lastName) has not shown interest in you yet"
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBackAct(_ sender: Any) {
        if isSent{
            self.navigationController?.popViewController(animated: true)}
        else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func btnAcceptAct(_ sender: Any) {
    }
    
    @IBAction func btnRejectAct(_ sender: Any) {
    }
    func sendWsRequest(){
        
        if let strReceiverId = dictUserDetails.object(forKey: "friend_user_id"){
            
            let param = ["user_id":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"friend_user_id":"\(strReceiverId)"]
            
            var methodName = ""
            if isRequestSent == true
            {
                methodName = Constants.APIName.SendFriendRequest
            }
            else
            {
                methodName = Constants.APIName.AcceptFriendRequest
            }
            
            
            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: methodName, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                if success == true
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATIONUPDATENOTIFY"), object: nil)
                    
                    self.objSendMessage.setDictFormatForWriteDataDefault()
                    if let dictdata = response.object(forKey: "response_data") as? NSDictionary
                    {
                        if self.isRequestSent == false
                        {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "conversationScreenVC") as! conversationScreenVC
                            obj.isFreind = true
                            obj.dictUserDetail = self.dictUserDetails
                            self.navigationController?.pushViewController(obj, animated: false)
                        }
                        
                        self.strChatId = dictdata["id"] as! String
                    }
                  
                    UserDefaults.standard.set(self.strChatId, forKey: Constants.UserDefaults.matchId)
                    self.objSendMessage.addObserverForRecipteCHangeWithChatId(chatId: self.strChatId)
                    
                    
                    self.objSendMessage.mutMessageParamDictDetail["contentType"] = "text";
                    self.objSendMessage.mutMessageParamDictDetail["msg"] = self.strMessage;
                    self.objSendMessage.mutMessageParamDictDetail["recieverDP"] = self.dictUserDetails["profilepic1"]
                    self.objSendMessage.mutMessageParamDictDetail["recieverId"] = "\(strReceiverId)"
                    self.objSendMessage.mutMessageParamDictDetail["senderDp"] = Constants.GlobalConstants.appDelegate.userDetail.profilepic1
                    self.objSendMessage.mutMessageParamDictDetail["senderId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                    
                    self.objSendMessage.mutMessageParamDictDetail["timeStamp"] = setCurrentTimeToTimestamp()
                    
                    self.objSendMessage.sendMessageToRecieverId(recieverId: "\(strReceiverId)", isFriend: false)
                    
                    for i in 0..<self.arrForRestaurants.count {
                        var strPhotoUrl = String()
                        
                        if let dataDict =  (self.arrForRestaurants[i]["RestaurantData"] as? NSDictionary) {
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
                            self.objSendMessage.mutMessageParamDictDetail["timeStamp"] = setCurrentTimeToTimestamp() + i
                            self.objSendMessage.mutMessageParamDictDetail["recieverId"] = strReceiverId
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
                            
                            
                            self.objSendMessage.mutMessageParamDictDetail["senderId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                            self.objSendMessage.mutParamDict["phoneNumber"] = ""
                            self.objSendMessage.mutParamDict["placeid"] = ""//dataDict.object(forKey: "place_id") as! String
                            self.objSendMessage.mutParamDict["name"] = dataDict.object(forKey: "name") as! String
                            
                            if let resDict = dataDict.object(forKey: "R") as? NSDictionary
                            {
                                if let res_id = resDict.object(forKey: "res_id")
                                {
                                    self.objSendMessage.mutMessageParamDictDetail["res_id"] = "\(res_id)"
                                }
                            }
                            self.objSendMessage.mutParamDict["url"] = ""
                            self.objSendMessage.mutParamDict["website"] = ""
                            self.objSendMessage.mutParamDict["websiteUrl"] = ""
                            self.objSendMessage.mutParamDict["open_now"] = ""
                            self.objSendMessage.mutMessageParamDictDetail["recieverDP"] = self.dictUserDetails["profilepic1"] as! String
                            self.objSendMessage.mutMessageParamDictDetail["senderDp"] = Constants.GlobalConstants.appDelegate.userDetail.profilepic1
                            self.objSendMessage.mutParamDict["priceRange"] = NSNumber.init(integerLiteral: 1)
                            self.objSendMessage.mutParamDict["posInList"] = NSNumber.init(integerLiteral: 0)
                            self.objSendMessage.mutParamDict["isSelected"] = NSNumber.init(booleanLiteral: false)
                            self.objSendMessage.mutParamDict["reference"] = ""//dataDict.object(forKey: "reference") as! String
                        }
                        if let dataTime =  (self.arrForRestaurants[i]["CarFirst"]) as? NSDictionary{
                            self.objSendMessage.mutParamDict["timeToReach"] = dataTime.object(forKey: "Difference") as! String
                        }
                        else
                        {
                            self.objSendMessage.mutParamDict["timeToReach"] = "No data available"
                        }
                        
                        self.objSendMessage.sendMessageToRecieverId(recieverId:"\(strReceiverId)",isFriend : false)
                    }
                }
                else
                {
                    if let msg = response.object(forKey: "message") as? String
                    {
                        Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast(msg)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        Constants.GlobalConstants.appDelegate.window?.rootViewController?.view.makeToast("Something went to wrong. Please try after sometime.")
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    func setFatchedRestaurantFromCoredata(){
        let cdm = CoreDataManage()
        print(dictUserDetails)
        if let otherId = dictUserDetails["id"] as? NSString{
            
            let frnd : FriendOtherDetail =  ((cdm.fetchFriendOtherDetailWithUserId(userId: otherId)).firstObject as! FriendOtherDetail)
            strChatId = frnd.chatId!
            if strChatId != ""{
                objSendMessage.addObserverForRecipteCHangeWithChatId(chatId: strChatId)
            }
            let arr = cdm.fetchMessageEntityWithOtherUserId(otherId: otherId, isMsgFormat: true)
            arrFetchedMessages = NSMutableArray.init(array: arr)
            
            if (arrFetchedMessages.count == 0) {
                objSendMessage.getAllMessagesDetailWithChatID(chatId: strChatId as NSString)
            }else{
                setViewWithSentMessageAndRestaurants(arrMessage: arrFetchedMessages)
            }}
    }
    
    func FireDataBaseAllMessagesDetail(snapshot: DataSnapshot, isAllMsgs: Bool) {
        if (snapshot.value as? NSDictionary) != nil {
            arrFetchedMessages.removeAllObjects()
            for i in snapshot.children{
                arrFetchedMessages.add((i as! DataSnapshot).value ?? 0)
            }
            self.setViewWithSentMessageAndRestaurants(arrMessage: arrFetchedMessages)
            let cdm = CoreDataManage()
            for i in arrFetchedMessages{
                cdm.updateMessageEntityWithMessageDict(msg: i as! NSDictionary)
            }
            
        }
        
    }
    func setViewWithSentMessageAndRestaurants(arrMessage : NSArray){
        arrForRestaurants.removeAll()
        for i in arrMessage{
            if let dict = i as? NSDictionary{
                if let str = dict["senderId"] as? String{
                if dict["senderId"] as! String != UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String{
                    if dict.object(forKey: "delivered") as! String == ""{
                        objSendMessage.sendDeliverTimestampForChatId(chatId: strChatId, msgKey: dict["key"] as! NSString)
                    }
                    if dict.object(forKey: "reciept") as! String == ""{
                        objSendMessage.sendRecipTimestampForChatId(chatId: strChatId, msgKey: dict["key"] as! NSString)
                    }
                    }}
                if let content : NSString = dict["contentType"] as? NSString{
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if content == "text"{
                    lblMessageDetail.text = dict["msg"] as? String
                }
                else if  content == "restaurant"{
                    if let dictRestro = dict.object(forKey: "restoVo") as? NSDictionary{
                        let ratings : String = dictRestro["ratings"] as! String
                        
                        let photoUrl : String = dictRestro["photoReference"] as! String
                        
                        let name : String = dictRestro["name"] as! String
                        let reference : String = dictRestro["reference"] as! String
                        let aDict: NSDictionary = ["RestName":name,"PhotoUrl":photoUrl,"Rating":ratings,"reference":reference]
                        let predicate: NSPredicate =  NSPredicate(format: "(reference contains[c] %@)", aDict["reference"] as! String)
                        //            do{
                        //                let arrPredicted : NSArray = try arrForRestaurants.filter(predicate)
                        //                        }catch{
                        //
                        //                        }
                        //if(arrForRestaurants.count == 0){
                            arrForRestaurants.append(dict as! [String : AnyObject])
                        //}
                    }
                }
                collectionViewFriendSuggestion.reloadData()
                }else{
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
            }
        }
    }
    func setCurrentUpdatedStatusOfOtherUser(snapshot: DataSnapshot) {
        
    }
    
    func otherUserIdStatusDetail(snapshot: DataSnapshot) {
        
    }
    
    func setMsgseenTickMarkForMessage(snapshot: DataSnapshot) {
        
    }
}
extension sentRequestRestaurantScreenVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! photoCollectionViewCell
        cell.viewBackCard.layer.shadowOpacity = 0.7
        cell.viewBackCard.layer.shadowOffset = CGSize.zero
        cell.viewBackCard.layer.shadowRadius = 3.0
        cell.viewBackCard.layer.shadowColor = UIColor.lightGray.cgColor
        
        
        if let dict1 = arrForRestaurants[indexPath.row]["RestaurantData"] as? NSDictionary{
            cell.lblFrndRestroName.text = dict1["name"] as? String
            if let photos = dict1["photos"] as? [[String:Any]]{
            let strRefre = photos.first
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(strRefre!["photo_reference"] as! String)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
                cell.imgFrndRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)}}
        else if let arr1 = arrForRestaurants[indexPath.row]["restoVo"] as? NSDictionary {
        cell.lblFrndRestroName.text = arr1["name"] as? String
            let str = arr1["photoReference"] as! String
        let url = NSURL(string: "\(str)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
        cell.imgFrndRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionViewFriendSuggestion.frame.width
            / 2) - 25, height: self.collectionViewFriendSuggestion.frame.height)
        
    }
    
}
