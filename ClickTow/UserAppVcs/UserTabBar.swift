//
//  UserTabBar.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit

class UserTabBar: UITabBarController {
    
    @IBOutlet weak var Usertabbar: UITabBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Usertabbar.backgroundColor = .white
        Usertabbar.layer.cornerRadius = 12
        Usertabbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        Usertabbar.layer.masksToBounds = false
        Usertabbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        Usertabbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        Usertabbar.layer.shadowOpacity = 0.3
        Usertabbar.layer.shadowRadius = 5
        
       
    }
    

   

}
