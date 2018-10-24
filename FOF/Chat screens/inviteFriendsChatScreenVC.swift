//
//  chatScreenVC.swift
//  FOF
//
//

import UIKit


class chatScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblviewChatScreen: UITableView!
    var ArrayFriendData = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        wsSetFriendsList()
        tblviewChatScreen.delegate = self
        tblviewChatScreen.dataSource = self
        // Do any additional setup after loading the view.
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
                                UserDefaults.standard.set(dict.object(forKey: "id"), forKey: Constants.UserDefaults.matchId)
                                UserDefaults.standard.set(dict.object(forKey: "friend1"), forKey: Constants.UserDefaults.user_ID)
                                UserDefaults.standard.set(dict.object(forKey: "friend2"), forKey: Constants.UserDefaults.receiverId)
                                
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
                self.tblviewChatScreen.reloadData()
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
    @IBAction func btnBackAct(_ sender: Any) {
self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnStartChatAct(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "groupScreenVC") as! groupScreenVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @objc func btnSelectAct(_ sender : Any){
       
        
    }
    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ArrayFriendData.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
        if let dict = self.ArrayFriendData.object(at: indexPath.row) as? NSDictionary
        {
            
            if let first_name = dict.object(forKey: "first_name"),let last_name = dict.object(forKey: "last_name"),let profilepic1 = dict.object(forKey: "profilepic1")
            {
            cell.imgViewProfilePicChat.cornerRadius = cell.imgViewProfilePicChat.frame.width / 2
            cell.imgViewProfilePicChat.clipsToBounds = true
            cell.imgViewProfilePicChat.image = UIImage.init(named: "disableSingle")
                if "\(profilepic1)" != ""
                {
                    if let proURL = URL.init(string: "\(profilepic1)")
                    {
                        cell.imgViewProfilePicChat.sd_setImage(with: proURL)
                    }
                }
        cell.lblContactNameChat.text = "\(first_name) \(last_name)"}}
        cell.btnCheckBoxOut.tag = indexPath.row
        cell.btnCheckBoxOut.addTarget(self, action: #selector(btnSelectAct(_:)), for: .touchUpInside)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
