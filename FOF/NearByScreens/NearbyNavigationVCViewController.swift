//
//  NearbyNavigationVCViewController.swift
//  FOF
//
//  Created by 360dts on 27/07/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class NearbyNavigationVCViewController: UINavigationController {

    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if app.IsGoSingle == true
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByRestaurantsScreenVC") as! nearByRestaurantsScreenVC
            self.setViewControllers([obj], animated: true)
        }
        else
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "nearByFriendsScreenVC") as! nearByFriendsScreenVC
            self.setViewControllers([obj], animated: true)
        }
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
