//
//  ContactSettingVC.swift
//  FOF
//
//  Created by admin on 29/10/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class ContactSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionLogout(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.alreadyLogin)
        UserDefaults.standard.synchronize()
        Constants.GlobalConstants.appDelegate.deleteAllCoreData()
        Constants.GlobalConstants.appDelegate.SetMyRootBy()
    }
    @IBAction func btnActionBack(_ sender: Any)
    {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    

}
