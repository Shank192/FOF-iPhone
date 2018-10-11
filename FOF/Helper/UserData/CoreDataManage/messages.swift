//
//  messages.swift
//  FOF
//
//  Created by 360dts on 05/09/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import Foundation
import CoreData


var msgDetail = MessagesDetail()

func setToMessageFormatWithObject(arrData:NSArray) -> NSArray{
    let dictMsgDetail = NSMutableDictionary()
    let dictRestDetail = NSMutableDictionary()
    let arrFormattedArray = NSMutableArray()
    //let arrData = NSArray()

    for i in arrData{
        msgDetail = i as! MessagesDetail
        var str_raddress = ""
            var str_rcuisine = ""
            var str_rdescription = ""
            var str_rformatted_address = ""
            var str_rformatted_phone_number = ""
            var str_rlatitude  = ""
            var str_rlongitude = ""
            var str_rmSnippet = ""
            var str_rname = ""
            var str_ropen_now = ""
            var str_rphoneNumber = ""
            var str_rphotoReference = ""
            var str_rplaceid = ""
            var str_rratings = ""
            var str_rreference = ""
            var str_rtimeToReach = ""
            var str_rtimings = ""
            var str_rurl = ""
            var str_rvicinity = ""
            var str_rwebsite = ""
            var str_rwebsiteUrl = ""
        
        if (msgDetail.raddress != nil){
            str_raddress = msgDetail.raddress!
        }
        if (msgDetail.rcuisine != nil){
            str_rcuisine = msgDetail.rcuisine!
        }
        if (msgDetail.rdescription != nil){
            str_rdescription = msgDetail.rdescription!
        }
        if (msgDetail.rformatted_address != nil){
            str_rformatted_address = msgDetail.rformatted_address!
        }
        if (msgDetail.rformatted_phone_number != nil){
            str_rformatted_phone_number = msgDetail.rformatted_phone_number!
        }
        if (msgDetail.rlatitude != nil){
            str_rlatitude = msgDetail.rlatitude!
        }
        if (msgDetail.rlongitude != nil){
            str_rlongitude = msgDetail.rlongitude!
        }
        if (msgDetail.rmSnippet != nil){
            str_rmSnippet = msgDetail.rmSnippet!
        }
        if (msgDetail.rname != nil){
            str_rname = msgDetail.rname!
        }
        if (msgDetail.ropen_now != nil){
            str_ropen_now = msgDetail.ropen_now!
        }
        if (msgDetail.rphoneNumber != nil){
            str_rphoneNumber = msgDetail.rphoneNumber!
        }
        if (msgDetail.rphotoReference != nil){
            str_rphotoReference = msgDetail.rphotoReference!
        }
        if (msgDetail.rratings != nil){
            str_rratings = msgDetail.rratings!
        }
        
        if (msgDetail.rreference != nil){
            str_rreference = msgDetail.rreference!
        }
        if (msgDetail.rtimeToReach != nil){
            str_rtimeToReach = msgDetail.rtimeToReach!
        }
        if (msgDetail.rtimings != nil){
            str_rtimings = msgDetail.rtimings!
        }
        if (msgDetail.rurl != nil){
            str_rurl = msgDetail.rurl!
        }
        if (msgDetail.rvicinity != nil){
            str_rvicinity = msgDetail.rvicinity!
        }
        if (msgDetail.rwebsite != nil){
            str_rwebsite = msgDetail.rwebsite!
        }
        if (msgDetail.rwebsiteUrl != nil){
            str_rwebsiteUrl = msgDetail.rwebsiteUrl!
        }
        let restDict : NSDictionary = [
        "address":str_raddress,
        "cuisine":str_rcuisine,
        "description":str_rdescription,
        "formatted_address":str_rformatted_address,
        "formatted_phone_number":str_rformatted_phone_number,
        "isSelected":(msgDetail.risSelected),
        "latitude":str_rlatitude,
        "longitude":str_rlongitude,
        "mSnippet":str_rmSnippet,
        "name":str_rname,
        "open_now":str_ropen_now,
        "phoneNumber":str_rphoneNumber,
        "photoReference":str_rphotoReference,
        "placeid":str_rplaceid,
        "posInList":(msgDetail.rposInList),
        "priceRange":(msgDetail.rpriceRange),
        "ratings":str_rratings,
        "reference":str_rreference,
        "selected":(msgDetail.rselected),
        "timeToReach":str_rtimeToReach,
        "timings":str_rtimings,
        "url":str_rurl,
        "vicinity":str_rvicinity,
        "website":str_rwebsite,
        "websiteUrl":str_rwebsiteUrl]
        dictRestDetail.setDictionary(restDict.mutableCopy() as! [AnyHashable : Any])
       
        var str_contentType = ""
        var str_delivered = ""
        var str_imgUrl = ""
        var str_key = ""
        var str_msg = ""
        var str_reciept = ""
        var str_recieverDP = ""
        var str_recieverId = ""
        var str_senderDp = ""
        var str_senderId = ""
    
        if (msgDetail.contentType != nil) {
            str_contentType = msgDetail.contentType!
        }
        if (msgDetail.delivered != nil) {
            str_delivered = msgDetail.delivered!
        }
        if (msgDetail.imgUrl != nil) {
            str_imgUrl = msgDetail.imgUrl!
        }
        if ((msgDetail.key) != nil) {
            str_key = msgDetail.key!
        }
        if (msgDetail.msg != nil) {
            str_msg = msgDetail.msg!
        }
        if (msgDetail.reciept != nil) {
            str_reciept = msgDetail.reciept!
        }
        if (msgDetail.recieverDP != nil) {
            str_recieverDP = msgDetail.recieverDP!
        }
        if ((msgDetail.recieverId) != nil) {
            str_recieverId = msgDetail.recieverId!
        }
        if ((msgDetail.senderDp) != nil) {
            str_senderDp = msgDetail.senderDp!
        }
        if ((msgDetail.senderId) != nil) {
            str_senderId = msgDetail.senderId!
        }
        let messageDetail : NSDictionary = ["contentType":str_contentType,
                              "delivered":str_delivered,
                               "imgUrl":str_imgUrl,
                                "key":str_key,
                                 "msg":str_msg,
                                  "reciept":str_reciept,
                                   "recieverDP":str_recieverDP,
                                    "recieverId":str_recieverId,
                                     "restoVo":dictRestDetail.mutableCopy,
                                      "senderDp":str_senderDp,
                                       "senderId":str_senderId,
                                    "timeStamp":msgDetail.timeStamp]
        dictMsgDetail.setDictionary(messageDetail.mutableCopy() as! [AnyHashable : Any])
        arrFormattedArray.add(dictMsgDetail.mutableCopy())
    }
    return arrFormattedArray
}






