//
//  groupScreenVC.swift
//  FOF
//
//

import UIKit

class groupScreenVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var txtGroupName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddPhotoAct(_ sender: Any) {
    }
    

    // MARK: - Uitableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group Members"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableviewCell
        cell.imgProfilePic.cornerRadius = cell.imgProfilePic.frame.width / 2
        cell.imgProfilePic.clipsToBounds = true
        cell.imgProfilePic.image = UIImage(named: "ross.jpg")
        cell.lblContactNameGroup.text = "Ross Geller"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
