//
//  WebService.swift
//
//  PrePartureApp
//
//  Created by 360 Degree Technosoft on 19/12/15.
//  Copyright © 2015 360 Degree Technosoft. All rights reserved.
//

import UIKit
import Alamofire

//struct Alamofire {
//    static let manager = Manager.sharedInstance
//}
class WebService: NSObject {
    
    // Mark: Afnetworking
    
    class func postURL(_ serverlink:String,param:NSDictionary,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) //,userName:String,password:String
    {
        
        print("POST : " + serverlink + " and Param \(param)")
        
        let fullLink = serverlink
        
       
        
        Alamofire.request(fullLink, method: .post, parameters: param as? Parameters, encoding: URLEncoding.httpBody).responseJSON { (response) in
            
            print(response)
            
            if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary
            {
                if let TempDict:NSDictionary = TempresponseDict.object(forKey: "settings") as? NSDictionary
                {
                    if TempDict.object(forKey: "errormessage") as? String == "success" {
                    CompletionHandler(true, TempresponseDict)} else {
                    CompletionHandler(false, TempresponseDict)
                    }}
            } else {
                CompletionHandler(false, NSDictionary())
            }
        }
        
        
        
    }
    
    class func postImageToUrl(_ serverlink:String,methodname:String,param:NSDictionary,image:UIImage!,keyValue:String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        print("POST : " + serverlink + methodname + " and Param \(param) and key : \(keyValue)")
        
        var fullLink = serverlink
        
        if fullLink.count > 0 {
            fullLink = serverlink + "/" + methodname
        } else {
            fullLink = methodname
        }
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let notallowchar : CharacterSet = CharacterSet(charactersIn: "01234").inverted
        let dateStr:String = "\(Date())"
        let resultStr:String = (dateStr.components(separatedBy: notallowchar) as NSArray).componentsJoined(by: "")
        let imagefilename = resultStr + ".jpg"
        
        
        
        //["PreParture-APIKEY":"\(keyValue)"]
        
        Alamofire.upload(multipartFormData: { (formdata) in
            
            formdata.append(imageData!, withName: "imagefile", fileName: imagefilename, mimeType: "image/jpeg")
            
            formdata.append(keyValue.data(using: String.Encoding.utf8)!, withName: "PreParture-APIKEY")
            
            
            for (key, value) in param {
                
                formdata.append((value as! String).data(using: String.Encoding.utf8)!, withName: key as! String)
            }
            
            
        }, to: fullLink, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in // main queue by default
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
                
                upload.responseJSON { response in
                    print(response)
                    if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary
                    {
                        
                        CompletionHandler(true, TempresponseDict)
                        
                    } else {
                        
                        CompletionHandler(false, NSDictionary())
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                print("Fail to upload")
                CompletionHandler(false,NSDictionary())
            }
        })
        
        /*Alamofire.upload(multipartFormData: { (formdata) in
            
            formdata.append(imageData!, withName: "imagefile", fileName: imagefilename, mimeType: "image/jpeg")
            
            formdata.append(keyValue.data(using: String.Encoding.utf8)!, withName: "PreParture-APIKEY")
            
            
            for (key, value) in param {
                
                formdata.append((value as! String).data(using: String.Encoding.utf8)!, withName: key as! String)
            }
         
        }, with: fullLink, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in // main queue by default
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
                
                upload.responseJSON { response in
                    print(response)
                    if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary
                    {
                        
                        CompletionHandler(true, TempresponseDict)
                        
                    } else {
                        
                        CompletionHandler(false, NSDictionary())
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                print("Fail to upload")
                CompletionHandler(false,NSDictionary())
            }
         
        })*/
        
        
        
    }

    
    class func CallRequestUrl(_ serverlink:String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        print("Google Link : \(serverlink)")
        
        Alamofire.request(serverlink, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            //print("Google Link Response: \(response)")
            if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary
            {
                print("Google Link Response Success: \(response)")
                CompletionHandler(true, TempresponseDict)
                
            } else {
                print("Google Link Response Failure: \(response)")
                CompletionHandler(false, NSDictionary())
            }
        }
        
    }
   
    class func GetPlaceDetailByLatAndLong(_ latitude:String,longitude : String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        if latitude.count > 0 && longitude.count > 0{
            
            
            
            let GdetailLink : String = "https://maps.googleapis.com/maps/api/place/details/json?latlng=\(latitude),\(longitude)&key=\(Constants.GoogleKey.kGoogle_Key)"
            
            WebService.CallRequestUrl(GdetailLink) { (success, response) in
                CompletionHandler(success, response)
            }
            
        } else {
            let errDict:NSDictionary = ["message":"Please enter latitude and longitude"]
            CompletionHandler(false,errDict)
        }
        
    }
    
    
    class func GetPlaceDetailByPlaceId(_ place_id:String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        if place_id.count > 0 {
            let GdetailLink : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid="  + place_id  + "&key=\(Constants.GoogleKey.kGoogle_Key)"
            
            WebService.CallRequestUrl(GdetailLink) { (success, response) in
                CompletionHandler(success, response)
            }
            
        } else {
            let errDict:NSDictionary = ["message":"Place Id not found"]
            CompletionHandler(false,errDict)
        }
        
    }
//    class func updateShedulePlanNotes(para:NSDictionary,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
//
//        let link = "\(MAIN_LINK)" + "/" + UPDATE_SCHEDULEPLAN_NOTES
//            WebService.CallRequestUrl(link) { (success, response) in
//
//                print(response)
//                CompletionHandler(success, response)
//
//        }
//
//    }
    class func GetNearByCompletePlaces(_ inputText:String,locationString: String, radiusString: String, strTypes: String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        let encodedInput = inputText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        
        let typesString = strTypes.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        
        //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Indu&sensor=true&key=AIzaSyBVdxJI0jbuBw9nx9FRgjW57dshijFieyo&location=23.0280562,72.557758&radius=2000.000000
        
        let fullLink = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationString)&radius=\(radiusString)&types=\(typesString)&keyword=\(encodedInput)&key=\(Constants.GoogleKey.kGoogle_Key)"
    
        WebService.CallRequestUrl(fullLink) { (success, response) in
            CompletionHandler(success, response)
        }
        
    }

    class func GetAutoCompletePlaces(_ inputText:String,locationString: String, radiusString: String, CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        let encodedInput = inputText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
 
        let fullLink = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(encodedInput)&sensor=false&key=\(Constants.GoogleKey.kGoogle_Key)&location=\(locationString)&radius=\(radiusString)"
 
        WebService.CallRequestUrl(fullLink) { (success, response) in
            CompletionHandler(success, response)
        }
        
    }
    
    
    //MARK:- Use For Zomato api
    class func postWithURL(serverlink:String, methodname:String, param:NSDictionary, key:String,successStatusCode : Int,  CompletionHandler : @escaping  (Bool,NSDictionary) -> ())
    {
        print("POST : " + serverlink + methodname + " and Param \(param) ")
        
        var fullLink = serverlink
        
        if fullLink.characters.count > 0 {
            
            fullLink = serverlink + methodname
        }
        else {
            
            fullLink = methodname
        }
        
        var header = [String : String]()
        if key != ""
        {
            header = ["content-type":"application/json","user-key":key]
        }
        else
        {
            header = ["content-type":"application/json"]
        }
        
        Alamofire.request(fullLink, method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
                
                print("response of \(fullLink)")
                print(TempresponseDict)
                
                var statusCode = response.response?.statusCode
                
                if statusCode == successStatusCode {
                    
                    CompletionHandler(true, TempresponseDict)
                }
                else {
                    
                    
                    
                    if let error = response.result.error as? AFError {
                        
                        statusCode = error._code // statusCode private
                        
                        switch error {
                            
                        case .invalidURL(let url):
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        case .parameterEncodingFailed(let reason):
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .multipartEncodingFailed(let reason):
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .responseValidationFailed(let reason):
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            
                            switch reason {
                                
                            case .dataFileNil, .dataFileReadFailed:
                                print("Downloaded file could not be read")
                            case .missingContentType(let acceptableContentTypes):
                                print("Content Type Missing: \(acceptableContentTypes)")
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                            case .unacceptableStatusCode(let code):
                                print("Response status code was unacceptable: \(code)")
                                statusCode = code
                            }
                        case .responseSerializationFailed(let reason):
                            
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            // statusCode = 3840 ???? maybe..
                        }
                        
                        print("Underlying error: \(String(describing: error.underlyingError))")
                    }
                    else if let error = response.result.error as? URLError {
                        
                        print("URLError occurred: \(error)")
                    }
                    else {
                        
                        print("Unknown error: \(String(describing: response.result.error))")
                    }
                    
                    print("\(String(describing: statusCode))") // the status code
                    
                    CompletionHandler(false, TempresponseDict)
                }
            }
            else {
                //print("Fail \(fullLink)")
                CompletionHandler(false, NSDictionary())
            }
        }
        //        }
    }
    
    
}
