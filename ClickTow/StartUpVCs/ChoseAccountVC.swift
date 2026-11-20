//
//  ChoseAccountVC.swift
//  ClickTow
//
//  Created by M Hayat on 07/02/2023.
//

import UIKit

class ChoseAccountVC: UIViewController {
    
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var driverBtn: UIButton!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userBtn.layer.cornerRadius = 7
        userBtn.layer.borderWidth = 1
        userView.layer.cornerRadius = 7
        View1.layer.cornerRadius = View1.layer.frame.height/2
        View1.layer.shadowOpacity = 0.5
        View1.layer.shadowRadius = 2.0
        View1.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        View1.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        View1.layer.masksToBounds = false
        
        driverBtn.layer.cornerRadius = 7
        driverBtn.layer.borderWidth = 1
        driverView.layer.cornerRadius = 7
        View2.layer.cornerRadius = View2.layer.frame.height/2
        View2.layer.shadowOpacity = 0.5
        View2.layer.shadowRadius = 2.0
        View2.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        View2.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        View2.layer.masksToBounds = false
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func userBtnAction(_ sender: Any) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        Helper.UserType = "user"
        UserDefaults.standard.set("user",forKey:"userType")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func driverBtnAction(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        Helper.UserType = "driver"
        UserDefaults.standard.set("driver",forKey:"userType")
        navigationController?.pushViewController(vc, animated: true)
    }
    
   

}
