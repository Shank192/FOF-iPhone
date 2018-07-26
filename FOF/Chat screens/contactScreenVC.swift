//
//  contactScreenVC.swift
//  FOF
//
//

import UIKit

class contactScreenVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    var arrContactList = NSMutableArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 5}
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Pending Requests"}else{
            return "Messages"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! chatTableviewCell
        if indexPath.section == 0{
          cell.lblPersonName.text = "Rachel Green"
            cell.imgViewProfile.cornerRadius = cell.imgViewProfile.frame.width / 2
            cell.imgViewProfile.clipsToBounds = true
            cell.imgViewProfile.image = UIImage(named: "rachel.jpg")
            cell.lblMessage.text = "New York, USA"
            cell.btnAcceptRequestOut.isHidden = false
            cell.btnCancelRequestOut.isHidden = false
            cell.lblTiming.isHidden = true
            cell.btnNotificationOut.isHidden = true
        }else{
            if indexPath.row == 2 {
                cell.btnNotificationOut.isHidden = false
                cell.btnNotificationOut.setTitle("1", for: .normal)}else{cell.btnNotificationOut.isHidden = true}
        cell.btnAcceptRequestOut.isHidden = true
        cell.btnCancelRequestOut.isHidden = true
        cell.lblTiming.isHidden = false
        cell.imgViewProfile.cornerRadius = cell.imgViewProfile.frame.width / 2
        cell.imgViewProfile.clipsToBounds = true
        cell.imgViewProfile.image = UIImage(named: "Mens.jpg")
        cell.lblTiming.text = "4.55 am"
        cell.lblPersonName.text = "Ross Geller"
        cell.lblMessage.text = "Hello , Hi how are you?"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "userProfileDetailScreenVC") as! userProfileDetailScreenVC
        
        self.navigationController?.pushViewController(obj, animated: false)
    }
   

}
