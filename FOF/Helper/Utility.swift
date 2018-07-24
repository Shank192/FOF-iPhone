////
////  Utility.swift
//
//
import UIKit
struct Utility{
    static func UIColorFromHex(_ rgbValue: UInt) -> UIColor
    {
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1)
        )
    }
//    
//    // MARK:- MBProgress Indicator Methods
   
}
//
//    // MARK:- Bottom Border UITextField
//    func addTextFieldpadding(txtField : UITextField,paddingLeft : CGFloat,paddingRight : CGFloat) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingLeft, height: txtField.frame.size.height))
//        txtField.leftView = paddingView
//        txtField.leftViewMode = .always
//        
//        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: paddingRight, height: txtField.frame.size.height))
//        txtField.rightView = paddingView1
//        txtField.rightViewMode = .always
//    }
//}
//
////// MARK: - Side Menu
////extension UIViewController {
////    func setupSideMenu() {
////        // Define the menus
////        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
////        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
////        SideMenuManager.menuFadeStatusBar = false
////    }
////}
//
//
//extension UITextField{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
//        }
//    }
//}
//
//// MARK: - Toast Methods
//func toastView(message : String) {
//    let toastLabel = UILabel(frame: CGRect(x: UIApplication.shared.keyWindow!.frame.size.width/2 - 150, y: (UIApplication.shared.keyWindow?.frame.size.height)!-120, width:300,  height : 50))
//    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//    toastLabel.textColor = UIColor.white
//    toastLabel.textAlignment = NSTextAlignment.center;
//    //appDelegate.window!.addSubview(toastLabel)
//    UIApplication.shared.keyWindow?.addSubview(toastLabel)
//    toastLabel.text = message
//    toastLabel.numberOfLines = 0
//    toastLabel.alpha = 1.0
//    toastLabel.font = UIFont(name: "Montserrat-Light", size: 5.0)
//    toastLabel.layer.cornerRadius = 10;
//    toastLabel.clipsToBounds  =  true
//    UIView.animate(withDuration: 6, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
//        toastLabel.alpha = 0.0
//    })
//}
//
//// MARK: - Trim String
//func trimString(string : NSString) -> NSString {
//    return string.trimmingCharacters(in: NSCharacterSet.whitespaces) as NSString
//}
//
//// MARK:- Alert View
//func showAlertView(_ strAlertTitle : String, strAlertMessage : String) -> UIAlertController {
//    let alert = UIAlertController(title: strAlertTitle, message: strAlertMessage, preferredStyle: UIAlertControllerStyle.alert)
//    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
//    }))
//    return alert
//}
//MARK: - Random color generator

func random() -> CGFloat {
    
    let testCol = CGFloat(arc4random()) / CGFloat(UInt32.max)
    
    return testCol < 100 ? testCol : (testCol > 200) ? (testCol - 200) : (testCol - 100)
}



func setImageOnAnnotationPin(_ pinImg:UIImage,placeImg:UIImage) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(pinImg.size, false, 0.0);
    
    pinImg.draw(in: CGRect(origin: CGPoint.zero, size: pinImg.size))
    
    let roundRect : CGRect = CGRect(x: 2, y: 2, width: pinImg.size.width-4, height: pinImg.size.width-4)
    let myUserImgView = UIImageView(frame: roundRect)
    myUserImgView.image = placeImg
    let layer: CALayer = myUserImgView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = myUserImgView.frame.size.width/2
    
    UIGraphicsBeginImageContextWithOptions(myUserImgView.bounds.size, myUserImgView.isOpaque, 0.0)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    roundedImage?.draw(in: roundRect)
    
    
    let resultImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return resultImg
}







// MARK:- Navigation
//func navigateVC(identifierId : String) -> UIViewController {
//    let controller = Constants.GlobalConstants.iPhoneStoryboard.instantiateViewController(withIdentifier: identifierId)
//    return controller
//}
//MARK: - image resize

func resizeImageWithWidth(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    
    //let scale = newWidth / image.size.width
    //let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
//MARK: - current values
func CurrentDate() -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let result = formatter.string(from: date)
    return result
}
func setCurrentTime(){
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
   let str = dateFormatter.string(from: date)
    //UserDefaults.standard.set(str, forKey: Constants.UserDefaults.chooseCurrentTime)
}
func UIColorFromHex(_ rgbValue: UInt) -> UIColor
{
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1)
    )
}
//
//func setUserDefault(ObjectToSave : AnyObject?  , KeyToSave : String) {
//    let defaults = UserDefaults.standard
//    
//    if (ObjectToSave != nil)
//    {
//        
//        defaults.set(ObjectToSave, forKey: KeyToSave)
//    }
//    
//    UserDefaults.standard.synchronize()
//}
//
//func getUserDefault(KeyToReturnValye : String) -> AnyObject? {
//    let defaults = UserDefaults.standard
//    
//    if let name = defaults.value(forKey: KeyToReturnValye)
//    {
//        return name as AnyObject?
//    }
//    return nil
//}
//
//// MARK: - Navigation Status Bar
//extension UINavigationController {
//    override open var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//        
//    }
//}
//

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @available(iOS 11.0, *)
    @IBInspectable
    var borderColor: UIColor? {
        get {
            //let color1 : UIColor?
                let color = UIColor.init(named: layer.borderColor as! String)
                 return color
            
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            //layer.cornerRadius = cornerRadius1
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
            
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.1
           // layer.shadowRadius = shadowRadius/2
          // layer.shadowPath = shadowPath.cgPath
        }
    }
}

