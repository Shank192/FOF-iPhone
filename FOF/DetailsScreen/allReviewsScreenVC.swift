//
//  allReviewsScreenVC.swift
//  FOF
//
//  Created by 360dts on 31/07/18.
//  Copyright © 2018 360dts. All rights reserved.
//

import UIKit

class allReviewsScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblViewReviews: UITableView!
    var arrForReviews = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Button Action Method
     
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrForReviews.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! chatTableviewCell
        cell.lblReviewrName.text = arrForReviews[indexPath.row]["author_name"] as? String
        cell.lblReviews.text = arrForReviews[indexPath.row]["text"] as? String
        cell.imgViewReviewer.cornerRadius = cell.imgViewReviewer.frame.width/2
        cell.imgViewReviewer.clipsToBounds = true
        let url = NSURL(string: arrForReviews[indexPath.row]["profile_photo_url"] as! String)!  as URL
        cell.imgViewReviewer.sd_setImage(with: url)
        let rating = arrForReviews[indexPath.row]["rating"] as! Int
        switch rating {
        case 1:
            cell.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar2Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            cell.btnStar3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            cell.btnStar4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            cell.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            break
        case 2:
            cell.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar3Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            cell.btnStar4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            cell.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            break
        case 3:
            cell.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar4Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            cell.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            break
        case 4:
            cell.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar5Out.setImage(UIImage(named: "whiteStarButton"), for: .normal)
            break
        case 5:
            cell.btnStar1Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar2Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar3Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar4Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            cell.btnStar5Out.setImage(UIImage(named: "redStarButton"), for: .normal)
            break
        default:
            break
        }
        
        return cell
    }

}
