//
//  helpVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import MessageUI

class helpVC: UIViewController,UITextViewDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    let composeVC = MFMailComposeViewController()
    


    override func viewDidLoad() {
        super.viewDidLoad()

        
        descTextView.layer.cornerRadius = 5
        descTextView.layer.borderWidth = 0.3
        descTextView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.title = "Help"
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        nameTF.isUserInteractionEnabled = false
        contactTF.isUserInteractionEnabled = false
        emailTF.isUserInteractionEnabled = false
                
        let fullName = (Helper.userDic["first_name"] as? String ?? "" ) + " " + (Helper.userDic["last_name"] as? String ?? "" )
        nameTF.text = fullName

        emailTF.text = Helper.userDic["email"] as? String ?? ""
        contactTF.text = Helper.userDic["phone"] as? String ?? ""
        
        
        BackGroundView(backGroundView: mainView)
        sendBtn.layer.cornerRadius = 7
        
        descTextView.delegate = self
        descTextView.text = "Your feedback is important to us."
        descTextView.textColor = UIColor.lightGray
        composeVC.mailComposeDelegate = self
           
       
    }

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {
            textView.text = "Your feedback is important to us."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        
        if nameTF.text == "" {
                errorWithMsg(message: "Enter Name")
            } else if emailTF.text == "" {
                errorWithMsg(message: "Enter Email")
            } else if contactTF.text == "" {
                errorWithMsg(message: "Enter Phone Number")
            } else if descTextView.text == "" || descTextView.text == "Your feedback is important to us." {
                errorWithMsg(message: "Enter Discription")
            } else {
                
                showIndicator(caption: "Please wait...")
            
                let email = emailTF.text ?? ""
                let phone = contactTF.text ?? ""
                let name = nameTF.text ?? ""
                let description = descTextView.text ?? ""
                let userType = Helper.userDic["user_type"] as? String ?? ""
                
                let para = ["description":description,"email":email,"name":name,"phone":phone,"userId":Helper.userId,"userType":userType] as [String : Any]
                    Helper.dbRef.collection("Help").document(Helper.userId).setData(para)
                
                self.hideIndicator()
                
                let vc = self.storyboard?.instantiateViewController(identifier: "UserTabBar")
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
                
                
                
              
    
        }
    }
    
    
    @IBAction func Btn1Action(_ sender: Any) {
  
        UIApplication.shared.openURL(URL(string:"https://www.fivecomproperties.com/")!)
        
    }
    
    @IBAction func Btn2Action(_ sender: Any) {
        
        sendEmail()
//        composeVC.setToRecipients(["5conpropertiesllc@gmail.com"])
//        composeVC.setSubject("VidChex Help")
//        self.present(composeVC, animated: true, completion: nil)
        
    }
    
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//           controller.dismiss(animated: true, completion: nil)
//       }
    func sendEmail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["Unlimitedprojects@hotmail.com"])
            mailComposeViewController.setSubject("Subject")
            mailComposeViewController.setMessageBody("Body", isHTML: false)
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                
                errorWithTitleMsg(message: "Mail services are not available")
                print("Mail services are not available")
            }
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    
}
