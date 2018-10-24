//
//  contactScreenVC.swift
//  FOF
//
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class contactScreenVC: UIViewController , UITableViewDelegate , UITableViewDataSource,FirebaseDelegate {
   
    let objSendMessage = sendMessageServicesScreenVC()
    

    var arrPendingUserDetails = NSMutableArray()
    var arrContactList = NSMutableArray()
    var ArrayFriendData = NSMutableArray()
    var isFirstTime = true
    @IBOutlet weak var tblViewFrndList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWsGetPendingList()
        self.navigationController?.isNavigationBarHidden = true
        objSendMessage.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        wsSetFriendsList()
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - webService
   
    func wsSetFriendsList(){
    MBProgressHUD.showAdded(to: self.view, animated: true)
        let obj = getFriendsScreen()
        obj.wsSetFriendsList { (isNewUser, arrFrndData) in
            print(isNewUser,arrFrndData)
            if isNewUser || self.isFirstTime{
                self.isFirstTime = false
                self.ArrayFriendData.removeAllObjects()
                for i in arrFrndData{
                    self.addDictionaryToUserArray(dict: i as! NSDictionary)
                }
                self.tblViewFrndList.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

            }else{
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                self.ArrayFriendData.removeAllObjects()

                for i in arrFrndData{
                    self.addDictionaryToUserArray(dict: i as! NSDictionary)
            }
            }}

    }
    // MARK: - Get pending List
    func setWsGetPendingList(){
        let param = ["user_id":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID)!]
        
        Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetFriendRequestList, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
            
            if success == true
            {
                if let response_data = response.object(forKey: "response_data") as? NSDictionary
                {
                    if let arrData : NSArray  = response_data.object(forKey: "friends_requests") as? NSArray
                    {
                        let cdm = CoreDataManage()
                        for i in 0..<arrData.count{
                            let dictArr = arrData[i] as! NSDictionary
                            if dictArr["friend_id"] as! String == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String{
                                continue
                            }
                            
                            if let frndID = dictArr.object(forKey: "friend_id")
                            {
                                let arrFrnd = cdm.fetchFriendOtherDetailWithChatId(userId: "\(frndID)" as NSString)
                                if arrFrnd.count != 0{
                                    let frnd : FriendOtherDetail = arrFrnd.firstObject as! FriendOtherDetail
                                    if frnd.lastmsg != nil{
                                        self.objSendMessage.getAllMessagesDetailWithChatID(chatId: dictArr["id"] as! NSString)
                                    }
                                    self.addToArrayPendingUserWithUserDetail(dict: dictArr)
                                }else{
                                    self.addToArrayPendingUserWithUserDetail(dict: dictArr)
                                }}
                            }
                        }
                    }
                }
            else
            {
                if let msg = response.object(forKey: "message") as? String
                {
                    
                }
                else
                {
                    self.view.makeToast("Something went to wrong. Please try after sometime.")
                }
            }
            
        }
        
//        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
//            
//          
//        })
    }
    func addToArrayPendingUserWithUserDetail(dict : NSDictionary){
        arrPendingUserDetails.removeAllObjects()
        let mutDict = NSMutableDictionary.init(dictionary: dict)
            let dictFetchdMsg = getLastMessageWithUserId(userId:dict["id"] as! NSString)
            if var lastMsg = dictFetchdMsg.object(forKey: "msg") as? String{
                if lastMsg == ""{
                    lastMsg = ""
                }
                mutDict.setValue(lastMsg, forKey: "lastmsg")
            }
      
            //            CoreDataManage *cdm = [[CoreDataManage alloc] init];
            //            NSArray *arrUndelivered = [cdm getUndeliveredMsgsForUserId:dict[@"details"][0][@"id"]];
            //            [mutDict setObject:@(arrUndelivered.count) forKey:@"unreadCounts"];
            mutDict.setObject(dict["id"], forKey: "otherId" as NSCopying)

        let predict = NSPredicate(format: "(id contains[c] %@)", (dict["id"] as! String))
        let arrpredicated : NSArray = arrPendingUserDetails.filtered(using: predict) as NSArray
        if arrpredicated.count == 0{
            arrPendingUserDetails.add(mutDict.mutableCopy())
        }else{
            arrPendingUserDetails.remove(arrpredicated.firstObject ?? 0)
            arrPendingUserDetails.add(mutDict.mutableCopy())
       }
        tblViewFrndList.reloadData()
    }
    func addDictionaryToUserArray(dict : NSDictionary){
       let mutDict = NSMutableDictionary.init(dictionary: dict)
        if let details = dict.object(forKey: "details") as? NSArray
        { if details.count != 0
        {
        let uDetail = details.object(at: 0) as! NSDictionary
            let dictFetchdMsg = getLastMessageWithUserId(userId:uDetail["id"] as! NSString)
            if var lastMsg = dictFetchdMsg.object(forKey: "msg") as? String{
            if lastMsg == ""{
                lastMsg = ""
            }
            mutDict.setValue(lastMsg, forKey: "lastmsg")
            }
            if String(describing:mutDict.object(forKey: "lastmsgtimestamp")) != ""{
                mutDict.setValue(mutDict.object(forKey: "lastmsgtimestamp") as! String, forKey: "lastmsgtimestamp")

            }
            if String(describing:mutDict.object(forKey: "lastmsgtimestamp")) == "0" || String(describing:mutDict.object(forKey: "lastmsgtimestamp")) == "" {
                   mutDict.setValue(mutDict.object(forKey: "lastmsgtimestamp") as! String, forKey: "lastmsgtimestamp")
            }
//            CoreDataManage *cdm = [[CoreDataManage alloc] init];
//            NSArray *arrUndelivered = [cdm getUndeliveredMsgsForUserId:dict[@"details"][0][@"id"]];
//            [mutDict setObject:@(arrUndelivered.count) forKey:@"unreadCounts"];
            mutDict.setObject(uDetail["id"], forKey: "otherId" as NSCopying)
            ArrayFriendData.add(mutDict)
            tblViewFrndList.reloadData()
            }}}

    //MARK:- Button Action
    func btnActionAcceptREquest(sender : UIButton)
    {
        
    }
    
    
    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrPendingUserDetails.count
        }else{
            return ArrayFriendData.count}
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Pending Requests"}else{
            return "Messages"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! chatTableviewCell
        cell.selectionStyle = .none
        if indexPath.section == 0{
            if let dataDict = self.arrPendingUserDetails.object(at: indexPath.row) as? NSDictionary{
        if let first_name = dataDict.object(forKey: "first_name"),let last_name = dataDict.object(forKey: "last_name"),let profilepic1 = dataDict.object(forKey: "profilepic1")
                {
          cell.lblPersonName.text = "\(first_name) \(last_name)"
            cell.imgViewProfile.cornerRadius = cell.imgViewProfile.frame.width / 2
            cell.imgViewProfile.clipsToBounds = true
            cell.imgViewProfile.image = UIImage.init(named: "disableSingle")
                    if "\(profilepic1)" != ""
                    {
                        if let proURL = URL.init(string: "\(profilepic1)")
                        {
                            cell.imgViewProfile.sd_setImage(with: proURL)
                        }
                        if cell.imgViewProfile.image == nil{
                            cell.imgViewProfile.image = UIImage.init(named: "disableSingle")
                        }
                    }
                    if let address = dataDict.object(forKey: "location_string") as? String
                    {
                        cell.lblMessage.text = address//"New York, USA"
                    }
            
            cell.btnAcceptRequestOut.isHidden = false
            cell.btnCancelRequestOut.isHidden = false
            cell.lblTiming.isHidden = true
            cell.btnNotificationOut.isHidden = true
                }}}else{
            if indexPath.row == 2 {
                cell.btnNotificationOut.isHidden = false
                cell.btnNotificationOut.setTitle("1", for: .normal)}else{cell.btnNotificationOut.isHidden = true}
            if let dataDict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
            {
                let dict = (dataDict.object(forKey: "details") as! NSArray)[0] as! NSDictionary
        if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let profilepic1 = dict.object(forKey: "profilepic1")
                {
        cell.btnAcceptRequestOut.isHidden = true
        cell.btnCancelRequestOut.isHidden = true
        cell.lblTiming.isHidden = false
        cell.imgViewProfile.cornerRadius = cell.imgViewProfile.frame.width / 2
        cell.imgViewProfile.clipsToBounds = true
        cell.imgViewProfile.image = UIImage.init(named: "disableSingle")
                    if "\(profilepic1)" != ""
                    {
                        if let proURL = URL.init(string: "\(profilepic1)")
                        {
                            cell.imgViewProfile.sd_setImage(with: proURL)
                        }
                        if cell.imgViewProfile.image == nil{
                            cell.imgViewProfile.image = UIImage.init(named: "disableSingle")
                        }
                    }
                    
                    if let strTime = dataDict.object(forKey: "lastmsgtimestamp") as? String{
                        if strTime == "Optional(1536236239)" || strTime == "" {
                            cell.lblTiming.text = ""
                        }else{
                            cell.lblTiming.text = getTimeFromTimeStamp(timestamp: NSNumber(integerLiteral: Int(strTime)!))}}
        cell.lblPersonName.text =  "\(first_name) \(last_name)"
                    if let strlastMsg = dataDict.object(forKey: "lastmsg") as? String{
                        cell.lblMessage.text = strlastMsg}
                }}
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            
        }
        else if indexPath.section == 1
        {
            if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
            {
                if dict.object(forKey: "status") as! String == "0"{
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "sentRequestRestaurantScreenVC") as! sentRequestRestaurantScreenVC
                    if let dataDict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
                    {
                        obj.isSent = true
                        obj.dictUserDetails = (dataDict.object(forKey: "details") as! NSArray)[0] as! NSDictionary
                        
                    }
                    self.navigationController?.pushViewController(obj, animated: false)
                }else{
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "conversationScreenVC") as! conversationScreenVC
                    UserDefaults.standard.set(dict.object(forKey: "id"), forKey: Constants.UserDefaults.matchId)
                    obj.dictUserDetail = self.ArrayFriendData.object(at: indexPath.row) as! NSDictionary
                    
                    let dataDict = (dict.object(forKey: "details") as! NSArray)[0] as! NSDictionary
                    
                    obj.isFreind = true
                    if let profilepic1 = dataDict.object(forKey: "profilepic1") as? String{
                        UserDefaults.standard.setValue(profilepic1, forKey: Constants.UserDefaults.receiverDP)}else{
                        UserDefaults.standard.setValue("", forKey: Constants.UserDefaults.receiverDP)
                    }
                    self.navigationController?.pushViewController(obj, animated: false)
                }
            }
        }
        

        
    }
    func getLastMessageWithUserId(userId : NSString) -> NSDictionary{
        let cdm = CoreDataManage()
        let fetchLastMessage : NSDictionary = cdm.fetchLastMessageWithOtherUserId(otherId: userId)
        return fetchLastMessage
    }

    
    func FireDataBaseAllMessagesDetail(snapshot: DataSnapshot, isAllMsgs: Bool) {
        
        let cdm = CoreDataManage ()
        var arrValues = NSMutableArray.init(array: (snapshot.value as! NSDictionary).allKeys)
        let dict : NSDictionary = arrValues.firstObject as! NSDictionary
        var otherid : String = dict["senderId"] as! String
        if otherid == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String{
            otherid = dict["recieverId"] as! String
        }
       // let highesttoLowest : NSSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true,selector: #selector(NSString.localizedStandardCompare))
       //arrValues = arrValues.sort { $0.highesttoLowest < $1.highesttoLowest }
        for i in 0..<arrValues.count{
            if let dict = arrValues[i] as? NSDictionary{
                let frnd : FriendOtherDetail = ((cdm.fetchFriendOtherDetailWithUserId(userId: otherid as NSString) as! NSMutableArray).firstObject as! FriendOtherDetail)
                print(frnd)
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
