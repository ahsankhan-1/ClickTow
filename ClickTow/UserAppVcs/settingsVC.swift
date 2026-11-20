//
//  settingsVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit

class settingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var SettingsTableView: MyOwnTableView!
    
    var  itemName = ["Notifications Settings","Change Password","Terms & Conditions","Privacy Policy","About","Delete Account"]
    var itemsImg = ["bell","password","Term&Condition","privacy","about","deleteAccount"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Settings"
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        SettingsTableView.delegate = self
        SettingsTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SettingsTableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell
        
        cell.ImageView.image = UIImage(named: itemsImg[indexPath.row])
        cell.nameLbl.text = itemName[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backView.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let userType = Helper.userDic["user_type"] as? String ?? ""
            if userType == "user" {
                let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationSettingsVC") as!
                NotificationSettingsVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "DriverNotificationSettings") as!
                DriverNotificationSettings
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
        } else if indexPath.row == 1 {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "passwordChangeVC") as!
            passwordChangeVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else if indexPath.row == 2 {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "Tems_ConditionVC") as!
            Tems_ConditionVC
            self.navigationController?.pushViewController(vc, animated: true)
            //   UIApplication.shared.openURL(URL(string:"https://sites.google.com/view/vidchex-terms-and-conditions/home")!)
            
            
        } else if indexPath.row == 3 {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "PrivacPolicyVC") as!
            PrivacPolicyVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "aboutVC") as!
            aboutVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "deleteAccountVC") as! deleteAccountVC
            self.addChild(vc)
            vc.view.frame = self.view.frame
            // vc.delegate = self
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
            
        }
    }
    
    
    
}
