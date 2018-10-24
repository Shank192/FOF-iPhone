//
//  getFriendsScreen.swift
//  FOF
//
//  Created by 360dts on 06/09/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import Foundation

class getFriendsScreen: NSObject {

    func wsSetFriendsList(CompletionHandler:@escaping (_ isNewUserAdded:Bool,_ arrFriends:NSArray) -> ()) {
        if let userid = UserDefaults.standard.object(forKey: Constants.UserDefaults.user_ID)
        {
            let param = ["user_id":"\(userid)"]
            
            Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetFriendList, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
                
                if success == true
                {
                    let cdm = CoreDataManage()
                    let arrOldFriends : NSArray = cdm.fetchWithEntityName(entity: "FriendOtherDetail")
                    if success == false || response.count == 0{
                        CompletionHandler(false,arrOldFriends)
                        return
                    }
                    if let dict = response.object(forKey: "response_data") as? NSDictionary
                    {
                        if let dataArray = dict.object(forKey: "friends") as? NSArray
                        {
                            
                            cdm.updateEntity(entity: "FriendOtherDetail", arrUdetails: dataArray)
                            let arrFetchedFriendDetails : NSArray = cdm.fetchWithEntityName(entity: "FriendOtherDetail")
                            if arrOldFriends.count == arrFetchedFriendDetails.count{
                                for i in 0..<arrFetchedFriendDetails.count{
                                    let arrFetched = arrFetchedFriendDetails[i] as! NSDictionary
                                    let arrOld = arrOldFriends[i] as! NSDictionary
                                    let oldStatus : String = String(arrOld.object(forKey: "status") as! String)
                                    let newStatus : String = String(arrFetched.object(forKey: "status") as! String)
                                    if oldStatus != newStatus{
                                        CompletionHandler(true,arrFetchedFriendDetails)
                                        return
                                    }
                                }
                                CompletionHandler(false,arrFetchedFriendDetails)
                            }else{
                                if arrOldFriends.count > arrFetchedFriendDetails.count {
                                    
                                    
                                }
                            }
                        }
                    }
                 
                }
                else
                {
                    let cdm = CoreDataManage()
                    let arrOldFriends : NSArray = cdm.fetchWithEntityName(entity: "FriendOtherDetail")
                    
                        CompletionHandler(false,arrOldFriends)
                        return
                    
                }
                
            }
            
//            WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
//
//
//
//            })
        }
        
        
    }
    
}
