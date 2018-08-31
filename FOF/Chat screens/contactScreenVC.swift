//
//  contactScreenVC.swift
//  FOF
//
//

import UIKit
import MBProgressHUD

class contactScreenVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    var arrContactList = NSMutableArray()
    var ArrayFriendData = NSMutableArray()
    var arrFriendData = [[String:AnyObject]]()

    @IBOutlet weak var tblViewFrndList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        wsSetFriendsList()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - webService
    func wsSetFriendsList(){
        let param = ["action":"myfriends","userid":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID),"sessionid":UserDefaults.standard.object(forKey:Constants.UserDefaults.session_ID)]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
            
            if success == true
            {
                self.ArrayFriendData.removeAllObjects()
                if let dataArray = response.object(forKey: "data") as? NSArray
                {
                    if dataArray.count != 0
                    {
                        for i in 0..<dataArray.count
                        {
                            if let dict = dataArray.object(at: i) as? NSDictionary
                            {
                                self.arrFriendData.append(dict as! [String : AnyObject])
                             
                                
                                if let details = dict.object(forKey: "details") as? NSArray
                                {
                                    if details.count != 0
                                    {
                                        if let detailsDict = details.object(at: 0) as? NSDictionary
                                        {
                                            self.ArrayFriendData.add(detailsDict)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                }
                print(self.ArrayFriendData)
                self.tblViewFrndList.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

            }
            else if response.object(forKey: "message") != nil
            {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            else
            {
                if response.object(forKey: "message") != nil
                {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
            }
            
            
        })
        
    }
    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return ArrayFriendData.count}
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
            if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
            {
                
                if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let profilepic1 = dict.object(forKey: "profilepic1")
                {
        cell.btnAcceptRequestOut.isHidden = true
        cell.btnCancelRequestOut.isHidden = true
        cell.lblTiming.isHidden = false
        cell.imgViewProfile.cornerRadius = cell.imgViewProfile.frame.width / 2
        cell.imgViewProfile.clipsToBounds = true
        cell.imgViewProfile.image = UIImage.init(named: "disableSingle")
                    if "\(profilepic1)" != ""
                    {
                        if let proURL = URL.init(string: "\(profilepic1)")
                        {
                            cell.imgViewProfile.sd_setImage(with: proURL)
                        }
                    }
        cell.lblTiming.text = "4.55 am"
        cell.lblPersonName.text =  "\(first_name) \(last_name)"
        cell.lblMessage.text = "Hello , Hi how are you?"
                    
                }}
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
        {if let dataDict = self.arrFriendData[indexPath.row] as? NSDictionary{
                if dataDict.object(forKey: "status") as! String == "0"{
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "sentRequestRestaurantScreenVC") as! sentRequestRestaurantScreenVC
                       
                    obj.dictUserDetails = arrFriendData[indexPath.row] as NSDictionary
                        self.navigationController?.pushViewController(obj, animated: false)
                }else{
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "conversationScreenVC") as! conversationScreenVC
            UserDefaults.standard.set(dataDict.object(forKey: "id"), forKey: Constants.UserDefaults.matchId)
            UserDefaults.standard.set(dataDict.object(forKey: "friend1"), forKey: Constants.UserDefaults.senderId)
                UserDefaults.standard.set(dataDict.object(forKey: "friend2"), forKey: Constants.UserDefaults.receiverId)
            obj.strReceiverName = "\(dict.object(forKey: "first_name")!) \(dict.object(forKey: "last_name")!)"
                    obj.isFreind = true
           if let profilepic1 = dict.object(forKey: "profilepic1") as? String{
            UserDefaults.standard.setValue(profilepic1, forKey: Constants.UserDefaults.receiverDP)}else{
            UserDefaults.standard.setValue("", forKey: Constants.UserDefaults.receiverDP)
                    }
            self.navigationController?.pushViewController(obj, animated: false)
        }}
        }
     
    }
   

}
