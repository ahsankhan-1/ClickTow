//
//  AccountRequestVC.swift
//  ClickTow
//
//  Created by M Hayat on 17/02/2023.
//

import UIKit

class AccountRequestVC: UIViewController {
    
    
    @IBOutlet weak var requestPendingBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set("5", forKey: "status")
        requestPendingBtn.roundButton()
        
    }
    
    @IBAction func requestPendingBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier:"DriverTabBar")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    
}
