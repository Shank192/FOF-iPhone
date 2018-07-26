//
//  chatScreenVC.swift
//  FOF
//
//

import UIKit

class chatScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblviewChatScreen: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblviewChatScreen.delegate = self
        tblviewChatScreen.dataSource = self
        // Do any additional setup after loading the view.
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
            return 5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
            cell.imgViewProfilePicChat.cornerRadius = cell.imgViewProfilePicChat.frame.width / 2
            cell.imgViewProfilePicChat.clipsToBounds = true
            cell.imgViewProfilePicChat.image = UIImage(named: "ross.jpg")
            cell.lblContactNameChat.text = "Ross Geller"
        cell.btnCheckBoxOut.tag = indexPath.row
        cell.btnCheckBoxOut.addTarget(self, action: #selector(btnSelectAct(_:)), for: .touchUpInside)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
