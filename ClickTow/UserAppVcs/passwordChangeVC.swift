//
//  passwordChangeVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import FirebaseAuth


class passwordChangeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var NewPasswordTF: UITextField!
    @IBOutlet weak var ConfirmPasswordTF: UITextField!
    @IBOutlet weak var ChangePasswordBtn: UIButton!
    
    
    var  oldpassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Password"

        oldPasswordTF.shadowWithPaddingBothSide()
        NewPasswordTF.shadowWithPaddingBothSide()
        ConfirmPasswordTF.shadowWithPaddingBothSide()
        ChangePasswordBtn.roundButton()
        
        NewPasswordTF.delegate = self
        oldPasswordTF.delegate = self
        ConfirmPasswordTF.delegate = self
        ConfirmPasswordTF.returnKeyType = .done
        
        oldpassword = Helper.userDic["password"] as? String ?? ""
       
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oldPasswordTF:
            NewPasswordTF.becomeFirstResponder()
        case NewPasswordTF:
            ConfirmPasswordTF.becomeFirstResponder()
        case ConfirmPasswordTF:
            ConfirmPasswordTF.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        
        let oldPassword = oldPasswordTF.text!
        let newPassword = NewPasswordTF.text!
        let confirmPassword = ConfirmPasswordTF.text!
        
        if oldPasswordTF.text == "" {
            errorWithMsg(message: "Please enter old password")
        } else if NewPasswordTF.text == "" {
            errorWithMsg(message: "Please enter new password")
        } else if ConfirmPasswordTF.text == "" {
            errorWithMsg(message: "Please enter confirm password")
        } else if newPassword != confirmPassword {
            errorWithMsg(message: "password not match")
        } else if oldPassword != oldpassword {
            errorWithMsg(message: "old password is wrong")
        } else {
            
            showIndicator(caption: "Please wait...")
        
        let email = Helper.userDic["email"] as? String ?? ""
        
        self.changePassword(email: email, currentPassword: oldPassword, newPassword: newPassword) { (error) in
                if error != nil {
                    self.errorWithTitleMsg(title: "error", message: error!.localizedDescription)
                } else {
                    let para = ["password":self.ConfirmPasswordTF.text]
                    
                    Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
                    
                    self.hideIndicator()
                    
                    let type = Helper.userDic["user_type"] as? String ?? ""
                    if type == "user" {
                        let vc = self.storyboard?.instantiateViewController(identifier: "UserTabBar")
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(identifier: "DriverTabBar")
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if let error = error {
                    completion(error)
                }
                else {
                    Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                        completion(error)
                    })
                }
            })
        }
    
//    func isPasswordHasNumberAndCharacterSign(password: String) -> Bool {
//        let passWordRegEx = "[a-zA-Z0-9!@#$%^&*]+"
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passWordRegEx)
//        return passwordTest.evaluate(with: password)
//
//    }
    
    

}
