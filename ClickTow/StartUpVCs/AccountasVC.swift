//
//  AccountasVC.swift
//  ClickTow
//
//  Created by M Hayat on 30/03/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class AccountasVC: UIViewController {
    
    
    @IBOutlet weak var BackGroundView: UIView!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var driverBtn: UIButton!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    
    static var googleemail = ""
    static var googlefirstName = ""
    static var googlelastName = ""
    
    static var appleemail = ""
    static var applefirstName = ""
    static var applelastName = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        BackGroundView.layer.cornerRadius = 16
        BackGroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
    
    
    @IBAction func userBtnActiion(_ sender: Any) {
        
        Helper.UserType = "user"
        UserDefaults.standard.set("user",forKey:"userType")
        if Helper.SigninWith == "google" {
    SignUpWithGoogle(email: AccountasVC.googleemail, firstName: AccountasVC.googlefirstName, lastName: AccountasVC.googlelastName)
            
        } else {
            
        SignUpWithApple(email: AccountasVC.appleemail, firstName: AccountasVC.applefirstName, lastName: AccountasVC.applelastName)
            
        }
    }
    
    @IBAction func driverBtnAction(_ sender: Any) {
        
        Helper.UserType = "driver"
        UserDefaults.standard.set("driver",forKey:"userType")
        if Helper.SigninWith == "google" {
       SignUpWithGoogle(email: AccountasVC.googleemail, firstName: AccountasVC.googlefirstName, lastName: AccountasVC.googlelastName)
            
        } else {
            
        SignUpWithApple(email: AccountasVC.appleemail, firstName: AccountasVC.applefirstName, lastName: AccountasVC.applelastName)
            
        }
    }
    
    //MARK: SignUp With Apple -
    func SignUpWithApple(email:String,firstName:String,lastName:String) {
        
        Helper.userId = Auth.auth().currentUser!.uid
        print(Helper.userId,"Helper.userId")
        UserDefaults.standard.set(Helper.userId, forKey: "id")
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()

        let phyAddPoints: GeoPoint?
        let latitude1 = 0.0
        let longitude1 = 0.0
        phyAddPoints = GeoPoint(latitude: latitude1, longitude:  longitude1)
           
        let para = ["account_type":"apple","address":"","aproved_status":"","available":"available","cat_key":"","city":"","cnic_img":"","counter":0,"country":"","created":NSDate.now,"current_lat":phyAddPoints!,"dob":"","dp":"","email":email,"fcm":"","first_name":firstName,"gender":"","insurance_img":"","last_name":lastName,"lat_lon":"","license_exp_date":"","license_img":"","license_num":"","online":"","password":"","phone":"","plate_num":"","plate_num_img":"","rating":0,"reg_img":"","status":"active","uid":Helper.userId,"updated":NSDate.now,"user_type":Helper.UserType,"veh_license_exp_date":"","vehicle_img":"","vehicle_type":""] as [String : Any]
            
            Helper.dbRef.collection("Users").document(Helper.userId).setData(para)
   //     Helper.dbRef.collection("userProfile").document(Helper.userId).updateData(["token":AppDelegate.token])
        
        
        self.hideIndicator()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileNavigation")
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)

    }
    
    
    
    //MARK: SignUp With Google -
    
    func SignUpWithGoogle(email:String,firstName:String,lastName:String) {
        
        Helper.userId = Auth.auth().currentUser!.uid
        print(Helper.userId,"Helper.userId")
        UserDefaults.standard.set(Helper.userId, forKey: "id")
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        let phyAddPoints: GeoPoint?
        let latitude1 = 0.0
        let longitude1 = 0.0
        phyAddPoints = GeoPoint(latitude: latitude1, longitude:  longitude1)
        
        let para = ["account_type":"google","address":"","aproved_status":"","available":"available","cat_key":"","city":"","cnic_img":"","counter":0,"country":"","created":NSDate.now,"current_lat":phyAddPoints!,"dob":"","dp":"","email":email,"fcm":"","first_name":firstName,"gender":"","insurance_img":"","last_name":lastName,"lat_lon":"","license_exp_date":"","license_img":"","license_num":"","online":"","password":"","phone":"","plate_num":"","plate_num_img":"","rating":0,"reg_img":"","status":"active","uid":Helper.userId,"updated":NSDate.now,"user_type":Helper.UserType,"veh_license_exp_date":"","vehicle_img":"","vehicle_type":""] as [String : Any]
        
        Helper.dbRef.collection("Users").document(Helper.userId).setData(para)
        
        //  Helper.dbRef.collection("userProfile").document( Helper.userId).updateData(["token":AppDelegate.token])
        
        self.hideIndicator()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileNavigation")
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
     }
 }
