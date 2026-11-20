//
//  CancelRequestVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/03/2023.
//

import UIKit
import SDWebImage

class CancelRequestVC: UIViewController {
    
    @IBOutlet weak var FifthView: UIView!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var pickupLocationLbl: UILabel!
    @IBOutlet weak var editPickipBtn: UIButton!
    @IBOutlet weak var NoBtn: UIButton!
    @IBOutlet weak var yesCancelBtn: UIButton!
    
        var img = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        FifthView.layer.cornerRadius = 20
        FifthView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        driverImage.layer.cornerRadius = driverImage.layer.frame.height/2
        yesCancelBtn.roundButton()
        NoBtn.roundButton()
        NoBtn.layer.borderWidth = 1
        NoBtn.layer.borderColor = UIColor.black.cgColor
        
        driverImage.sd_setImage(with: URL(string: ConfirmToVC.imageUrl), placeholderImage: UIImage(named: "profile"))
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
       dismiss(animated: true)
        
    }
    
    @IBAction func yesCancelBtnAction(_ sender: Any) {
        
        let para = ["available":"available"]
        Helper.dbRef.collection("Users").document(ConfirmToVC.driverid).updateData(para)
        
        let paras = ["status":"rejected"]
        Helper.dbRef.collection("Bookings").document(ConfirmToVC.bookingid).updateData(paras)
        
        let vc = self.storyboard?.instantiateViewController(identifier:"UserTabBar")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    

   

}
