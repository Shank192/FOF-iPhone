//
//  CoreDataManage.swift
//  FOF
//
//  Created by 360dts on 31/08/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class CoreDataManage: NSObject {
    
    @objc func managedObjectContext() -> NSManagedObjectContext{
        var context : NSManagedObjectContext? = nil
        let app = UIApplication.shared.delegate as! AppDelegate
       // if ((app.perform(#selector(managedObjectContext))) != nil){
            context = app.managedObjectContext()
        //}
        return context!
    }
    
    
    
    // MARK: - Update Users For Chatting
    func insertUserDetailDataWithDictionary(dictUserDeatail : NSDictionary){
        let context : NSManagedObjectContext = managedObjectContext()
        let userDetail : UserData = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context) as! UserData
        
        //let uDetail = dictUserDeatail.object(forKey: "details") as! NSDictionary
        let muteDict = NSMutableDictionary(dictionary: dictUserDeatail)
        muteDict.setValue(dictUserDeatail["friend_id"]!, forKey: "id")
        muteDict.setValue("\(dictUserDeatail["latitude"]!,dictUserDeatail["longitude"]!)", forKey: "location")
//        muteDict.setValue("\(dictUserDeatail["location_string"]!)", forKey: "location_string")
        muteDict.removeObject(forKey: "mutual_friends_count")
        muteDict.removeObject(forKey: "latitude")
        muteDict.removeObject(forKey: "longitude")
        muteDict.removeObject(forKey: "mutual_friends")
        muteDict.removeObject(forKey: "friend_id")
        muteDict.removeObject(forKey: "email")
        muteDict.removeObject(forKey: "address")
        muteDict.removeObject(forKey: "status")
        muteDict.removeObject(forKey: "friendstatus")
        let keys = muteDict.allKeys as NSArray
       
        for i in keys{
            if (muteDict[i] as? String) != nil
            {
                
            }else{
                 userDetail.setValue("", forKey: i as! String)
                continue
            }
            userDetail.setValue(muteDict[i], forKey: i as! String)
        }
        let frnddeatil = NSEntityDescription.insertNewObject(forEntityName: "FriendOtherDetail", into: context) as! FriendOtherDetail
        var frndId = dictUserDeatail.object(forKey: "friend_id")
        var isRecieved = true
        if frndId as! String == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String{
            frndId = dictUserDeatail.object(forKey: "friend2")
            isRecieved = false
        }
        if dictUserDeatail.object(forKey: "createdat") != nil{
            frnddeatil.createdat = dictUserDeatail.object(forKey: "createdat") as! String
        }
        if dictUserDeatail.object(forKey: "updatedat") != nil{
            frnddeatil.updatedat = dictUserDeatail.object(forKey: "updatedat") as? String
        }

        if dictUserDeatail.object(forKey: "scheduleat") != nil{
            frnddeatil.scheduleat = dictUserDeatail.object(forKey: "scheduleat") as? String
        }

        if dictUserDeatail.object(forKey: "status") != nil{
            frnddeatil.status = dictUserDeatail.object(forKey: "status") as? String
        }

        if dictUserDeatail.object(forKey: "id") != nil{
            frnddeatil.chatId = dictUserDeatail.object(forKey: "id") as? String
        }
        frnddeatil.friendId = frndId as? String
        frnddeatil.isRecieved = isRecieved
        frnddeatil.userData = userDetail
        saveContext(managedObjectContext: context)
    }
    func updateEntity(entity:String , arrUdetails:NSArray){
         let context : NSManagedObjectContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var arrFetchedData = NSArray()
        do {
            arrFetchedData = try context.fetch(fetchRequest) as NSArray
           //arrFetchedData = try context.execute(fetchRequest)
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
    let mutArrFatchedData = NSMutableArray.init(array: arrFetchedData)
        
        for i in 0..<arrUdetails.count{
           // let chatId = arrUdetails[i]["id"] as! String
            let dict = arrUdetails[i] as! NSDictionary
            let chatId = dict.object(forKey: "id") as! String
            let predicate = NSPredicate(format: "chatId contains[c] %@", chatId)
            let arrPredicated = mutArrFatchedData.filtered(using: predicate) as NSArray
            if arrPredicated.count == 0{
                self.insertUserDetailDataWithDictionary(dictUserDeatail: dict)
            }else{
                if arrFetchedData.count > i
                {
                    let friendOtherDetail = arrFetchedData.object(at: i) as! FriendOtherDetail
                    let dictDetail = arrUdetails.object(at: i) as! NSDictionary
                    friendOtherDetail.updatedat = dictDetail.object(forKey: "updatedat") as? String
                    friendOtherDetail.status = dictDetail.object(forKey: "friendstatus") as? String
                    if friendOtherDetail.lastmsgtimestamp == nil{
                        let lastmsg : NSDictionary = fetchLastMessageWithOtherUserId(otherId: friendOtherDetail.friendId as! NSString)
                    }
                    let udict = arrUdetails.object(at: i) as! NSDictionary
                    
                    if let details = udict.object(forKey: "details") as? NSArray
                    {if details.count != 0
                    {
                        let uDetail = details.object(at: 0) as! NSDictionary
                        let keys : NSArray = uDetail.allKeys as NSArray
                        for i in keys{
                            if let str = uDetail[i] as? String {}else{
                                friendOtherDetail.userData?.setValue("", forKey: i as! String)
                                continue
                            }
                            friendOtherDetail.userData?.setValue(uDetail[i], forKey: i as! String)
                        } }}
                    mutArrFatchedData.remove(arrPredicated.firstObject!)
                }
                
            }
        }
       for frnd in mutArrFatchedData {
        self.deleteFriendWithChatId(chatid: (frnd as! FriendOtherDetail).chatId! as NSString, otherId: (frnd as! FriendOtherDetail).friendId! as NSString)
    }
      self.saveContext(managedObjectContext: context)
    }
   // MARK: -  Update Messages
    
    func insertMessagesWithObject(msg : NSDictionary){
         let context : NSManagedObjectContext = managedObjectContext()
        let msgDetail = NSEntityDescription.insertNewObject(forEntityName: "MessagesDetail", into: context) as! MessagesDetail
        self.setMessageToEntity(msgDetail: msgDetail, msgDict: msg, context: context)
        
    }
    func setMessageToEntity(msgDetail : MessagesDetail , msgDict : NSDictionary, context : NSManagedObjectContext){
        //msg = msg
        // msg = Constants.GlobalConstants.appDelegate.dictionaryByReplacingNullsWithStrings:msg
        var msg = msgDict
        if  let lblContent = msg.object(forKey: "contentType") as? String{
    if (lblContent == "restaurant") && (msg.object(forKey: "senderId") as! String == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String){
            
            let dictChangeRcvRestMsg = NSMutableDictionary.init(dictionary: msg)
            dictChangeRcvRestMsg.setValue("You sent a restaurant suggestion.", forKey: "msg")
            msg = dictChangeRcvRestMsg.mutableCopy() as! NSDictionary
        }
    else if (lblContent == "image") && (msg.object(forKey: "senderId") as! String == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String){
            let dictChangeRcvRestMsg = NSMutableDictionary.init(dictionary: msg)
            dictChangeRcvRestMsg.setValue("You sent an image.", forKey: "msg")
            msg = dictChangeRcvRestMsg.mutableCopy() as! NSDictionary
            }
        let keys = NSMutableArray.init(array: msg.allKeys)
        keys.remove("restoVo")
        keys.remove("recieverDp")
            if let dict = msg.object(forKey: "restoVo") as? NSDictionary{
        keys.addObjects(from: dict.allKeys)
        for i in 0..<keys.count{
            
            if let actionString = keys.object(at: i) as? String{
                let str : NSString = "r".appending(keys[i] as! String) as NSString
            }
            else if (msg.allKeys as NSArray).contains(keys[i]){
                if ((keys[i] as! String == "msg") && (msg.object(forKey: "senderId") as! String == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! String) && msg.object(forKey: "contentType") as! String == "restaurant"){
                    msgDetail.setValue("You sent a restaurant suggestion.", forKey: keys.object(at: i) as! String)
                }
                msgDetail.setValue(msg[keys[i]], forKey: keys[i] as! String)
            }else{
                msgDetail.setValue("", forKey: keys.object(at: i) as! String)
            }

        }
        var otherId : NSString = msg.object(forKey: "senderId") as! NSString
        if otherId == UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as! NSString{
            otherId = msg.object(forKey: "recieverId") as! NSString
        }
        let arrFrnd = fetchFriendOtherDetailWithUserId(userId: otherId)
        if arrFrnd.count > 0{
        let frnd : FriendOtherDetail = arrFrnd.firstObject as! FriendOtherDetail
        frnd.lastmsg = msg.object(forKey: "msg") as? String
        let time = msg.object(forKey: "timeStamp")!
            frnd.lastmsgtimestamp = String(describing: time)}}}
        self.saveContext(managedObjectContext: context)
    }
    func updateMessageEntityWithMessageDict(msg: NSDictionary){
       // msg = Constants.GlobalConstants.appDelegate.dictionaryByReplacingNullsWithStrings:msg
         let context : NSManagedObjectContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessagesDetail")
        var arrFetchedData = NSArray()
        do {
            arrFetchedData = try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        if arrFetchedData.count == 0{
            self.insertMessagesWithObject(msg: msg)
        }else{
            let msgDetail : MessagesDetail = arrFetchedData.firstObject as! MessagesDetail
          let context : NSManagedObjectContext = managedObjectContext()
            setMessageToEntity(msgDetail: msgDetail, msgDict: msg, context: context)
        }
    }
   
    // MARK: -  Delete all data
    
    func deleteAllDataWithEntityName(entity:NSString){
         let context : NSManagedObjectContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity as String)
        let batchDeleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
        let deleteError : NSError? = nil
        
        do {
            try context.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        
        self.saveContext(managedObjectContext: context)
        
        
        
    }
    func deleteFriendWithChatId(chatid : NSString , otherId : NSString){
       let context : NSManagedObjectContext = managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let Entity = NSEntityDescription.entity(forEntityName: "FriendOtherDetail", in: context)
        fetchRequest.entity = Entity
        let fetchMessagesReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MessagesDetail")
        fetchMessagesReq.predicate = NSPredicate(format: "(senderId contains[c] %@ && recieverId contains[c] %@) || (senderId contains[c] %@ && recieverId contains[c] %@)", otherId,(UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID) as! String),(UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID) as! String),otherId)
        let error : NSError? = nil
        var fetchedFriends = NSArray()
        do {
            let res = try context.execute(fetchRequest)
            if let resArray = res as? NSArray
            {
                fetchedFriends = resArray
            }
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        var fetchedMsgs = NSArray()
        do {
            let res = try context.execute(fetchMessagesReq)
            
            if let resArray = res as? NSArray
            {
                fetchedMsgs = resArray
            }
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        if fetchedFriends.count == 0{
            
        }
        if fetchedMsgs.count == 0{
            
        }
        for i in fetchedFriends{
            if (i as! FriendOtherDetail).chatId == chatid as String{
                self.managedObjectContext().delete(i as! FriendOtherDetail)
            }
        }
        for i in fetchedMsgs{
                self.managedObjectContext().delete(i as! FriendOtherDetail)
        }
        self.saveContext(managedObjectContext: context)
    }
   
    
    
    
    // MARK: - Fetch Data From Entity
    func fetchWithEntityName(entity : String) -> NSArray{
        let context : NSManagedObjectContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity as String)
        var arrFetchedData = NSArray()
        do {
            arrFetchedData = try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        if entity == "FriendOtherDetail"{
            arrFetchedData = setDataToArrUserDetailsWithObj(data: arrFetchedData)
        }
        return arrFetchedData
    }
    
    // MARK: - Fetch Data with ChatId
    
    
    // MARK: - Fetch Data with userId
    func fetchFriendOtherDetailWithUserId(userId : NSString) -> NSArray{
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendOtherDetail")
        fetchRequest.predicate = NSPredicate(format: "(friendId contains[c] %@)", userId)
         let context : NSManagedObjectContext = managedObjectContext()
        let error : NSError? = nil
        var arrFetchedData = NSArray()
        do {
            arrFetchedData = try context.fetch(fetchRequest) as NSArray        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        print(arrFetchedData)
        return arrFetchedData
    }
    func fetchFriendOtherDetailWithChatId(userId : NSString) -> NSArray{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendOtherDetail")
        fetchRequest.predicate = NSPredicate(format: "(chatId contains[c] %@)", userId)
         let context : NSManagedObjectContext = managedObjectContext()
        let error : NSError? = nil
        var arrFetchedData = NSArray()
        do {
        arrFetchedData = try context.fetch(fetchRequest) as NSArray        } catch let error as NSError {
                print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        return arrFetchedData
    }
    
    
    
    func fetchMessageEntityWithOtherUserId(otherId : NSString,isMsgFormat : Bool) -> NSArray{
        let context : NSManagedObjectContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessagesDetail")
        fetchRequest.predicate = NSPredicate(format: "(senderId contains[c] %@ && recieverId contains[c] %@) || (senderId contains[c] %@ && recieverId contains[c] %@)", otherId,(UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID) as! String),(UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID) as! String),otherId)
        var arrFetchedData = NSArray()
        do {
            arrFetchedData = try context.fetch(fetchRequest) as NSArray        } catch let error as NSError {
                print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        if isMsgFormat{
            arrFetchedData = setToMessageFormatWithObject(arrData: arrFetchedData)
        }
        return arrFetchedData
    }
    
    
    func fetchLastMessageWithOtherUserId(otherId : NSString) -> NSDictionary{
         let context : NSManagedObjectContext = managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessagesDetail")
        fetchRequest.predicate = NSPredicate(format: "(senderId contains[c] %@ && recieverId contains[c] %@) || (senderId contains[c] %@ && recieverId contains[c] %@)", otherId,(UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID) as! String),(UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID) as! String),otherId)
        var arrFetchedData = NSArray()
        do {
            arrFetchedData = try context.fetch(fetchRequest) as NSArray        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        if arrFetchedData.count == 0{
            return [:]
        }else{
        
            arrFetchedData = [arrFetchedData.lastObject!]
            arrFetchedData = setToMessageFormatWithObject(arrData: arrFetchedData)
        }
        return arrFetchedData.firstObject as! NSDictionary

    }
  
    
    
    
    
    
    
    
    
    func saveContext (managedObjectContext : NSManagedObjectContext) {
        
        
       //if !managedObjectContext.save()
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("saved")
            } catch {
              
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
