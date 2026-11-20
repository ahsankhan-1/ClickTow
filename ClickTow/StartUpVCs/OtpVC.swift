//
//  OtpVC.swift
//  ClickTow
//
//  Created by M Hayat on 07/02/2023.
//

import UIKit
import AEOTPTextField
import FirebaseAuth
import FirebaseFirestore
import Alamofire

class OtpVC: UIViewController {

    @IBOutlet weak var otpTF: AEOTPTextField!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var DoneBtn: UIButton!
    
    var otpCode = ""
    var secondsRemaining = 59
    var otptestcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DoneBtn.roundButton()
        
        hideKeyboardWhenTappedAround()
       
     // self.navigationController?.isNavigationBarHidden = true
        otpTF.keyboardType = .numberPad
        resendBtn.setTitle("60s", for: .normal)
        otpTF.otpDelegate = self
        otpTF.configure(with: 4)
        otpTF.otpFontSize = 16
        otpTF.otpTextColor = .white
        otpTF.otpCornerRaduis = 5
        otpTF.otpFilledBorderColor = .clear
    //  otpTF.otpFilledBackgroundColor = #colorLiteral(red: 0.03529411765, green: 0.6196078431, blue: 0.5019607843, alpha: 1)
        otpTF.becomeFirstResponder()
       
        SendCode()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendBtnAction(_ sender: Any) {
        SendCode()
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        // let code = UserDefaults.standard.string(forKey: "code")
        //        print(code ?? "","code0000")
                if otpTF.text != self.otptestcode {
                    Toast.showToast(message: "Invalid OTP", controller: self)
                } else {
                    showIndicator(caption: "Please wait...")
                Auth.auth().createUser(withEmail:SignupVC.email,password:SignupVC.password) { [self] authResult, error in
                        guard authResult != nil, error == nil else {
                            self.hideIndicator()
                            errorWithMsg(message: (error?.localizedDescription)!)
                            return
                        }
                        Helper.userId = Auth.auth().currentUser!.uid
                        UserDefaults.standard.set(Helper.userId, forKey: "id")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                    
                    let phyAddPoints: GeoPoint?
                    let latitude1 = 0.0
                    let longitude1 = 0.0
                    phyAddPoints = GeoPoint(latitude: latitude1, longitude:  longitude1)
                       
                    let para = ["account_type":"email","address":"","aproved_status":"","available":"available","cat_key":"","city":"","cnic_img":"","counter":0,"country":"","created":NSDate.now,"current_lat":phyAddPoints!,"dob":"","dp":"","email":SignupVC.email,"fcm":"","first_name":SignupVC.firstname,"gender":"","insurance_img":"","last_name":SignupVC.lastname,"lat_lon":"","license_exp_date":"","license_img":"","license_num":"","online":"","password":SignupVC.password,"phone":"","plate_num":"","plate_num_img":"","rating":0,"reg_img":"","status":"active","uid":Helper.userId,"updated":NSDate.now,"user_type":Helper.UserType,"veh_license_exp_date":"","vehicle_img":"","vehicle_type":""] as [String : Any]
                        
                        Helper.dbRef.collection("Users").document(Helper.userId).setData(para)
                    
                    Helper.dbRef.collection("Users").document( Helper.userId).updateData(["fcm":AppDelegate.token])
                        self.hideIndicator()
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileNavigation")
                        vc!.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
            
                    
                    }
                }
            }
    
    func SendCode() {
                
        self.otptestcode = "\(generateRandomDigits(4))"
        let dict = ["to":SignupVC.email,"subject":"Email Verification!","message":"Your verification code for sign up VidChex is \(self.otptestcode)"]
        self.otpTimer()
        AF.request("https://Apis.appistaan.com/mailapi/index.php?key=sk286292djd926d", method: .post, parameters: dict).responseString { (response) in
            switch response.result{
            case .success(_):
                self.hideIndicator()
                print(self.otptestcode,"testCode")
         //       Toast.showToast(message: "test code = \(self.otptestcode)", controller: self)
                
                self.errorWithTitleMsg(title: "Verification Code Sent Successfully!", message: "")
            case .failure(_):
                print("fail")
                self.hideIndicator()
                self.errorWithTitleMsg(title: "Verification Code Sending Failed!", message: "")
            }
        }
    }
    
    func otpTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            if self.secondsRemaining > 0 {
                self.resendBtn.setTitle("\(self.secondsRemaining)s", for: .normal)
                self.resendBtn.isUserInteractionEnabled = false
                self.secondsRemaining -= 1
            } else {
                Timer.invalidate()
                self.resendBtn.isUserInteractionEnabled = true
                self.resendBtn.setTitle("Resend", for: .normal)
                self.secondsRemaining = 59
            }
        }
    }
}

extension OtpVC: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        otpCode = code
     //   print(otpCode)
        if otpCode != "" {
            DoneBtn.isUserInteractionEnabled = true
        }
    }
}
