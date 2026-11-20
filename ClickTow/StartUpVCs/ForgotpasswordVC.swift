//
//  ForgotPasswordVC.swift
//  ClickTow
//
//  Created by M Hayat on 07/02/2023.


import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.shadowWithRightPadding()
        sendBtn.roundButton()
       
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if emailTF.text == "" {
            Toast.showToast(message: "Please Enter email", controller: self)
           
        }else{
            Auth.auth().sendPasswordReset(withEmail: emailTF.text!, completion: { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                    self.errorWithTitleMsg(title: "invalid email adress", message: error.localizedDescription)
                    } else {
                        
                    Toast.showToast(message: "reset link sent", controller: self)
                 // self.errorWithTitleMsg(title: "reset link sent", message: "")
                //  self.errorWithMsg(message: "reset link sent")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                        
                        }
                    }
                }
            })
        }
    }
    

}
