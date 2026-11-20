//
//  profileVC.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit
import SDWebImage

class profileVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var ProfileTableView: MyOwnTableView!
    
    
    var  itemName = ["Edit Profile","Settings","Help","Logout"]
    var itemsImg = ["edit profile","settings","help","logout"]



    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.layer.frame.height/2
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = #colorLiteral(red: 0.03529411765, green: 0.6196078431, blue: 0.5019607843, alpha: 1)
        ProfileTableView.delegate = self
        ProfileTableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
        UserData()
    }
    
    //MARK: User Data -
    func UserData() {
        showIndicator(caption: "Please wait...")
        Helper.dbRef.collection("Users").document(Helper.userId).addSnapshotListener { snapshot, error in
            guard let snap = snapshot?.data(), error == nil else {
                print(error?.localizedDescription as Any)
                print("No Data Found in Dictionary")
                self.hideIndicator()
                return
            }
            self.userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let dic = snap as NSDictionary
            Helper.userDic = dic
            let imageurl = dic["dp"] as? String ?? ""
            let imgUrl = dic["dp"] as? String ?? ""
            self.userImageView.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "profile"))
            let fullName = (dic["first_name"] as? String ?? "" ) + " " + (dic["last_name"] as? String ?? "")
            self.nameLbl.text = fullName
            self.emailLbl.text = dic["email"] as? String ?? ""
            self.hideIndicator()
          
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ProfileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
        
        cell.ImageView.image = UIImage(named: itemsImg[indexPath.row])
        cell.nameLbl.text = itemName[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backView.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "editprofileVC") as! editprofileVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! settingsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "helpVC") as! helpVC
            self.navigationController?.pushViewController(vc, animated: true)
            

        } else if indexPath.row == 3 {
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "logoutVC") as! logoutVC
            self.addChild(vc)
            vc.view.frame = self.view.frame
            // vc.delegate = self
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }


}
