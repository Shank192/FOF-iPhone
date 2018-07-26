
import UIKit
import Alamofire

class Webservices_Alamofier: NSObject {

    //POST Method
    
    class func postWithURL(serverlink:String, methodname:String, param:NSDictionary, key:String,  CompletionHandler : @escaping  (Bool,NSDictionary) -> ())
    {
//        let app = UIApplication.shared.delegate as! AppDelegate
//        
//        if app.networkStatus == .NotReachable {
//            
//            print("not connect..")
//            app.showNetworkAlert()
//            CompletionHandler(false, NSDictionary())
//        }
//        else {
        
            print("POST : " + serverlink + methodname + " and Param \(param) ")
            
            var fullLink = serverlink
            
            if fullLink.count > 0 {
                
                fullLink = serverlink + methodname
            }
            else {
                
                fullLink = methodname
            }
           Alamofire.request(fullLink, method: .post, parameters: param as? Parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON { (response) in
                
                print(response)
                
                if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
                    
                    print("response of \(fullLink)")
                    print(TempresponseDict)
                    
                    if (TempresponseDict.object(forKey: "response") as? String)?.caseInsensitiveCompare("success") == .orderedSame {
                        
                        CompletionHandler(true, TempresponseDict)
                    }
                    else {
                        
                        var statusCode = response.response?.statusCode
                        
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
                            
                            print("Underlying error: \(error.underlyingError)")
                        }
                        else if let error = response.result.error as? URLError {
                            
                            print("URLError occurred: \(error)")
                        }
                        else {
                            
                            print("Unknown error: \(response.result.error)")
                        }
                        
                        print("\(statusCode)") // the status code
                        
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
    
    class func CallRequestUrl(_ serverlink:String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        print("Google Link : \(serverlink)")
        
        Alamofire.request(serverlink, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            print("Google Link Response: \(response)")
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
    class func GetPlaceDetailByPlaceId(_ place_id:String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
        
        if place_id.count > 0 {
            let GdetailLink : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid="  + place_id  + "&key=\(Constants.GlobalConstants.googleMapsKey)"
            
            Webservices_Alamofier.CallRequestUrl(GdetailLink) { (success, response) in
                CompletionHandler(success, response)
            }
            
        } else {
            let errDict:NSDictionary = ["message":"Place Id not found"]
            CompletionHandler(false,errDict)
        }
        
    }
    //GET Method
    
    class func getWithURL(_ serverlink:String, methodname:String, param:NSDictionary, CompletionHandler:@escaping (Bool,NSDictionary) -> ())
    {
//        let app = UIApplication.shared.delegate as! AppDelegate
//        
//        if app.networkStatus == .NotReachable {
//            
//            print("not connect..")
//            app.showNetworkAlert()
//            CompletionHandler(false, NSDictionary())
//        }
//        else {
//            
            print("GET: " + serverlink + "/" + methodname + " and Param : \(param)")
            
            var fullLink = serverlink
            
            if fullLink.characters.count > 0 {
                
                fullLink = serverlink + "/" + methodname
            }
            else {
                
                fullLink = methodname
            }
        
   
        
        
            Alamofire.request(fullLink, method: .get, parameters: param as? Parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON { (response) in
                
                print(response)
                
                if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
                    
                    
                    print("response of \(fullLink)")
                    print(TempresponseDict)
                    
                    if (TempresponseDict.object(forKey: "response") as? String)?.caseInsensitiveCompare("success") == .orderedSame {
                        
                        CompletionHandler(true, TempresponseDict)
                    }
                    else {
                        
                        var statusCode = response.response?.statusCode
                        
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
                            
                            print("Underlying error: \(error.underlyingError)")
                        }
                        else if let error = response.result.error as? URLError {
                            
                            print("URLError occurred: \(error)")
                        }
                        else {
                            
                            print("Unknown error: \(response.result.error)")
                        }
                        
                        print("\(statusCode)") // the status code
                        
                        CompletionHandler(false, TempresponseDict)
                    }
//                }
//                else {
//                    //print("Fail \(fullLink)")
//                    CompletionHandler(false, NSDictionary())
//                }
            }
        }
    }
    
    //Send Image
    
    class func postImageToUrl(_ serverlink:String,methodname:String,param:NSDictionary,image:UIImage!,withImageName : String,CompletionHandler:@escaping (Bool,NSDictionary) -> ()) {
        
//        let app = UIApplication.shared.delegate as! AppDelegate
//        
//        if app.networkStatus == .NotReachable {
//            
//            print("not connect..")
//            app.showNetworkAlert()
//            CompletionHandler(false, NSDictionary())
//        }
//        else {
        
            print("POST : " + serverlink + methodname + " and Param \(param) ")
        
            var fullLink = serverlink
            
            if fullLink.characters.count > 0 {
                
                fullLink = serverlink + "/" + methodname
            }
            else {
                
                fullLink = methodname
            }
            
            var imgData = Data()
            if image != nil {
                
                imgData = UIImageJPEGRepresentation(image!, 0.8)!
            }
            
            let notallowchar : CharacterSet = CharacterSet(charactersIn: "01234").inverted
            let dateStr:String = "\(Date())"
            let resultStr:String = (dateStr.components(separatedBy: notallowchar) as NSArray).componentsJoined(by: "")
            let imagefilename = resultStr + ".jpg"
            
            Alamofire.upload(multipartFormData:{ multipartFormData in
                multipartFormData.append(imgData, withName: withImageName as String, fileName: imagefilename, mimeType: "image/jpeg")
                
                for (key, value) in param {
                    
                    print(value)
                    if let value = value as? String
                    {
                        let data = value.data(using: String.Encoding.utf8)!
                        multipartFormData.append(data, withName: key as! String)
                    }
                    else
                    {
                        let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue)
                        multipartFormData.append(data!, withName: key as! String)
                    }
                    
                   
                    
                    
                    //                if value is [String]{
                    //                    let data = value.data(using: String.Encoding.utf8.rawValue)
                    //                    multipartFormData.append(data!, withName: key)
                    //                }
                    //                else if value is String{
                    //                    let data = value.data(using: String.Encoding.utf8.rawValue)
                    //                    multipartFormData.append(data!, withName: key)
                    //                }
                    //                else if let v = value as? Bool{
                    //                    var bValue = v
                    //                    let d = bValue.dataUsingEncoding(String.Encoding.utf8)! //NSData.init(bytes: &bValue, length: MemoryLayout<Bool>.size) //NSData(bytes: &bValue, length: MemoryLayout<Bool>.size)
                    //                    multipartFormData.append(d, withName: key)
                    //                    multipartFormData. .append(d, withName: key)
                    //                }
                }
            },
            usingThreshold:UInt64.init(),
            to:fullLink,
            method:.post,
            headers:[:],
            encodingCompletion: { encodingResult in
            
                switch encodingResult {
                                    
                    case .success(let upload, _, _):
                                    
                    upload.uploadProgress { progress in // main queue by default
                                     
                        print("Upload Progress: \(progress.fractionCompleted)")
                    }
                                    
                    upload.responseJSON { response in
                        
                        print(response)
                        
                                        
                        if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
                                            
                            if (TempresponseDict.object(forKey: "response") as? String)?.caseInsensitiveCompare("success") == .orderedSame {
                                                
                                CompletionHandler(true, TempresponseDict)
                            }
                            else {
                                
                                var statusCode = response.response?.statusCode
                                
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
                                    
                                    print("Underlying error: \(error.underlyingError)")
                                }
                                else if let error = response.result.error as? URLError {
                                    
                                    print("URLError occurred: \(error)")
                                }
                                else {
                                    
                                    print("Unknown error: \(response.result.error)")
                                }
                                
                                print("\(statusCode)") // the status code
                                
                                
                                CompletionHandler(false, TempresponseDict)
                            }
                        }
                        else {
                                            
                            CompletionHandler(false, NSDictionary())
                        }
                    }
                    
                    case .failure(let encodingError):
                        
                        print(encodingError)
                        
                        CompletionHandler(false, NSDictionary())
                }
            })
        //}
    }
    
    
    
    //Send Image
    
//    class func postImageToUrl(_ serverlink:String,methodname:String,param:NSDictionary,image:UIImage!,CompletionHandler:@escaping (Bool,NSDictionary) -> ()) {
//        
//        if image != nil {
//            
//            print("POST: " + serverlink + "/" + methodname + " and Param : \(param)")
//            
//            var fullLink = serverlink
//            
//            if fullLink.characters.count > 0 {
//                
//                fullLink = serverlink + "/" + methodname
//            }
//            else {
//                
//                fullLink = methodname
//            }
//            
//            let imageData = UIImageJPEGRepresentation(image, 1.0)
//            
//            let notallowchar : CharacterSet = CharacterSet(charactersIn: "01234").inverted
//            let dateStr:String = "\(Date())"
//            let resultStr:String = (dateStr.components(separatedBy: notallowchar) as NSArray).componentsJoined(by: "")
//            let imagefilename = resultStr + ".jpg"
//            
//            //["PreParture-APIKEY":"\(keyValue)"]
//            
//            Alamofire.upload(
//                .POST,
//                "http://sample.com/api/upload",
//                multipartFormData: { multipartFormData in
//                    multipartFormData.appendBodyPart(data: imageData, name: "yourParamName", fileName: "imageFileName.jpg", mimeType: "image/jpeg")
//                    multipartFormData.appendBodyPart(data: apiToken.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"api_token")
//                    multipartFormData.appendBodyPart(data: otherBodyParamValue.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"otherBodyParamName")
//            },
//                encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .Success(let upload, _, _):
//                        upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//                            print("Uploading Avatar \(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//                            dispatch_async(dispatch_get_main_queue(),{
//                                /**
//                                 *  Update UI Thread about the progress
//                                 */
//                            })
//                        }
//                        upload.responseJSON { (JSON) in
//                            dispatch_async(dispatch_get_main_queue(),{
//                                //Show Alert in UI
//                                print("Avatar uploaded");
//                            })
//                        }
//                        
//                    case .Failure(let encodingError):
//                        //Show Alert in UI
//                        print("Avatar uploaded");
//                    }
//            }
//            );
    
            
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                if let imageData = UIImageJPEGRepresentation(image, 0.6) {
//                    multipartFormData.appendBodyPart(data: imageData, name: "image", fileName: "file.png", mimeType: "image/png")
//                }
//                
//                for (key, value) in parameters {
//                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//                }
//            }, with: fullLink, encodingCompletion: {
//                encodingResult in
//                
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    print("s")
//                    upload.responseJSON {
//                        response in
//                        print(response.request)  // original URL request
//                        print(response.response) // URL response
//                        print(response.data)     // server data
//                        print(response.result)   // result of response serialization
//                        
//                        if let JSON = response.result.value {
//                            print("JSON: \(JSON)")
//                        }
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
//                }
//            })
       // }
//            Alamofire.upload(.POST, URL, multipartFormData: {
//                multipartFormData in
//                
//                if let imageData = UIImageJPEGRepresentation(image, 0.6) {
//                    multipartFormData.appendBodyPart(data: imageData, name: "image", fileName: "file.png", mimeType: "image/png")
//                }
//                
//                for (key, value) in parameters {
//                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//                }
//            }, encodingCompletion: {
//                encodingResult in
//                
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    print("s")
//                    upload.responseJSON {
//                        response in
//                        print(response.request)  // original URL request
//                        print(response.response) // URL response
//                        print(response.data)     // server data
//                        print(response.result)   // result of response serialization
//                        
//                        if let JSON = response.result.value {
//                            print("JSON: \(JSON)")
//                        }
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
//                }
//            })
//            
//            Manager.sharedInstance.upload(.POST, fullLink, headers: [:], multipartFormData: { (formdata) in
//                formdata.appendBodyPart(data: imageData!, name: "imagefile", fileName: imagefilename, mimeType: "image/jpeg")
//                
//                for (key, value) in param {
//                    
//                    formdata.appendBodyPart(data: value.data(using: String.Encoding.utf8)!, name: key as! String)
//                }
//            }, encodingMemoryThreshold: UInt64(10*1024*1024)) { (encodingResult) in
//                
//                switch encodingResult {
//                    
//                case .success(let upload, _, _):
//                    upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
//                        print("1) \(bytesWritten)    2) \(totalBytesWritten)    3) \(totalBytesExpectedToWrite)")
//                        
//                        // This closure is NOT called on the main queue for performance
//                        // reasons. To update your ui, dispatch to the main queue.
//                        DispatchQueue.main.async {
//                            print("Total bytes written on main queue: \(totalBytesWritten)")
//                        }
//                    }
//                    
//                    //upload.responseData(self.handleResponse)
//                    upload.responseJSON(completionHandler: { (response) in
//                        print(response)
//                        if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
//                            
//                            //print("response of \(fullLink)")
//                            if (TempresponseDict.object(forKey: "response") as? String)?.caseInsensitiveCompare("success") == .orderedSame {
//                                
//                                CompletionHandler(success: true, response: TempresponseDict)
//                            }
//                            else {
//                                
//                                CompletionHandler(success: false, response: TempresponseDict)
//                            }
//                        }
//                        else {
//                            //print("Fail")
//                            CompletionHandler(success: false, response: NSDictionary())
//                        }
//                    })
//                case .failure:
//                    //Error
//                    
//                    print("Fail to upload")
//                    CompletionHandler(success: false,response: NSDictionary())
//                }
//            }
//        }
    }
    
    
    
//    class func getWithURL(_ serverlink:String, methodname:String, param:NSDictionary, CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ())
//    {
//        print("GET: " + serverlink + "/" + methodname + " and Param : \(param)")
//        
//        var fullLink = serverlink
//        
//        if fullLink.characters.count > 0 {
//            
//            fullLink = serverlink + "/" + methodname
//        }
//        else {
//            
//            fullLink = methodname
//        }
//        
//        Manager.sharedInstance.request(.GET, fullLink, parameters: param as? [String : AnyObject], encoding: .url, headers: [:])
//            .responseJSON { (response) in
//                
//                print(response)
//                if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
//                    
//                    //print("response of \(fullLink)")
//                    if (TempresponseDict.object(forKey: "response") as? String)?.caseInsensitiveCompare("success") == .orderedSame {
//                        
//                        CompletionHandler(success: true, response: TempresponseDict)
//                    }
//                    else {
//                        
//                        CompletionHandler(success: false, response: TempresponseDict)
//                    }
//                }
//                else {
//                    //print("Fail \(fullLink)")
//                    CompletionHandler(success: false, response: NSDictionary())
//                }
//        }
//    }
    
    //Send Image
    
//    class func postImageToUrl(_ serverlink:String,methodname:String,param:NSDictionary,image:UIImage!,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) {
//        
//        if image != nil {
//            
//            print("POST: " + serverlink + "/" + methodname + " and Param : \(param)")
//            
//            var fullLink = serverlink
//            
//            if fullLink.characters.count > 0 {
//             
//                fullLink = serverlink + "/" + methodname
//            }
//            else {
//            
//                fullLink = methodname
//            }
//            
//            let imageData = UIImageJPEGRepresentation(image, 1.0)
//            
//            let notallowchar : CharacterSet = CharacterSet(charactersIn: "01234").inverted
//            let dateStr:String = "\(Date())"
//            let resultStr:String = (dateStr.components(separatedBy: notallowchar) as NSArray).componentsJoined(by: "")
//            let imagefilename = resultStr + ".jpg"
//            
//            //["PreParture-APIKEY":"\(keyValue)"]
//            
//            Manager.sharedInstance.upload(.POST, fullLink, headers: [:], multipartFormData: { (formdata) in
//                formdata.appendBodyPart(data: imageData!, name: "imagefile", fileName: imagefilename, mimeType: "image/jpeg")
//                
//                for (key, value) in param {
//                   
//                    formdata.appendBodyPart(data: value.data(using: String.Encoding.utf8)!, name: key as! String)
//                }
//            }, encodingMemoryThreshold: UInt64(10*1024*1024)) { (encodingResult) in
//                
//                switch encodingResult {
//                
//                case .success(let upload, _, _):
//                    upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
//                        print("1) \(bytesWritten)    2) \(totalBytesWritten)    3) \(totalBytesExpectedToWrite)")
//                        
//                        // This closure is NOT called on the main queue for performance
//                        // reasons. To update your ui, dispatch to the main queue.
//                        DispatchQueue.main.async {
//                            print("Total bytes written on main queue: \(totalBytesWritten)")
//                        }
//                    }
//                    
//                    //upload.responseData(self.handleResponse)
//                    upload.responseJSON(completionHandler: { (response) in
//                        print(response)
//                        if let TempresponseDict:NSDictionary = response.result.value as? NSDictionary {
//                            
//                            //print("response of \(fullLink)")
//                            if (TempresponseDict.object(forKey: "response") as? String)?.caseInsensitiveCompare("success") == .orderedSame {
//                                
//                                CompletionHandler(success: true, response: TempresponseDict)
//                            }
//                            else {
//                             
//                                CompletionHandler(success: false, response: TempresponseDict)
//                            }
//                        }
//                        else {
//                            //print("Fail")
//                            CompletionHandler(success: false, response: NSDictionary())
//                        }
//                    })
//                case .failure:
//                    //Error
//                    
//                    print("Fail to upload")
//                    CompletionHandler(success: false,response: NSDictionary())
//                }
//            }
//        }
//    }

