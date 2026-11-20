//
//  MyDocsDetailsVC.swift
//  ClickTow
//
//  Created by M Hayat on 16/02/2023.
//

import UIKit
import SDWebImage


class MyDocsDetailsVC: UIViewController {
    
    @IBOutlet weak var idCardImageView: UIImageView!
    
    @IBOutlet weak var InsuranceImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Docs Details"
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
        idCardImageView.layer.cornerRadius = 7
        InsuranceImageView.layer.cornerRadius = 7
        
        
        idCardImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        InsuranceImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        let imgUrl1 = Helper.userDic["cnic_img"] as? String ?? ""
        idCardImageView.sd_setImage(with: URL(string: imgUrl1))
        
        let imgUrl2 = Helper.userDic["insurance_img"] as? String ?? ""
        InsuranceImageView.sd_setImage(with: URL(string: imgUrl2))
        
        
        
       
    }
    
    


}
