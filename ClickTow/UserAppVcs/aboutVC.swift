//
//  aboutVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import MessageUI

class aboutVC: UIViewController,MFMailComposeViewControllerDelegate {

    let composeVC = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "About"
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        composeVC.mailComposeDelegate = self
        
        
    }
    
    @IBAction func Btn1Action(_ sender: Any) {
  
        
        UIApplication.shared.openURL(URL(string:"https://www.fivecomproperties.com/")!)
        
    }
    
    @IBAction func Btn2Action(_ sender: Any) {
        
//        composeVC.setToRecipients(["5conpropertiesllc@gmail.com"])
//        composeVC.setSubject("VidChex Help")
//        self.present(composeVC, animated: true, completion: nil)
        sendEmail()
        
    }
    
    
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
