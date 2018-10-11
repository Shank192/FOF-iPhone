//
//  getFriendsScreen.swift
//  FOF
//
//  Created by 360dts on 06/09/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit
import MBProgressHUD
import Foundation

class getFriendsScreen: NSObject {

    func wsSetFriendsList(CompletionHandler:@escaping (_ isNewUserAdded:Bool,_ arrFriends:NSArray) -> ()) {
        let param = ["action":"myfriends","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID)]
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in

            let cdm = CoreDataManage()
            let arrOldFriends : NSArray = cdm.fetchWithEntityName(entity: "FriendOtherDetail")
            if success == false || response.count == 0{
                CompletionHandler(false,arrOldFriends)
                return
            }
            let dataArray = response.object(forKey: "data") as? NSArray

            cdm.updateEntity(entity: "FriendOtherDetail", arrUdetails: dataArray!)
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
            
        })
        
    }
    
}
