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
    

    func sendMessageToRecieverId(recieverId : String , isFriend : Bool){
        let refPath = "messages/\(UserDefaults.standard.object(forKey: Constants.UserDefaults.matchId) as! String)"
        rootRef = Database.database().reference(withPath: refPath)
        let FullPath = rootRef.childByAutoId()
        _ = (FullPath.url).components(separatedBy: "/")
        mutMessageParamDictDetail.setValue(FullPath.key, forKey: "key")
        FullPath.setValue(mutMessageParamDictDetail)
    }
    func addObserverForStatusUpdateforChatId(chatId : String){
        
        rootRef = Database.database().reference(withPath: "status/\(chatId)")
        msgChangedHandle = rootRef.observe(.childChanged, with: { (snapshot) in
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
                let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.senderId) as! String
                if snapshot.key != str{
                    self.delegate?.setCurrentUpdatedStatusOfOtherUser(snapshot: snapshot)
                }
            }
        })
     
    }
    func addObserverForRecipteCHangeWithChatId(chatId : String){
        
        rootRef = Database.database().reference(withPath: "messages/\(chatId)")
        msgChangedHandle = rootRef.observe(.childChanged, with: { (snapshot) in
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
                let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.senderId) as! String
               // if snapshot.key != str{
                    self.delegate?.setMsgseenTickMarkForMessage(snapshot: snapshot)
                //}
            }
        })
        
    }
    
    func getStatusDetailOfUserId(otherUserId : String,chatId : String){
        
        rootRef = Database.database().reference(withPath: "status/\(chatId)/\(otherUserId)")
        rootRef.observe(.value, with: { (snapshot) in
            if let DataDict = snapshot.value as? NSDictionary
            {
                print(DataDict)
                let str = UserDefaults.standard.object(forKey: Constants.UserDefaults.senderId) as! String
                if snapshot.key != str{
                    self.delegate?.otherUserIdStatusDetail(snapshot: snapshot)
                }
            }
        })
        
    }
}

