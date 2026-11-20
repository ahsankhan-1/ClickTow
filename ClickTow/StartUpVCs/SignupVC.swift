//
//  SignupVC.swift
//  ClickTow
//
//  Created by M Hayat on 07/02/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignupVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    
    static var firstname = ""
    static var lastname = ""
    static var email = ""
    static var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
        self.navigationController?.isNavigationBarHidden = true
        
        firstNameTF.shadowWithPaddingBothSide()
        lastNameTF.shadowWithPaddingBothSide()
        emailTF.shadowWithPaddingBothSide()
        passwordTF.shadowWithPaddingBothSide()
        
        
        passwordTF.returnKeyType = .done
        signupBtn.roundButton()
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        
        UserDefaults.standard.set("0", forKey: "status")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTF:
            lastNameTF.becomeFirstResponder()
        case lastNameTF:
            emailTF.becomeFirstResponder()
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            passwordTF.resignFirstResponder()
        default:
            break
        }
        
        return true
    }

    

    @IBAction func eyeBtnAction(_ sender: Any) {
        if eyeBtn.isSelected == true {
            eyeBtn.isSelected = false
            passwordTF.isSecureTextEntry = true
        } else {
            eyeBtn.isSelected = true
            passwordTF.isSecureTextEntry = false
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        SignupVC.firstname = self.firstNameTF.text ?? ""
        SignupVC.lastname = self.lastNameTF.text ?? ""
        SignupVC.email = self.emailTF.text ?? ""
        SignupVC.password = self.passwordTF.text ?? ""
        
        
        
        if SignupVC.firstname == "" {
            Toast.showToast(message: "Please give first name", controller: self)
        } else if SignupVC.lastname == ""{
            Toast.showToast(message: "Please give last name", controller: self)
        } else if validate(YourEMailAddress: SignupVC.email) != true {
            Toast.showToast(message: "Invalid email", controller: self)
        } else if SignupVC.password == "" {
            Toast.showToast(message: "Please give password", controller: self)
        } else {
            
            showIndicator(caption: "Please wait...")
            Auth.auth().fetchSignInMethods(forEmail: SignupVC.email) { signInMethods, error in
                if let error = error {
                    self.hideIndicator()
                    print("Error checking email: \(error.localizedDescription)")
                    // Handle the error, e.g. show an error message to the user
                    return
                }
                
                if signInMethods == nil || signInMethods!.isEmpty {
                    self.hideIndicator()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.hideIndicator()
                    Toast.showToast(message: "This email is already in use", controller: self)
                }
            }


        }
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
    
    @IBAction func loginAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
    
}
