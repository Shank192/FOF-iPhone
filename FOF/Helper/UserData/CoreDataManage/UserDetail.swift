//
//  UserDetail.swift
//  FOF
//
//  Created by 360dts on 05/09/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import Foundation
import UIKit

func setDataToArrUserDetailsWithObj(data : NSArray) -> NSMutableArray{
    let mutArrdata = NSMutableArray()
    
    for i in 0..<data.count{
        let friendDataObj : FriendOtherDetail = data.object(at: i as! Int) as! FriendOtherDetail
        let userDataObj : UserData = friendDataObj.userData!
        let str_about_me : NSString = ((userDataObj.about_me == nil) ? "" : userDataObj.about_me! as NSString)
        let str_account_type = ((userDataObj.account_type == nil) ? "" : userDataObj.account_type! as NSString)
        let str_createdat = ((userDataObj.createdat == nil) ? "" : userDataObj.createdat! as NSString)
         let str_dob = ((userDataObj.dob == nil) ? "" : userDataObj.dob! as NSString)
        let str_education = ((userDataObj.education == nil) ? "" : userDataObj.education! as NSString)
        let str_ethnicity = ((userDataObj.ethnicity == nil) ? "" : userDataObj.ethnicity! as NSString)
        let str_first_name = ((userDataObj.first_name == nil) ? "" : userDataObj.first_name! as NSString)
        
        let str_gender : NSString = ((userDataObj.gender == nil) ? "" : userDataObj.gender! as NSString)
        let str_id = ((userDataObj.id == nil) ? "" : userDataObj.id! as NSString)
        let str_last_name = ((userDataObj.last_name == nil) ? "" : userDataObj.last_name! as NSString)
        let str_location = ((userDataObj.location == nil) ? "" : userDataObj.location! as NSString)
        let str_location_string = ((userDataObj.location_string == nil) ? "" : userDataObj.location_string! as NSString)
        let str_mobile = ((userDataObj.mobile == nil) ? "" : userDataObj.mobile! as NSString)
        let str_occupation = ((userDataObj.occupation == nil) ? "" : userDataObj.occupation! as NSString)
        
        
        let str_profilepic1 = ((userDataObj.profilepic1 == nil) ? "" : userDataObj.profilepic1! as NSString)
        let str_profilepic2 = ((userDataObj.profilepic2 == nil) ? "" : userDataObj.profilepic2! as NSString)
        let str_profilepic3 = ((userDataObj.profilepic3 == nil) ? "" : userDataObj.profilepic3! as NSString)
        let str_profilepic4 = ((userDataObj.profilepic4 == nil) ? "" : userDataObj.profilepic4! as NSString)
        let str_profilepic5 = ((userDataObj.profilepic5 == nil) ? "" : userDataObj.profilepic5! as NSString)
        
        let str_profilepic6 : NSString = ((userDataObj.profilepic6 == nil) ? "" : userDataObj.profilepic6! as NSString)
        let str_profilepic7 = ((userDataObj.profilepic7 == nil) ? "" : userDataObj.profilepic7! as NSString)
        let str_profilepic8 = ((userDataObj.profilepic8 == nil) ? "" : userDataObj.profilepic8! as NSString)
        let str_profilepic9 = ((userDataObj.profilepic9 == nil) ? "" : userDataObj.profilepic9! as NSString)
        let str_relationship = ((userDataObj.relationship == nil) ? "" : userDataObj.relationship! as NSString)
        let str_social_id = ((userDataObj.social_id == nil) ? "" : userDataObj.social_id! as NSString)
        let str_testbuds = ((userDataObj.testbuds == nil) ? "" : userDataObj.testbuds! as NSString)
        let str_updatedat = ((userDataObj.updatedat == nil) ? "" : userDataObj.updatedat! as NSString)
        let dictUserDataObj : NSDictionary =
        [  "about_me":str_about_me,
            "account_type":str_account_type,
            "createdat":str_createdat,
            "dob":str_dob,
            "education":str_education,
            "ethnicity":str_ethnicity,
            "first_name":str_first_name,
            "gender":str_gender,
            "id":str_id,
            "last_name":str_last_name,
            "location":str_location,
            "location_string":str_location_string,
            "mobile":str_mobile,
            "occupation":str_occupation,
            "profilepic1":str_profilepic1,
            "profilepic2":str_profilepic2,
            "profilepic3":str_profilepic3,
            "profilepic4":str_profilepic4,
            "profilepic5":str_profilepic5,
            "profilepic6":str_profilepic6,
            "profilepic7":str_profilepic7,
            "profilepic8":str_profilepic8,
            "profilepic9":str_profilepic9,
            "relationship":str_relationship,
            "social_id":str_social_id,
            "testbuds":str_testbuds,
            "updatedat":str_updatedat]
        let arrDetails : NSArray = [dictUserDataObj]
        let strSender : NSString?
        let strReciever : NSString?
        
        if friendDataObj.value(forKey: "isRecieved") as! Bool == true{
            strSender = friendDataObj.value(forKey: "friendId") as? NSString
            strReciever = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as? NSString
        }else{
            strSender = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID) as? NSString
            strReciever = friendDataObj.value(forKey: "friendId") as? NSString
        }
        let strF_createdat = ((friendDataObj.createdat == nil) ? "" : friendDataObj.createdat);
        let strF_scheduleat = ((friendDataObj.scheduleat == nil) ? "" : friendDataObj.scheduleat);
        let strF_updatedat = ((friendDataObj.updatedat == nil) ? "" : friendDataObj.updatedat);
        let strF_status = ((friendDataObj.status == nil) ? "" : friendDataObj.status);
        let strF_friend1 = strSender;
        let strF_friend2 = strReciever;
        let strF_id = ((friendDataObj.chatId == nil) ? "" : friendDataObj.chatId);
        let strF_lastmsgtimestamp = ((friendDataObj.lastmsgtimestamp == nil) ? "" : friendDataObj.lastmsgtimestamp);
        let strF_lastmsg = ((friendDataObj.lastmsg == nil) ? "" : friendDataObj.lastmsg);
        let dictFriendDataObj : NSDictionary = [
            "createdat":strF_createdat! as NSString,
            "details":arrDetails,
            "scheduleat":strF_scheduleat! as NSString,
            "status":strF_status! as NSString,
            "updatedat":strF_updatedat! as NSString,
            "friend1":strF_friend1 as! NSString,
            "friend2":strF_friend2 as! NSString,
            "id":strF_id! as NSString,
            "lastmsgtimestamp":strF_lastmsgtimestamp! as NSString,
            "lastmsg":strF_lastmsg! as NSString
        ]
       mutArrdata.add(dictFriendDataObj)
    }
    
   return mutArrdata
    
    
    
}
