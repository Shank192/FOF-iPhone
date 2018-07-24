//
//  Utility.swift
import UIKit

struct Constants {
    
    //MARK: - device type
    enum UIUserInterfaceIdiom : Int{
        case Unspecified
        case Phone
        case Pad
    }
    
//    struct ScreenSize {
//        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
//        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
//        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
//        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
//    }
    
//    struct DeviceType
//    {
//        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
//        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
//        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
//        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
//        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
//    }
//
//    // MARK: - Global Utility
    struct GlobalConstants {
        static let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
        static let iPhoneStoryboard = UIStoryboard(name: "Main", bundle: nil)
        static let appDelegate = UIApplication.shared.delegate as! AppDelegate
        static let LoaderAnimation = "preparture-animation"
    }
    
    // MARK: - WebService URL
    // local : ""
    // live : ""
    struct WebServiceUrl {
        
    }

    
    // MARK: - StoryBoard Identifier's
    struct StoryBoardID{
        static let kLocationSelectionVC = "LocationSelectionScreenVC"
        static let kInterestPickerScreenVC = "interestPickerScreenVC"
        static let kpreviewScreenVC = "previewScreenVC"
      //  static let kContactUsScreenVC = "ContactUsScreenVC"
        //static let kAboutUsScreenVC = "AboutUsScreenVC"
    }
    
    // MARK: - Message's
    struct AlertMessage {
        static let NetworkConnection  = "You are not connected to internet. Please connect and try again"
        
        //Login And Registration Alert message's
        static let EmptyFirstName = "First name is required"
        static let InValidFirstName = "Enter valid first name"
        static let InvalidFirstNameRange = "Please enter first name between 2 to 20 characters!"
        static let EmptyLastName = "Last name is required"
        static let InValidLastName = "Enter valid last name"
        static let InvalidLastNameRange = "Please enter last name between 2 to 20 characters!"
        static let EmptyEmail = "Email is required"
        static let InValidEmail = "Enter valid email id"
        static let EmptyPassword = "Password is required"
        static let InvalidPassword = "Enter valid password"
        static let InvalidPasswordRange = "Please enter password between 8 To 15 characters!"
        static let EmptyConfirmPassword = "Confirm password is required"
        static let SamePassword = "Enter same password"
        
        //FeedBack Alert message's
        static let heartRate = "Heart rate is required"
        static let BodyTemp = "Body temp is required"
        static let InvalidHeartRate = "Enter valid heart rate"
        static let InvalidHeartRateRange = "Please enter heart rate between 10 To 300"
        static let InvalidBodyTemp = "Enter valid body temp"
        static let InvalidBodyTempRange = "Please enter body temp between 90 To 110"
        
        //Contact Us Alert message's
        static let EmptyName = "Name is required"
        static let InValidName = "Enter valid name"
        static let InvalidNameRange = "Please enter name between 2 To 40 characters!"
        static let EmptyPhoneNumber = "Phone number is required"
        static let InvalidPhoneNumber = "Enter valid phone number"
        static let EmptyComment = "Comment is required"
        static let InvalidCommentRange = "Please enter comment minimum 20 characters!"
    }
    struct GoogleKey {
        static let kGoogle_Key = "AIzaSyDOnJYTrItjnk3HPg9n1OswyLpRkDwWU4A"        
    }
    struct constantHight {
        static let hightOfTblDetail = 150
        static let hightOfCurrentTimeHight = 440
    }
    struct SelectedTravelType{
        static let car = "car"
        static let bus_train_station = "bus_train"
        static let bus_train = "bus_train"
        static let Walking = "Walking"
        static let Bicycle = "Bicycle"
    }

    struct NotifyTravelType{
        static let car = "car"
        static let bus_train = "bus_train"
        static let Walking = "Walking"
        static let cycle = "cycle"
    }
    struct UserDefaults{
      
        
    }
    struct Font{
        static let FONT_OPENSANS_REGULAR = "OpenSans"
        static let FONT_OPENSANS_SEMIBOLD = "OpenSans-Semibold"
    }
    // MARK: - ApiConstants
    struct ApiConstants {
        static let paramEmail = "email_id"
        static let ParamuserID = "user_id"
        static let paramPassword = "password"
        static let paramFname = "first_name"
        static let paramLname = "last_name"
        static let paramisUserActive = "isUserActive"
        static let isRemember = "isRemember"
        static let password = "password"
    }
    
}


