//
//  SideMenuVC.swift
//  ClickTow
//
//  Created by M Hayat on 15/02/2023.
//

import UIKit
import SDWebImage

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var SideMenuTableView: UITableView!
    
    var itemsImgData = ["Frame (2)","info","Term&Condition","logout"]
    var itemsNameData = ["Home","About","Privacy Policy","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        MainView.layer.cornerRadius = 20
        MainView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        SideMenuTableView.delegate = self
        SideMenuTableView.dataSource = self
        UserImageView.layer.cornerRadius = UserImageView.frame.height / 2
        
        let imgUrl = Helper.userDic["dp"] as? String ?? ""
        self.UserImageView.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "profile"))
        let fullName = (Helper.userDic["first_name"] as? String ?? "" ) + " " + (Helper.userDic["last_name"] as? String ?? "")
        self.nameLbl.text = fullName
        self.emailLbl.text = Helper.userDic["email"] as? String ?? ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsNameData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.nameLbl.text = itemsNameData[indexPath.row]
        cell.ImageView.image = UIImage(named: itemsImgData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                switch indexPath.row {
                case 0:
                    dismiss(animated: true, completion: nil)
                case 1:
                    let vc = storyboard?.instantiateViewController(identifier: "aboutVC") as! aboutVC
                    navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc = storyboard?.instantiateViewController(identifier: "PrivacPolicyVC") as! PrivacPolicyVC
                    navigationController?.pushViewController(vc, animated: true)
                case 3:
                    
                    let vc = self.storyboard?.instantiateViewController(identifier:"SideMenuLogoutVC") as? SideMenuLogoutVC
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
    
                default:
                    break
                }
            }
    
}
