//
//  SideMenuLogoutVC.swift
//  ClickTow
//
//  Created by M Hayat on 17/02/2023.
//

import UIKit

class SideMenuLogoutVC: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        cancelBtn.layer.cornerRadius = 12
        logoutBtn.roundButton()
        
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowRadius = 3.0
        mainView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        mainView.layer.masksToBounds = false
        
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
    
        dismiss(animated: true)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
      
//        dismiss(animated: true)
      
        UserDefaults.standard.set("", forKey: "id")
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set("0", forKey: "status")
        let vc = self.storyboard?.instantiateViewController(identifier: "SigninNavigation")
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }

   
}
