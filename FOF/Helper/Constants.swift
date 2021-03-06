


import UIKit

struct Constants {
    
    //MARK: - device type
    enum UIUserInterfaceIdiom : Int{
        case Unspecified
        case Phone
        case Pad
    }
    

   // MARK: - Global Utility
    struct GlobalConstants {
        static let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
        static let iPhoneStoryboard = UIStoryboard(name: "Main", bundle: nil)
        static let appDelegate = UIApplication.shared.delegate as! AppDelegate
        static let LoaderAnimation = "preparture-animation"
    }
    
    struct WebServiceUrl {
//    static let mainUrl    = "http://entrega.in/projects/fof/api/post.php"
        static let mainUrl = "http://54.177.127.170/api/"
//        static let mainUrl = "http://192.168.1.14/fof/api/"
    }

    struct APIName {
        //    static let mainUrl    = "http://entrega.in/projects/fof/api/post.php"
        static let LOGIN = "user/login"
        static let GetTestBuds = "user/getTastebuds"
        static let GetUserProfile  = "user/getUserProfile"
        static let SaveUserTestbuds  = "user/addUsersTastebuds"
        static let updateUserData  = "user/updateUserData"
        static let GetUserSuggestion  = "user/getUserSuggestions"
        static let SendFriendRequest = "user/sendFriendRequest"
        static let AcceptFriendRequest = "user/acceptFriendRequest"
        static let getZomatoKEey = "user/getZomatoKey"
        static let GetFriendRequestList = "user/getFriendRequestList"
        static let GetFriendList = "user/getFriendsList"
        static let UpdateProfilePic = "user/updateProfilePic"
        static let rejectFrinedREquest = "user/rejectFriendRequest"
        static let CreateGroup = "user/createGroup"
        static let GetGroupList = "user/getUsersGroups"
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
        static let kGoogle_Key = "AIzaSyBeCwWhLWHD_u5LM_8hR2myNEwj8NcgS_E"//"AIzaSyCCmgwexZk3S_kThFZXxZbxRcCJwElEPDw"        
    }
    struct color {
        
        static let matchProgressColor = Utility.UIColorFromHex(0x8b1ea7)
        static let friendMatchProgressColor = Utility.UIColorFromHex(0xD42926)
       // static let selectColor = Utility.UIColorFromHex(0xa32e43)
    }
    struct UserDefaults{
        //Devices
        static let deviceID = "deviceID"
        static let deviceToken = "deviceToken"
        //userData
        static let LoginData = "LoginData"
        static let user_ID = "user_ID"
        static let session_ID = "session_ID"
        static let isFriend = "isFriend"
        static let User_FullName = "User_FullName"
        static let User_First_Name = "User_First_Name"
        static let User_Last_Name = "User_Last_Name"
        static let User_Email = "User_Email"
        static let email_ID = "email_ID"
        static let gender = "gender"
        static let alreadyLogin = "alreadyLogin"
        static let isregistered = "isregistered"
        static let isLoging = "isUserLoging"
        static let MyTestBuds = "MyTestBuds"
        static let MySelectedTEstBudsID = "MySelectedTEstBudsID"
        static let SelectedZomatoTestBudsID = "SelectedZomatoTestBudsID"
        static let ProfileData = "ProfileData"
        static let CurrentCity = "CurrentCity"
        static let receiverId = "receiverId"
        static let receiverDP = "receiverDP"
        static let matchId = "matchId"
        
        static let FilterDistance = "FilterDistance"
        
        static let isCurrentLocationRestro = "isCurrentLocationRestro"
        static let isCurrentLocationFrnd = "isCurrentLocationFrnd"
        
        static let currentLatitude = "currentLatitude"
        static let currentLongitude = "currentLongitude"
        static let AllTestBudsArrayFromYourLocation = "AllTestBudsArrayFromYourLocation"
        static let isOpenFriendViewController = "isOpenFriendViewController"
        static let notificationName = Notification.Name("NotificationIdentifier")
        static let pushNotificationName = Notification.Name("pushNotificationName")

        
    }
    struct Font{
        static let FONT_OPENSANS_REGULAR = "OpenSans"
        static let FONT_OPENSANS_SEMIBOLD = "OpenSans-Semibold"
    }
 
}


