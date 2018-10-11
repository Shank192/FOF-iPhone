//
//  FoFTabBarScreenVC.swift
//  FOF
//


import UIKit

class FoFTabBarScreenVC: UITabBarController {

    var issingle = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let item1 : UITabBarItem = self.tabBar.items![0]
        item1.image = UIImage(named: "tab_Profile_gray")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item1.selectedImage = UIImage(named: "tab_Profile_red")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        
        let item2 : UITabBarItem = self.tabBar.items![1]
        item2.image = UIImage(named: "tab_Home_gray")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item2.selectedImage = UIImage(named: "tab_Home_red")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let item3 : UITabBarItem = self.tabBar.items![2]
        item3.image = UIImage(named: "tab_chat_grey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item3.selectedImage = UIImage(named: "tab_Chat_red")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        
        let topBoder = CALayer()
        topBoder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.height, height: 1)
        topBoder.backgroundColor = Utility.UIColorFromHex(0xEFEFEF).cgColor
        self.tabBar.layer.addSublayer(topBoder)
        UITabBar.appearance().barTintColor = UIColor.white
        self.tabBar.clipsToBounds = true
            let obj = getFriendsScreen()
            obj.wsSetFriendsList { (isNewUser, arrFrndData) in}
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
