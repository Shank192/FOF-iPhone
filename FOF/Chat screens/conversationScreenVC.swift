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

class conversationScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,GrowingTextViewDelegate{

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
    
    var chatGrpId:String = ""
    var senderId = ""
    var frndId = ""
    var receipentDp = ""
    var isFrndOnline = false
    var strReceiverName = String()
    var userIsAvalable = false
    
    //Firebase
    var msgHandle : DatabaseHandle?
    var msgChangedHandle : DatabaseHandle?
    var rootRef = DatabaseReference()
    var storageRef = StorageReference()
    var storage = Storage.storage()
    
    var onlineRef = DatabaseReference()
    var typingRef = DatabaseReference()
    
    var myTypingRef : DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
  func initialSetup() {
    chatGrpId = UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as! String
    senderId = UserDefaults.standard.object(forKey: Constants.UserDefaults.senderId) as! String
    frndId = UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverId) as! String
    receipentDp = UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverDP) as! String
    lblUserName.text = strReceiverName
    
    hideKeyboardWhenTappedAround()
    registerForKeyboardNotifications()
        rootRef = Database.database().reference()
        //        storageRef = storage.reference(forURL: "gs://the-qn-app.appspot.com")
        
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
    
        // Setup Formatter
    observeMessages()
    CheckOnlineOfflineStatus()
    addObserverOnlineOfflineStatus()
    addObserverForRealTimeChatting()
    Constants.GlobalConstants.appDelegate.online()
    }
    
    @IBAction func btnSendAct(_ sender: Any) {
        guard let text = self.textViewMessage.text, !text.isEmpty else {
            return
        }
        Constants.GlobalConstants.appDelegate.online()
        
        let message = textViewMessage?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (message?.count)! > 0 {
            
            if chatGrpId.count > 0 {
                
             
                
                //1
                let param = ["senderId":senderId,"msg":textViewMessage!.text!,"timeStamp":setCurrentTimeToTimestamp(),"imgUrl":"","recieverId":frndId,"recieverDP":UserDefaults.standard.object(forKey: Constants.UserDefaults.receiverDP) as! String,"senderDp":"","contentType":"text"] as [String : Any]
                
                rootRef.child("messages").child(chatGrpId).childByAutoId().setValue(param)
                
                //Set Conversation
                //2
                
                //self.setUnreadCount(pluseCount: 1, lastMsg: textViewMessage!.text!)
                
                
                
                
               // self.sendNotificationTofrnd(message: textViewMessage!.text!)
                
                
                //  self.sendChatNotification(msg: txtMsgView!.text!, isImage: 0, isVideo: 0)
                
                textViewMessage?.text = ""
            }
        }
    }
    
    @IBAction func btnSendAttachmentAct(_ sender: Any) {
        
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
                            
                            if let isReadFlag = dataDict.object(forKey: "is_read") {
                                
                                if "\(isReadFlag)" == "0" {
                                    
                                    let temp = NSMutableDictionary(dictionary: dataDict)
                                    if self.userIsAvalable == true
                                    {
                                        temp.setValue(1, forKey: "is_read")
                                        self.rootRef.child("messages").child(self.chatGrpId).child(snapshot.key).setValue(temp)
                                    } } } else {
                                let temp = NSMutableDictionary(dictionary: dataDict)
                                if self.userIsAvalable == true{
                                    temp.setValue(1, forKey: "is_read")
                                    self.rootRef.child("messages").child(self.chatGrpId).child(snapshot.key).setValue(temp)}
                            }
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
    func addObserverOnlineOfflineStatus()
    {
        Database.database().reference(withPath: "status/\(chatGrpId)").observe(.childChanged) { (snapshot) in
           // print("frnd : \(snapshot.key) \(String(describing: snapshot.value))")
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
                if  let strKey = snapshot.key as? String{
            if strKey == self.senderId{
                if let strOnline = DataDict.value(forKey: "status")! as? String{
                    if strOnline == "Offline"{
                        if let strTimeStamp = DataDict.value(forKey: "lastSeen")! as? String{
                        if let myInteger = Int(strTimeStamp) {
                            let str = NSNumber(value: myInteger)
                         //   self.lblLastSeen.text = "Last seen \( getTimeFromTimeStamp(timestamp:str))"
                            }}
                    }else{
                       // self.lblLastSeen.text = strOnline
                    } }
                    }
            }
            }
        }
    }
    func addObserverForRealTimeChatting()
    {
       Database.database().reference(withPath: "messages/\(chatGrpId)").observe(.childAdded) { (snapshot) in
            print("frnd : \(snapshot.key) \(String(describing: snapshot.value))")
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
            }
        }
    }
    
    func CheckOnlineOfflineStatus()
    {
        Database.database().reference(withPath: "status/\(chatGrpId)/\(frndId)").observe(.value) { (snapshot) in
            // print("frnd : \(snapshot.key) \(String(describing: snapshot.value))")
                        if let DataDict = snapshot.value as? NSDictionary
                        {
                           // let arrayKey = DataDict.allKeys
                            if let strOnline = DataDict.value(forKey: "status")! as? String{
                                if strOnline == "Offline"{
                                    if let myInteger = Int(DataDict.value(forKey: "lastSeen")! as! String) {
                                        let str = NSNumber(value: myInteger)
                                        self.lblLastSeen.text = "Last seen \( getTimeFromTimeStamp(timestamp:str))"
                                    }
                                    
                                }else{
                                    self.lblLastSeen.text = strOnline}}
                        }else{
                             self.lblLastSeen.text = ""
            }
        }
    }
    //MARK:- Sort Array
    func sortArrayByDate(dataDict: NSDictionary) {

        if let msgTime = dataDict.object(forKey: "timeStamp") {
            let msgDate : Date = Date(timeIntervalSince1970: TimeInterval(((msgTime as! Double)/1000) as NSNumber))
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
        //        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    @IBAction func btnBackAct(_ sender: Any) {
        Constants.GlobalConstants.appDelegate.offline()
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        Constants.GlobalConstants.appDelegate.Typing()
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
                        
                        if sender_id == senderId {
                            if rowDict.object(forKey: "msg") as? String == "you received a restaurant suggestion"{
                              
                               if let array = rowDict.object(forKey: "restoVo") as? NSDictionary{
                                  let cell = tableView.dequeueReusableCell(withIdentifier: "restroCell", for: indexPath) as! chatTableviewCell
                                cell.selectionStyle = .none
                                cell.lblRestroName.text = array.object(forKey: "name") as? String
                                cell.lblRestroAddress.text = array.object(forKey: "vicinity") as? String
                                let rating = array.object(forKey: "ratings") as! String
                                switch rating {
                                case "1":
                                    cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta2Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    break
                                case "2":
                                    cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    break
                                case "3":
                                    cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    break
                                case "4":
                                    cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                    cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                    break
                                case "5":
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

                                    let url = NSURL(string: "\(photos)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
                                    cell.imgRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
                                    
                                }
                                return cell
                                }}
                               else{
                                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
                                cell.selectionStyle = .none
                                cell.lblReceiverMessage.text = rowDict.object(forKey: "msg") as? String
                                cell.lblReceiverTime.text = strTimeToShow

                                //cell.imgSenderDp.image = UIImage.init(named: "disableSingle")
                                if  let str = Constants.GlobalConstants.appDelegate.userDetail.profilepic1{
                                    cell.imgReceiverDp.sd_setImage(with: URL.init(string: str), placeholderImage: UIImage.init(named: "male"))
                                }
                              
                                return cell}
                        } else {
                            if rowDict.object(forKey: "msg") as? String == "you received a restaurant suggestion"{
                                
                                if let array = rowDict.object(forKey: "restoVo") as? NSDictionary{
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "restroSenderCell", for: indexPath) as! chatTableviewCell
                                    cell.selectionStyle = .none
                                    cell.lblRestroName.text = array.object(forKey: "name") as? String
                                    cell.lblRestroAddress.text = array.object(forKey: "vicinity") as? String
                                    let rating = array.object(forKey: "ratings") as! String
                                    switch rating {
                                    case "1":
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case "2":
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case "3":
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case "4":
                                        cell.btnSta1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
                                        cell.btnSta5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
                                        break
                                    case "5":
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
                                        
                                        let url = NSURL(string: "\(photos)&key=\(Constants.GoogleKey.kGoogle_Key)")!  as URL
                                        cell.imgRestro.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: .retryFailed)
                                        
                                    }
                                    return cell
                                }}else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! chatTableviewCell
                            cell.selectionStyle = .none
                            cell.lblSenderTime.text = strTimeToShow

                            cell.lblMessages.text = rowDict.object(forKey: "msg") as? String
                         cell.imgSenderDp.image = UIImage.init(named: "disableSingle")
                            
                            if let proURL = URL.init(string: "\(receipentDp)")
                            {
                                cell.imgSenderDp.sd_setImage(with: proURL)
                            }
                            return cell
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        return cell!
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
