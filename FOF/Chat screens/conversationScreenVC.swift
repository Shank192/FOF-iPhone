//
//  conversationScreenVC.swift
//  FOF
//
//  Created by 360dts on 26/07/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import GrowingTextView
import Firebase
import FirebaseDatabase
import FirebaseStorage

class conversationScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,GrowingTextViewDelegate,FirebaseDelegate{
   
    @IBOutlet weak var tblConversation: UITableView!
    @IBOutlet weak var textViewMessage: GrowingTextView!
    @IBOutlet weak var nslcBottomTextView: NSLayoutConstraint!
    @IBOutlet weak var imgViewUserDp: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
    
    var arrMessages = NSMutableArray()
    var arrChatMsgs = NSMutableArray()
    var arrMsgByDates = NSMutableArray()
    var arrSenderString = [String]()
    var lastMsgKey = ""
    var lastMsgCount = 20
    var isLoadingPrev = false
    var dictUserDetail = NSDictionary()
    var chatGrpId:String = ""
    var senderId = ""
    var userId = ""
    var frndId = ""
    var receipentDp = ""
    var isFreind = Bool()
    var isGroup = false
    
    var userIsAvalable = false
    var strCount = Int()
    //Firebase
    var msgHandle : DatabaseHandle?
    var msgChangedHandle : DatabaseHandle?
    var rootRef = DatabaseReference()

    
    var myTypingRef : DatabaseReference?
    let objSendMessage = sendMessageServicesScreenVC()
    var objSentRestaurants : sentRestaurantsScreenVC?
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        objSendMessage.delegate = self
        //    chatGrpId = UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as? String ?? ""
        senderId = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
        userId = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
        if let profilepic1_thumb = dictUserDetail.object(forKey: "profilepic1") as? String
        {
            if profilepic1_thumb != ""
            {
                receipentDp = profilepic1_thumb//UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverDP) as? String ""
            }
            
        }
        
        
        if dictUserDetail.count > 0 && self.isGroup == false {
            self.lblLastSeen.isHidden = true
            if let dict = dictUserDetail as? NSDictionary{
                if let strDict = (dict.object(forKey: "details") as? NSArray){
                    let dict = strDict[0] as! NSDictionary
                    frndId = dict.object(forKey: "id") as! String
                    if let str = dict.object(forKey: "first_name")! as? String{
                        lblUserName.text = "\(str) \(dict.object(forKey: "last_name")! as! String)"
                    }
                }else{
                    if let friend_user_id = dictUserDetail.object(forKey: "friend_user_id")
                    {
                        frndId = "\(friend_user_id)"
                    }
                    else if let friend_user_id = dictUserDetail.object(forKey: "friend_id")
                    {
                        frndId = "\(friend_user_id)"
                    }
                    
                    if let str = dictUserDetail.object(forKey: "first_name")! as? String{
                        lblUserName.text = "\(str) \(dictUserDetail.object(forKey: "last_name")! as! String)"
                    }
                }
            }
            
        }
        else
        {
            if self.isGroup == true
            {
                if let member_ids = self.dictUserDetail.object(forKey: "member_ids")
                {
                    self.frndId = "\(member_ids)"
                }
                
                if let name = dictUserDetail.object(forKey: "name") as? String{
                    lblUserName.text = name
                }
                
                self.lblLastSeen.isHidden = true
            }
        }
        UserDefaults.standard.set(frndId, forKey: Constants.UserDefaults.receiverId)
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        rootRef = Database.database().reference()
        
        tblConversation.rowHeight = UITableViewAutomaticDimension
        tblConversation.estimatedSectionHeaderHeight = 0
        tblConversation.tableFooterView = UIView()
        self.tblConversation.separatorStyle = .none
        if  let str = receipentDp as? String{
            imgViewUserDp.sd_setImage(with: URL.init(string: str), placeholderImage: UIImage.init(named: "male"))
        }
        // Setup TextView
        self.textViewMessage.layer.cornerRadius = 13
        self.textViewMessage.clipsToBounds = true
        self.textViewMessage.maxLength = 160
        self.textViewMessage.trimWhiteSpaceWhenEndEditing = false
        self.textViewMessage.placeholder =  "Type your message here..."
        self.textViewMessage.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        self.textViewMessage.minHeight = 49.0
        self.textViewMessage.maxHeight = 120.0
        self.textViewMessage.textContainerInset = .init(top: 15, left: 12, bottom: 13, right: 48)
        self.textViewMessage.delegate = self
        
        
        
        if isFreind{
            
        }else{
            addRestaurants()
            return
        }
        
        // Setup Formatter
        observeMessages()
        
        objSendMessage.getStatusDetailOfUserId(otherUserId:frndId,chatId:chatGrpId)
//        objSendMessage.addObserverForStatusUpdateforChatId(chatId:self.frndId)
        objSendMessage.addObserverForRecipteCHangeWithChatId(chatId:chatGrpId)
        objSendMessage.addObserverForRealTimeChatting(chatGrpId: chatGrpId)
        Constants.GlobalConstants.appDelegate.online()
    }
  
    
    func setCurrentUpdatedStatusOfOtherUser(snapshot : DataSnapshot){
        if snapshot.key == frndId{
            if snapshot.value(forKey: "status") as! String == "Offline"{
                lblLastSeen.text = "Offline"
            }else if snapshot.value(forKey: "status") as! String == "Online"{
                lblLastSeen.text = "Online"
            }else{
                lblLastSeen.text = "Typing..."
            }
        }
        
    }
    func setMsgseenTickMarkForMessage(snapshot: DataSnapshot) {
        
    }
    func FireDataBaseAllMessagesDetail(snapshot: DataSnapshot, isAllMsgs: Bool)
    {
        
    }
    func otherUserIdStatusDetail(snapshot: DataSnapshot) {
        if let arr = snapshot.value as? NSDictionary{
            let str = arr.object(forKey: "status") as! String
            if str == "Offline"{
                if let myInteger = Int(arr.object(forKey: "lastSeen")! as! String) {
                    let str = NSNumber(value: myInteger)
                    self.lblLastSeen.text = "Last seen \( getTimeFromTimeStamp(timestamp:str))"
                }
                else
                {
                    self.lblLastSeen.text = "Offline"
                }
            }else if str == "Online"{
                lblLastSeen.text = "Online"
                
            }
            else if str == "typing..."
            {
                lblLastSeen.text = "Typing..."
            }
        }else{
            lblLastSeen.text = "Offline"
        }
    }
    func sendRestaurants(arrRestaurants : NSArray , strMessage : String){
        print(arrRestaurants)
        print(strMessage)
        reloadTablview(arrRestaurants : arrRestaurants)
    }
    func reloadTableviewWithTextMessage(strTextMessage : String ,isIncoming : Bool){
        Constants.GlobalConstants.appDelegate.online()

        objSendMessage.setDictFormatForWriteDataDefault()
        updateFirebaseDictForTextMessage(strMsgText: strTextMessage)
        if isIncoming{
            
        }else{
            objSendMessage.mutMessageParamDictDetail["senderId"] = senderId
            objSendMessage.mutMessageParamDictDetail["recieverId"] = frndId
            objSendMessage.mutMessageParamDictDetail["recieverDP"] = receipentDp
            objSendMessage.mutMessageParamDictDetail["senderDp"] = Constants.GlobalConstants.appDelegate.userDetail.profilepic1
            objSendMessage.mutParamDict["priceRange"] = NSNumber.init(integerLiteral: 1)
            objSendMessage.mutParamDict["posInList"] = NSNumber.init(integerLiteral: 0)
            objSendMessage.mutParamDict["isSelected"] = NSNumber.init(booleanLiteral: false)
            objSendMessage.sendMessageToRecieverId(recieverId: frndId, isFriend: true, chatGrpID: self.chatGrpId)
        }
        
    }
    func updateFirebaseDictForTextMessage(strMsgText : String){
        objSendMessage.mutMessageParamDictDetail["contentType"] = "text"
        objSendMessage.mutMessageParamDictDetail["msg"] = strMsgText
        objSendMessage.mutMessageParamDictDetail["timeStamp"] = setCurrentTimeToTimestamp()
    }
    func reloadTablview(arrRestaurants : NSArray){
        objSendMessage.setDictFormatForWriteDataDefault()
        print(arrRestaurants)
        for i in 0..<arrRestaurants.count {
            var strPhotoUrl = String()
            
            if let CarFirst =  (arrRestaurants.object(at: i) as AnyObject).object(forKey: "CarFirst") as? NSDictionary
            {
                if let Difference = CarFirst.object(forKey: "Difference")
                {
                    objSendMessage.mutMessageParamDictDetail["timeToReach"] = Difference
                }
            }
            
            if let dataDict =  (arrRestaurants.object(at: i) as AnyObject).object(forKey: "RestaurantData") as? NSDictionary{
                if let photourl = dataDict["thumb"] as? String
                {
                    strPhotoUrl = photourl
                }
                
                objSendMessage.mutMessageParamDictDetail["msg"] = "you received a restaurant suggestion"
                objSendMessage.mutParamDict["vicinity"] = dataDict.object(forKey: "vicinity") as? String
                objSendMessage.mutParamDict["photoReference"] = strPhotoUrl
                objSendMessage.mutMessageParamDictDetail["contentType"] = "restaurant"
                objSendMessage.mutMessageParamDictDetail["timeStamp"] = setCurrentTimeToTimestamp() + i
                objSendMessage.mutParamDict["name"] = dataDict.object(forKey: "name") as! String
                if let geometry = dataDict.object(forKey: "location") as? NSDictionary{
                    if let lat = geometry.object(forKey: "latitude"),let longi = geometry.object(forKey: "longitude")
                    {
                        objSendMessage.mutParamDict["latitude"] = String(describing: lat)
                        objSendMessage.mutParamDict["longitude"] = String(describing: longi)
                        
                    }
                    
                }
                
                if let user_rating = dataDict.object(forKey: "user_rating") as? NSDictionary
                {
                    if let aggregate_rating = user_rating.object(forKey: "aggregate_rating")
                    {
                        objSendMessage.mutParamDict["ratings"] = String(describing: aggregate_rating)
                    }
                }
                
                objSendMessage.mutMessageParamDictDetail["recieverId"] = frndId
                objSendMessage.mutMessageParamDictDetail["senderId"] = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                objSendMessage.mutParamDict["phoneNumber"] = ""
                if let rdict = dataDict.object(forKey: "R") as? NSDictionary
                {
                    if let rest_id = rdict.object(forKey: "res_id")
                    {
                        objSendMessage.mutParamDict["restid"] = "\(rest_id)"
                    }
                    else
                    {
                        if let reid = dataDict.object(forKey: "id")
                        {
                            objSendMessage.mutParamDict["restid"] = "\(reid)"
                        }
                        
                    }
                }
                else
                {
                    if let reid = dataDict.object(forKey: "id")
                    {
                        objSendMessage.mutParamDict["restid"] = "\(reid)"
                    }
                }
                
                if let location = dataDict.object(forKey: "location") as? NSDictionary
                {
                    if let address = location.object(forKey: "address") as? String
                    {
                        objSendMessage.mutParamDict["formatted_address"] = address
                    }
                }
                
                objSendMessage.mutParamDict["name"] = dataDict.object(forKey: "name") as! String
                objSendMessage.mutParamDict["url"] = ""
                objSendMessage.mutParamDict["website"] = ""
                objSendMessage.mutParamDict["websiteUrl"] = ""
                objSendMessage.mutParamDict["open_now"] = ""
                objSendMessage.mutMessageParamDictDetail["recieverDP"] = receipentDp
                objSendMessage.mutMessageParamDictDetail["senderDp"] = Constants.GlobalConstants.appDelegate.userDetail.profilepic1
                objSendMessage.mutParamDict["priceRange"] = NSNumber.init(integerLiteral: 1)
                objSendMessage.mutParamDict["posInList"] = NSNumber.init(integerLiteral: 0)
                objSendMessage.mutParamDict["isSelected"] = NSNumber.init(booleanLiteral: false)
                objSendMessage.mutParamDict["reference"] = dataDict.object(forKey: "reference") as? String ?? ""
            }
            if let dataTime =  (arrRestaurants.object(at: i) as AnyObject).object(forKey: "CarFirst") as? NSDictionary{
                objSendMessage.mutParamDict["timeToReach"] = dataTime.object(forKey: "Difference") as! String
            }
            else
            {
                self.objSendMessage.mutParamDict["timeToReach"] = "No data available"
            }
            objSendMessage.sendMessageToRecieverId(recieverId:frndId,isFriend : true, chatGrpID: self.chatGrpId)
        }
    }
   
    func addRestaurants(){
        objSentRestaurants = self.storyboard?.instantiateViewController(withIdentifier: "sentRestaurantsScreenVC") as? sentRestaurantsScreenVC
        if isFreind{
            objSentRestaurants!.isfrind = true
        }else{
            objSentRestaurants!.isfrind = false
        }
        
        objSentRestaurants?.dictUserDetail = dictUserDetail
        addChildViewController(objSentRestaurants!)
        objSentRestaurants!.view.frame(forAlignmentRect: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:self.view.frame.size.height))
                self.view.addSubview(objSentRestaurants!.view)
                objSentRestaurants?.didMove(toParentViewController: self)
    }
    
    //MARK: - Firebase observe message without chack delete
    fileprivate func observeMessages() {
        
        if msgHandle != nil
        {
            rootRef.removeObserver(withHandle: msgHandle!)
            
        }
        msgHandle = rootRef.child("messages").child(chatGrpId).queryOrderedByKey().observe(DataEventType.childAdded, with: { (snapshot) in
            if let dataDict : NSDictionary = snapshot.value as? NSDictionary {
                let newDict = NSMutableDictionary(dictionary: dataDict)
                newDict.setObject(snapshot.key, forKey: "messageID" as NSCopying)
                print(newDict)
                print(snapshot.key)
                print(snapshot.value ?? "No snaop value in message")
                let myPredicate = NSPredicate(format: "SELF.messageID ==[c] %@", "\(snapshot.key)")
                let foundMsg = self.arrChatMsgs.filtered(using: myPredicate)
                if foundMsg.count == 0 {
                    if self.lastMsgKey.count == 0 {
                        self.lastMsgKey = "\(snapshot.key)"
                    }
                    if let sender_id = dataDict.object(forKey: "senderId") as? String {
                        if sender_id != self.senderId {
                            
                            if "\(dataDict.object(forKey: "delivered") ?? "")" == ""{
                                self.sendDeliverTimestampForChatId(chatId: self.chatGrpId, msgKey: "\(snapshot.key)" as NSString)
                            }
                            if "\(dataDict.object(forKey: "reciept") ?? "")" == ""{
                                self.sendRecipTimestampForChatId(chatId: self.chatGrpId, msgKey: "\(snapshot.key)" as NSString)
                            }
                            
                            //                            if let isReadFlag = dataDict.object(forKey: "is_read") {
                            //
                            //                                if "\(isReadFlag)" == "0" {
                            //
                            //                                    let temp = NSMutableDictionary(dictionary: dataDict)
                            //                                    if self.userIsAvalable == true
                            //                                    {
                            //                                        temp.setValue(1, forKey: "is_read")
                            //                                        self.rootRef.child("messages").child(self.chatGrpId).child(snapshot.key).setValue(temp)
                            //                                    }
                            //
                            //                                }
                            //
                            //                            } else {
                            //                                let temp = NSMutableDictionary(dictionary: dataDict)
                            //                                if self.userIsAvalable == true{
                            //                                    temp.setValue(1, forKey: "is_read")
                            //                                    self.rootRef.child("messages").child(self.chatGrpId).child(snapshot.key).setValue(temp)}
                            //                            }
                        }
                    }
                    self.arrChatMsgs.add(newDict)
                   self.sortArrayByDate(dataDict: newDict)
                }
            }
            if self.userIsAvalable == true
            {
                //self.SetZeroUnreadCount()
            }
        })
        //self.observeValueChared()
    }
    
    
    func sendDeliverTimestampForChatId(chatId : String , msgKey : NSString){
        var strPathChange = String()
        if msgKey == ""{
            return
        }
        if chatId != ""{
            strPathChange = "messages/\(chatId)/\(msgKey)/delivered"
        }
        let refChange : DatabaseReference = Database.database().reference(withPath: strPathChange)
        let str = String(describing: setCurrentTimeToTimestamp())
        refChange.setValue(str)
    }
    
    func sendRecipTimestampForChatId(chatId : String , msgKey : NSString){
        var strPathChange = String()
        if msgKey == ""{
            return
        }
        if chatId != ""{
            strPathChange = "messages/\(chatId)/\(msgKey)/reciept"
        }
        let refChange : DatabaseReference = Database.database().reference(withPath: strPathChange)
        let str = String(describing: setCurrentTimeToTimestamp())
        refChange.setValue(str)
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func btnSendAct(_ sender: Any) {
        guard let text = self.textViewMessage.text, !text.isEmpty else {
            return
        }
        if textViewMessage.text != ""{
            reloadTableviewWithTextMessage(strTextMessage: self.textViewMessage.text!, isIncoming: false)
        }
        textViewMessage.text = ""
    }
    @IBAction func btnSendAttachmentAct(_ sender: Any) {
        addRestaurants()
    }
    func backButtonRestraunt(){
        objSentRestaurants?.view.alpha = 0
        nslcBottomTextView.constant = 0
    }
    @IBAction func btnBackAct(_ sender: Any) {
        Constants.GlobalConstants.appDelegate.offline()
        if self.isGroup == true
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    //MARK:- Sort Array
    func sortArrayByDate(dataDict: NSDictionary) {

        if let msgTime = dataDict.object(forKey: "timeStamp") {
            let msgDate : Date = Date(timeIntervalSince1970: TimeInterval(truncating: ((msgTime as! Double)/1000) as NSNumber))
            let myFormater = DateFormatter()
            myFormater.dateFormat = "dd/MM/yyyy"
            myFormater.timeZone = TimeZone.ReferenceType.local
            let strTimeToShow = myFormater.string(from: msgDate)
            
            
//           let myFormater = DateFormatter()
//            myFormater.dateFormat = "dd-MM-yyyy HH:mm:ss"
//
//            let strTimeToShow = getDate(msgTime: msgTime)
            
            let myPredicate = NSPredicate(format: "SELF.msgDate ==[c] %@", strTimeToShow)
            
            let foundMsg = self.arrMsgByDates.filtered(using: myPredicate)
            
            // print(strTimeToShow + "found \(foundMsg.count)")
            
            if foundMsg.count == 0 {
                
                let newDict = NSMutableDictionary()
                newDict.setObject(strTimeToShow, forKey: "msgDate" as NSCopying)
                newDict.setObject(arrMsgByDates.count, forKey: "IndexVal" as NSCopying)
                
                let newArr = NSMutableArray()
                newArr.add(dataDict)
                
                newDict.setObject(newArr, forKey: "MsgRows" as NSCopying)
                
                arrMsgByDates.add(newDict)
                
                
            } else {
                
                let newDict = NSMutableDictionary(dictionary: foundMsg[0] as! NSDictionary)
                
                let IndexVal = newDict.object(forKey: "IndexVal") as! Int
                
                let MsgRows = NSMutableArray(array: newDict.object(forKey: "MsgRows") as! NSArray)
                
                MsgRows.add(dataDict)
                
                newDict.setObject(MsgRows, forKey: "MsgRows" as NSCopying)
                
                arrMsgByDates.replaceObject(at: IndexVal, with: newDict)
                
            }
            
            
            let sortedMainArray = arrMsgByDates.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
                
                if let dict1 : NSDictionary = obj1 as? NSDictionary {
                    
                    if let dict2 : NSDictionary = obj2 as? NSDictionary {
                        
                        if let time1 : String = dict1.object(forKey: "msgDate") as? String, let time2 : String = dict2.object(forKey: "msgDate") as? String {
                            
                            if let date1 = myFormater.date(from: time1) {
                                
                                if let date2 = myFormater.date(from: time2) {
                                    return date1.compare(date2)
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                return .orderedSame
            })
            
            self.arrMsgByDates = NSMutableArray(array: sortedMainArray)
            
            print("Array msg  : \(self.arrMsgByDates)")
            
            DispatchQueue.main.async(execute: {
                self.tblConversation.reloadData()
                self.scrollToBottom()

                
            })
            
            if dataDict.object(forKey: "sender_id") as? String == senderId && self.arrChatMsgs.count <= 20 {
                
                let lastDict = self.arrMsgByDates.lastObject as! NSDictionary
                
                
                
                if let MsgRows = lastDict.object(forKey: "MsgRows") as? NSArray {
                    let lastSection = self.arrMsgByDates.count - 1
                    
                    let lastrow = MsgRows.count - 1
                    
                    if lastrow >= 0 {
                        DispatchQueue.main.async(execute: {
                            self.tblConversation.scrollToRow(at: IndexPath(row: lastrow, section: lastSection), at: UITableViewScrollPosition.bottom, animated: false)
                            
                        })
                    }
                }
                
            } else {
                
                if self.tblConversation.contentOffset.y >= (self.tblConversation.contentSize.height - self.tblConversation.frame.size.height) {
                    
                    let lastDict = self.arrMsgByDates.lastObject as! NSDictionary
                    
                    if let MsgRows = lastDict.object(forKey: "MsgRows") as? NSArray {
                        let lastSection = self.arrMsgByDates.count - 1
                        
                        let lastrow = MsgRows.count - 1
                        
                        if lastrow >= 0 {
                            DispatchQueue.main.async(execute: {
                                self.tblConversation.scrollToRow(at: IndexPath(row: lastrow, section: lastSection), at: UITableViewScrollPosition.bottom, animated: false)
                            })
                        }
                    }
                    
                }
            }
            
        }
        tblConversation.reloadData()
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            self.tblConversation.scrollRectToVisible(CGRect(x: 1, y: 1, width: self.tblConversation.contentSize.width, height: self.tblConversation.contentSize.height - 20), animated: true)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        scrollToBottom()
        self.view.layoutIfNeeded()

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        Constants.GlobalConstants.appDelegate.Typing()
        scrollToBottom()
        self.view.layoutIfNeeded()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        Constants.GlobalConstants.appDelegate.online()
    }

    // MARK: - Tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrMsgByDates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let MsgRows : NSArray = (arrMsgByDates.object(at: section) as AnyObject).object(forKey: "MsgRows") as? NSArray {
            strCount = MsgRows.count
            return MsgRows.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let sectionDict = arrMsgByDates.object(at: indexPath.section) as? NSDictionary {
            
            if let MsgRows = sectionDict.object(forKey: "MsgRows") as? NSArray {
                
                
                if let rowDict = MsgRows.object(at: indexPath.row) as? NSDictionary {
                    
                    if let sender_id = rowDict.object(forKey: "senderId") as? String {
                        
                        var strTimeToShow = ""
                        
                        if let msgTime = rowDict.object(forKey: "timeStamp") {
                            
                            strTimeToShow = getTimeFromTimeStamp(timestamp: msgTime)
                        }
                        if rowDict.object(forKey: "contentType") as? String == "restaurant"{
                            if sender_id == userId {
                                if let array = rowDict.object(forKey: "restoVo") as? NSDictionary{
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "restroCell", for: indexPath) as! chatTableviewCell
                                    cell.selectionStyle = .none
                                    cell.lblRestroName.text = array.object(forKey: "name") as? String
                                    cell.lblRestroAddress.text = array.object(forKey: "formatted_address") as? String
                                    let rating = array.object(forKey: "ratings") as! String
                                    var rateInt = 0
                                    if rating != ""
                                    {
                                        let doubleValue = Double(rating)!
                                        rateInt = Int(doubleValue.rounded())
                                    }
                                    switch rateInt {
                                    case 1:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 2:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 3:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 4:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 5:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        break
                                    default:
                                        break
                                    }
                                    if let photos = array.object(forKey: "photoReference") as? String{
                                        
                                        if photos != ""
                                        {
                                            let url = NSURL(string: photos)!  as URL
                                            cell.imgRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
                                        }
                                        else
                                        {
                                            cell.imgRestro.image = UIImage.init(named: "placeHolderRestraunt")
                                        }
                                        
                                        
                                    }
                                    cell.lblRestroTime.text = strTimeToShow
                                    cell.imgReadRestroTick.isHidden = false
                                    if  (String(describing:rowDict.object(forKey: "reciept")!)).count != 0{
                                        cell.imgReadRestroTick.setImage(UIImage(named: "red_double"), for: .normal)
                                    }else if (String(describing:rowDict.object(forKey: "delivered") ?? "")).count != 0{
                                        cell.imgReadRestroTick.setImage(UIImage(named: "red_single"), for: .normal)
                                    }else{
                                        cell.imgReadRestroTick.setImage(UIImage(named: "black_single"), for: .normal)
                                    }
                                    return cell
                                }
                                
                            }else{
                                if let array = rowDict.object(forKey: "restoVo") as? NSDictionary{
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "restroSenderCell", for: indexPath) as! chatTableviewCell
                                    cell.selectionStyle = .none
                                    cell.lblRestroName.text = array.object(forKey: "name") as? String
                                    cell.lblRestroAddress.text = array.object(forKey: "formatted_address") as? String
                                    let rating = array.object(forKey: "ratings") as! String
                                    
                                    var rateInt = 0
                                    if rating != ""
                                    {
                                        let doubleValue = Double(rating)!
                                        rateInt = Int(doubleValue.rounded())
                                    }
                                    
                                    switch rateInt {
                                    case 1:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 2:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 3:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 4:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case 5:
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        break
                                    default:
                                        break
                                    }
                                    cell.imgReadRestroTick.isHidden = true
                                    if  (String(describing:rowDict.object(forKey: "reciept")!)).count != 0{
                                        cell.imgReadRestroTick.setImage(UIImage(named: "red_double"), for: .normal)
                                    }else if (String(describing:rowDict.object(forKey: "delivered") ?? "")).count != 0{
                                        cell.imgReadRestroTick.setImage(UIImage(named: "red_single"), for: .normal)
                                    }else{
                                        cell.imgReadRestroTick.setImage(UIImage(named: "black_single"), for: .normal)
                                    }
                                    cell.lblRestroTime.text = strTimeToShow
                                    if let photos = array.object(forKey: "photoReference") as? String{
                                        
                                        if photos != ""
                                        {
                                            let url = NSURL(string: photos)!  as URL
                                            cell.imgRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
                                        }
                                        else
                                        {
                                            cell.imgRestro.image = UIImage.init(named: "placeHolderRestraunt")
                                        }
                                        
                                    }
                                    return cell
                                }}}
                        else if rowDict.object(forKey: "contentType") as? String == "text"{
                            if sender_id == userId {
                                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
                                cell.selectionStyle = .none
                                cell.lblReceiverMessage.text = rowDict.object(forKey: "msg") as? String
                                cell.lblReceiverTime.text = strTimeToShow
                                cell.imgReadTick.isHidden = false
                                if  (String(describing:rowDict.object(forKey: "reciept") ?? "")).count != 0{
                                    cell.imgReadTick.setImage(UIImage(named: "red_double"), for: .normal)
                                }else if (String(describing:rowDict.object(forKey: "delivered") ?? "")).count != 0{
                                    cell.imgReadTick.setImage(UIImage(named: "red_single"), for: .normal)
                                }else{
                                    cell.imgReadTick.setImage(UIImage(named: "black_single"), for: .normal)
                                }
                                
                                return cell
                            } else {
                                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! chatTableviewCell
                                cell.selectionStyle = .none
                                cell.lblSenderTime.text = strTimeToShow
                                cell.lblMessages.text = rowDict.object(forKey: "msg") as? String
                                cell.imgSenderDp.image = UIImage.init(named: "disableSingle")
                                if let proURL = URL.init(string: "\(receipentDp)")
                                {
                                    cell.imgSenderDp.sd_setImage(with: proURL)
                                }
                                cell.imgSenderReadTick.isHidden = true
                                if  (String(describing:rowDict.object(forKey: "reciept") ?? "")).count != 0{
                                    cell.imgSenderReadTick.setImage(UIImage(named: "red_double"), for: .normal)
                                }else if (String(describing:rowDict.object(forKey: "delivered") ?? "")).count != 0{
                                    cell.imgSenderReadTick.setImage(UIImage(named: "red_single"), for: .normal)
                                }else{
                                    cell.imgSenderReadTick.setImage(UIImage(named: "black_single"), for: .normal)
                                }
                                return cell
                            }}
                    }
                }
            }}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let sectionDict = arrMsgByDates.object(at: indexPath.section) as? NSDictionary {
            
            if let MsgRows = sectionDict.object(forKey: "MsgRows") as? NSArray {
                
                
                if let rowDict = MsgRows.object(at: indexPath.row) as? NSDictionary {
                    
                    if rowDict.object(forKey: "contentType") as? String == "restaurant"{
                        
                        print(rowDict)
                        
                        if let dict = rowDict["restoVo"] as? [String : AnyObject]
                        {
                            
                            let MuteBudsDict = NSMutableDictionary(dictionary: dict)
                            MuteBudsDict.setValue(dict, forKey: "isSelected")
                            
                            let obj = storyboard?.instantiateViewController(withIdentifier: "selectedRestaurantDeatilsScreenVC") as! selectedRestaurantDeatilsScreenVC
                            if UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude) != nil && UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude) != nil
                            {
                                obj.usercurrentLocation = CLLocation.init(latitude: Double("\(UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLatitude)!)")!, longitude: Double("\(UserDefaults.standard.object(forKey: Constants.UserDefaults.currentLongitude)!)")!)
                            }
                            
                            if let timeToReach = dict["timeToReach"]{
                                    obj.strTime = "\(timeToReach)"
                            }
                            obj.isFromChatScreen = true
                            obj.arrOfRestaurantData = MuteBudsDict as! [String : AnyObject]
                            self.navigationController?.pushViewController(obj, animated: false)
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
   
    // MARK: - keyboard actions
    
    func registerForKeyboardNotifications () {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWasHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWasHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardWasHide(_ aNotification: Notification) {
        let _: NSDictionary = aNotification.userInfo! as NSDictionary
        if self.arrMessages.count > 0 {
            if let sectionDict = self.arrMessages.lastObject as? NSDictionary{
                
                if let MsgRows = sectionDict.object(forKey: "MsgRows") as? NSArray
                {
                    let topIndexPath = IndexPath(row: (MsgRows.count - 1), section: self.arrMessages.count - 1)
                    self.tblConversation.scrollToRow(at: topIndexPath, at: .none, animated: true)
                }
            }
            
        }
         nslcBottomTextView.constant  = 10 // Move view to original position
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        }, completion: { (finished : Bool) -> Void in
            
        })
    }
    
    @objc func keyboardWasShown(_ aNotification: Notification) {
        let info: NSDictionary = aNotification.userInfo! as NSDictionary
        let kbSize : CGRect = (info.object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        if self.arrMessages.count > 0 {
            if let sectionDict = self.arrMessages.lastObject as? NSDictionary{
                
                if let MsgRows = sectionDict.object(forKey: "MsgRows") as? NSArray
                {
                    let topIndexPath = IndexPath(row: (MsgRows.count - 1), section: self.arrMessages.count - 1)
                    self.tblConversation.scrollToRow(at: topIndexPath, at: .none, animated: true)
                }
            }
        }
        if #available(iOS 11.0, *) {
            nslcBottomTextView.constant = kbSize.height - self.view.safeAreaInsets.bottom
        } else {
            nslcBottomTextView.constant = kbSize.height - 40        }
tblConversation.reloadData()
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
     
        }, completion: { (finished : Bool) -> Void in
            
        })
    }
}
