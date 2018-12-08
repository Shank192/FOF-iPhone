//
//  chatScreenVC.swift
//  FOF
//
//

import UIKit


class chatScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblviewChatScreen: UITableView!
    var ArrayFriendData = NSMutableArray()

    var restData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wsSetFriendsList()
        tblviewChatScreen.delegate = self
        tblviewChatScreen.dataSource = self
        // Do any additional setup after loading the view.
    }
    // MARK: - webService
    func wsSetFriendsList(){
        
        let param = ["user_id":UserDefaults.standard.object(forKey:Constants.UserDefaults.user_ID)!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Webservices_Alamofier.postWithURL(serverlink: Constants.WebServiceUrl.mainUrl, methodname: Constants.APIName.GetFriendList, param: param as NSDictionary, key: "", successStatusCode: 200) { (success, response) in
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            
            if success == true
            {
                self.ArrayFriendData.removeAllObjects()
                if let response_data = response.object(forKey: "response_data") as? NSDictionary
                {
                    if let dataArray = response_data.object(forKey: "friends") as? NSArray
                    {
                        self.ArrayFriendData = NSMutableArray(array: dataArray)
                        
                        for i in 0..<self.ArrayFriendData.count
                        {
                            if let dict = self.ArrayFriendData.object(at: i) as? NSDictionary
                            {
                                let muteDict = NSMutableDictionary(dictionary: dict)
                                muteDict.setValue("0", forKey: "isSelected")
                                self.ArrayFriendData.replaceObject(at: i, with: muteDict)
                            }
                         }
                        
//                        if dataArray.count != 0
//                        {
//                            for i in 0..<dataArray.count
//                            {
//                                if let dict = dataArray.object(at: i) as? NSDictionary
//                                {
//                                    UserDefaults.standard.set(dict.object(forKey: "id"), forKey: Constants.UserDefaults.matchId)
//                                    UserDefaults.standard.set(dict.object(forKey: "friend1"), forKey: Constants.UserDefaults.user_ID)
//                                    UserDefaults.standard.set(dict.object(forKey: "friend2"), forKey: Constants.UserDefaults.receiverId)
//
//                                    if let details = dict.object(forKey: "details") as? NSArray
//                                    {
//                                        if details.count != 0
//                                        {
//                                            if let detailsDict = details.object(at: 0) as? NSDictionary
//                                            {
//                                                self.ArrayFriendData.add(detailsDict)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//
//                        }
                    }
                    
                    
                }
                print(self.ArrayFriendData)
                self.tblviewChatScreen.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
            }
            else
            {
                if let msg = response.object(forKey: "message") as? String
                {
                    self.view.makeToast(msg)
                }
                else
                {
                    self.view.makeToast("Something went to wrong. Please try after sometime.")
                }
            }
            
        }
        
        
//        WebService.postURL(Constants.WebServiceUrl.mainUrl , param: param as NSDictionary, CompletionHandler: { (success, response) -> () in
//
//            if success == true
//            {
//                self.ArrayFriendData.removeAllObjects()
//                if let dataArray = response.object(forKey: "data") as? NSArray
//                {
//                    if dataArray.count != 0
//                    {
//                        for i in 0..<dataArray.count
//                        {
//                            if let dict = dataArray.object(at: i) as? NSDictionary
//                            {
//                                UserDefaults.standard.set(dict.object(forKey: "id"), forKey: Constants.UserDefaults.matchId)
//                                UserDefaults.standard.set(dict.object(forKey: "friend1"), forKey: Constants.UserDefaults.user_ID)
//                                UserDefaults.standard.set(dict.object(forKey: "friend2"), forKey: Constants.UserDefaults.receiverId)
//
//                                if let details = dict.object(forKey: "details") as? NSArray
//                                {
//                                    if details.count != 0
//                                    {
//                                        if let detailsDict = details.object(at: 0) as? NSDictionary
//                                        {
//                                            self.ArrayFriendData.add(detailsDict)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//
//
//                }
//                print(self.ArrayFriendData)
//                self.tblviewChatScreen.reloadData()
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//
//            }
//            else if response.object(forKey: "message") != nil
//            {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//            }
//            else
//            {
//                if response.object(forKey: "message") != nil
//                {
//                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                }
//            }
//
//
//        })
        
    }
    @IBAction func btnBackAct(_ sender: Any) {
self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnStartChatAct(_ sender: Any) {
        
        let selectedFriebnd = NSMutableArray()
        for i in self.ArrayFriendData
        {
            if let isSelected = (i as! NSDictionary).object(forKey: "isSelected")
            {
                if "\(isSelected)" == "1"
                {
                    selectedFriebnd.add(i as! NSDictionary)
                }
            }
        }
        
        if selectedFriebnd.count != 0
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "groupScreenVC") as! groupScreenVC
            obj.selectedFriend = NSMutableArray(array: selectedFriebnd)
            obj.selectedRestadata = self.restData
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else
        {
            self.view.makeToast("Please select at least 2 friend to create group.")
        }
        
        
    }
    @objc func btnSelectAct(_ sender : Any){
       
        
    }
    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return ArrayFriendData.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
        if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
        {
            if let isSelected = dict.object(forKey: "isSelected")
            {
                if "\(isSelected)" == "1"
                {
                    cell.btnCheckBoxOut.isSelected = true
                }
                else
                {
                    cell.btnCheckBoxOut.isSelected = false
                }
            }
            
            if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let profilepic1 = dict.object(forKey: "profilepic1")
            {
                cell.imgViewProfilePicChat.cornerRadius = cell.imgViewProfilePicChat.frame.width / 2
                cell.imgViewProfilePicChat.clipsToBounds = true
                cell.imgViewProfilePicChat.image = UIImage.init(named: "disableSingle")
                if "\(profilepic1)" != ""
                {
                    if let proURL = URL.init(string: "\(profilepic1)")
                    {
                        cell.imgViewProfilePicChat.sd_setImage(with: proURL, placeholderImage: UIImage.init(named: "disableSingle"))
                    }
                }
                else
                {
                    cell.imgViewProfilePicChat.image = UIImage.init(named: "disableSingle")
                }
                cell.lblContactNameChat.text = "\(first_name) \(last_name)"
                
            }
            
        }
        cell.btnCheckBoxOut.tag = indexPath.row
        cell.btnCheckBoxOut.addTarget(self, action: #selector(btnSelectAct(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
        {
            if let isSelected = dict.object(forKey: "isSelected")
            {
                let muteDict = NSMutableDictionary(dictionary: dict)
                
                
                if "\(isSelected)" == "1"
                {
                    muteDict.setValue("0", forKey: "isSelected")
                }
                else
                {
                    muteDict.setValue("1", forKey: "isSelected")
                }
                self.ArrayFriendData.replaceObject(at: indexPath.row, with: muteDict)
                self.tblviewChatScreen.reloadRows(at: [indexPath], with: .automatic)
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
