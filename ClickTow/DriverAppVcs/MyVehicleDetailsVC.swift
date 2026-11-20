//
//  MyVehicleDetailsVC.swift
//  ClickTow
//
//  Created by M Hayat on 16/02/2023.
//

import UIKit
import SDWebImage

class MyVehicleDetailsVC: UIViewController {
    
    
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var VehicleTypeLbl: UILabel!
    @IBOutlet weak var LicenseNumberLbl: UILabel!
    @IBOutlet weak var plateNumberLbl: UILabel!
    @IBOutlet weak var driverlicenceExpDateLbl: UILabel!
    @IBOutlet weak var VehiclelicenceexpDateLbl: UILabel!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Vehicle Details"
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
        image2.layer.cornerRadius = 7
        image3.layer.cornerRadius = 7
        image4.layer.cornerRadius = 7
        
        
        VehicleTypeLbl.text = Helper.userDic["vehicle_type"] as? String ?? ""
        LicenseNumberLbl.text = Helper.userDic["license_num"] as? String ?? ""
        plateNumberLbl.text = Helper.userDic["plate_num"] as? String ?? ""
        driverlicenceExpDateLbl.text = Helper.userDic["license_exp_date"] as? String ?? ""
        VehiclelicenceexpDateLbl.text = Helper.userDic["veh_license_exp_date"] as? String ?? ""
        
        Image1.sd_imageIndicator = SDWebImageActivityIndicator.gray
        image2.sd_imageIndicator = SDWebImageActivityIndicator.gray
        image3.sd_imageIndicator = SDWebImageActivityIndicator.gray
        image4.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        
        let imgUrl = Helper.userDic["vehicle_img"] as? String ?? ""
        self.Image1.sd_setImage(with: URL(string: imgUrl))
        
        let imgUrl1 = Helper.userDic["vehicle_img"] as? String ?? ""
        image2.sd_setImage(with: URL(string: imgUrl1))
        
        let imgUrl2 = Helper.userDic["license_img"] as? String ?? ""
        self.image3.sd_setImage(with: URL(string: imgUrl2))
        
        let imgUrl3 = Helper.userDic["reg_img"] as? String ?? ""
        self.image4.sd_setImage(with: URL(string: imgUrl3))
        
    }
    
}
