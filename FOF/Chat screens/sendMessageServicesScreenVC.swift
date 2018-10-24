//
//  sendMessageServicesScreenVC.swift
//  FOF
//
//  Created by 360dts on 29/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


protocol FirebaseDelegate : NSObjectProtocol{
    func FireDataBaseAllMessagesDetail(snapshot : DataSnapshot,isAllMsgs : Bool)
    func setCurrentUpdatedStatusOfOtherUser(snapshot : DataSnapshot)
    func otherUserIdStatusDetail(snapshot : DataSnapshot)
    func setMsgseenTickMarkForMessage(snapshot : DataSnapshot)
}
class sendMessageServicesScreenVC: NSObject {
 
    //Firebase
    weak var delegate : FirebaseDelegate?
    var msgHandle : DatabaseHandle?
    var msgChangedHandle : DatabaseHandle?
    var rootRef = DatabaseReference()
    var mutParamDict = NSMutableDictionary()
    var mutMessageParamDictDetail = NSMutableDictionary()
    override init() {
        
    }
    func setDictFormatForWriteDataDefault(){

        mutParamDict = NSMutableDictionary()
        let restDict : NSDictionary = ["address":"","cuisine":"","description":"","formatted_address":"","formatted_phone_number":"","isSelected":"","latitude":"","longitude":"","mSnippet":"","name":"","open_now":"" ,"phoneNumber":"" ,"photoReference":"" ,"placeid":"" ,"posInList":"" ,"priceRange":"" ,"ratings":"" ,"reference":"","selected":"" ,"timeToReach":"" ,"timings":"" ,"url":"","vicinity":"" ,"website":"" ,"websiteUrl":"" ]
        mutParamDict.setDictionary(restDict as! [AnyHashable : Any])
        mutMessageParamDictDetail = NSMutableDictionary()
        let messageDetail : NSDictionary = ["contentType":"","delivered":"","imgUrl":"","key":"","msg":"","reciept":"","recieverDP":"","recieverId":"","restoVo":mutParamDict,"senderDp":"","senderId":"" ,"timeStamp":""]
        mutMessageParamDictDetail.setDictionary(messageDetail as! [AnyHashable : Any])
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
    func sendMessageToRecieverId(recieverId : String , isFriend : Bool){
        print(mutMessageParamDictDetail)
        let refPath = "messages/\(UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as! String)"
        rootRef = Database.database().reference(withPath: refPath)
        let FullPath = rootRef.childByAutoId()
        _ = (FullPath.url).components(separatedBy: "/")
        mutMessageParamDictDetail.setValue(FullPath.key, forKey: "key")
        FullPath.setValue(mutMessageParamDictDetail)
        
        let cdm = CoreDataManage()
        cdm.updateMessageEntityWithMessageDict(msg: mutMessageParamDictDetail.mutableCopy() as! NSDictionary)
   
    }
    func addObserverForRealTimeChatting(chatGrpId : String)
    {
        rootRef = Database.database().reference(withPath: "messages/\(chatGrpId)")
        msgHandle = rootRef.observe(.childAdded, with: { (snapshot) in
            print("frnd : \(snapshot.key) \(String(describing: snapshot.value))")
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
            }
//            if snapshot.value!["senderId"] as! String == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String{
//                
//            }
        })
    }
    func addObserverForStatusUpdateforChatId(chatId : String){
        
        rootRef = Database.database().reference(withPath: "status/\(chatId)")
        msgChangedHandle = rootRef.observe(.childChanged, with: { (snapshot) in
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
                let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                if snapshot.key != str{
                    self.delegate?.setCurrentUpdatedStatusOfOtherUser(snapshot: snapshot)
                }
            }
        })
    }
    func updateMyStatusOnFirebase(mutDictStatusDetail : NSMutableDictionary , chatId : String , senderId : String){
        let refPath = "messages/\(chatId)/\(senderId)"
        rootRef = Database.database().reference(withPath: refPath)
        rootRef.setValue(mutDictStatusDetail)
}
    func getAllMessagesDetailWithChatID(chatId : NSString , timeStamp : NSNumber){
        let refPath = "messages/\(chatId)"
        rootRef = Database.database().reference(withPath: refPath)
        let query : DatabaseQuery = rootRef.queryOrdered(byChild: "timeStamp").queryStarting(atValue: timeStamp)
        query.observeSingleEvent(of: .value) { (snapShot) in
            self.delegate?.FireDataBaseAllMessagesDetail(snapshot: snapShot, isAllMsgs: false)
        }
     
    }
   
    func addObserverForRecipteCHangeWithChatId(chatId : String){
        
        rootRef = Database.database().reference(withPath: "messages/\(chatId)")
        msgChangedHandle = rootRef.observe(.childChanged, with: { (snapshot) in
            if let DataDict = snapshot.value as? NSDictionary
            {
                if (DataDict.allKeys as NSArray).contains("msg") == true{
                let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                if (DataDict.object(forKey: "reciept") as! String).count > 0 || (DataDict.object(forKey: "delivered") as! String).count > 0 {
                    self.delegate?.setMsgseenTickMarkForMessage(snapshot: snapshot)
                }
                let cdm = CoreDataManage()
                cdm.updateMessageEntityWithMessageDict(msg: DataDict)
                }}
        })
    }
    func getAllMessagesDetailWithChatID(chatId : NSString){
        rootRef = Database.database().reference(withPath: "messages/\(chatId)")
       
        rootRef.observe(.value, with: { (snapshot) in
            print("Success get the snapshot \(snapshot)")
            // do something with snapshot than
            DispatchQueue.main.async {
                // if delegate?.perform(Selector!, with: ){
                self.delegate?.FireDataBaseAllMessagesDetail(snapshot: snapshot, isAllMsgs: true)
                // }            }
            }}) { (error) in
            print("Failed get the snapshot \(error.localizedDescription)" as Any)
            // do something to handle error
        }
   
}
    func getStatusDetailOfUserId(otherUserId : String,chatId : String){
        print(otherUserId)
        rootRef = Database.database().reference(withPath: "status/\(chatId)/\(otherUserId)")
        print(rootRef)
        rootRef.observe(.value, with: { (snapshot) in
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
                let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String
                if snapshot.key != str{
                    self.delegate?.otherUserIdStatusDetail(snapshot: snapshot)
                }
            }
        })
        
    }
}

