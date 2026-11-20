//
//  deleteAccountVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class deleteAccountVC: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var mainView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        
        cancelBtn.layer.cornerRadius = 12
        logoutBtn.roundButton()
        
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowRadius = 3.0
        mainView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        mainView.layer.masksToBounds = false
        
       
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        removeAnimation()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        let alertControllar = UIAlertController(title: "", message: "Do you really want to your Delete Account?", preferredStyle: .alert)
        
        let loginbutton = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let user = Auth.auth().currentUser!
            
            user.delete { error in
                if error != nil {
                    // An error happened.
                } else {
                    // Account deleted.
                    print("user deleted")
                    print(Helper.userId,"Helper.userId")
                    //MARK: delete User -
                                
                    Helper.dbRef.collection("Bookings").whereField("uid", isEqualTo : Helper.userId).addSnapshotListener { querySnapshot, err in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                
                                let postTempDic = document.data() as NSDictionary
                                let visitkey = postTempDic["key"] as? String ?? ""
                                Helper.dbRef.collection("Bookings").document(visitkey).delete()
                            }
                        }
                    }
                    //MARK: delete User Notification Data -
                    
                    Helper.dbRef.collection("Notifications").whereField("uid", isEqualTo : Helper.userId).addSnapshotListener { querySnapshot, err in
                        if let err = err {
                        print("Error getting documents: \(err)")
                        } else {
                         
                            for document in querySnapshot!.documents {
                                let postTempDic = document.data() as NSDictionary
                                let Notificationkey = postTempDic["key"] as? String ?? ""
                                Helper.dbRef.collection("Notifications").document(Notificationkey).delete()
                            }
                        }
                    }
                    Helper.dbRef.collection("Help").whereField("userId", isEqualTo : Helper.userId).addSnapshotListener { querySnapshot, err in
                        if let err = err {
                        print("Error getting documents: \(err)")
                        } else {
                         
                            for document in querySnapshot!.documents {
                                let postTempDic = document.data() as NSDictionary
                                let Notificationkey = postTempDic["userId"] as? String ?? ""
                                Helper.dbRef.collection("Help").document(Notificationkey).delete()
                            }
                        }
                    }
                    
                Helper.dbRef.collection("Users").document(Helper.userId).delete()
                }
            }
            UserDefaults.standard.set("", forKey: "id")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set("0", forKey: "status")
            let vc = self.storyboard?.instantiateViewController(identifier: "SigninNavigation")
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
        
        let canclebutton = UIAlertAction(title: "No", style: .cancel) { (action) in
            print ("Operation Has Been Cancelled By User")
        }
        
        alertControllar.addAction(loginbutton)
        alertControllar.addAction(canclebutton)
        self.present (alertControllar,animated: true,completion: nil)
        
    }
    
    

}

