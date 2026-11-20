//
//  NotificationVc.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit
import FirebaseFirestore

class NotificationVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var NotificationTableView: UITableView!
    
    
    var AllNotificationDic:[NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Notification"
        
        
        
        NotificationTableView.delegate = self
        NotificationTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserNotificationData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllNotificationDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationTableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        cell.nameLbl.text = self.AllNotificationDic[indexPath.row]["title"] as? String ?? ""
        cell.titleLbl.text = self.AllNotificationDic[indexPath.row]["descreptin"] as? String ?? ""
        if self.AllNotificationDic[indexPath.row]["read"] as? String ?? ""  == "read" {
            cell.OpenImageView.image = UIImage(named: "open message")
        } else {
            cell.OpenImageView.image = UIImage(named: "email")
        }
        
        BackGroundViewtableCell(backGroundView: cell.backGroundView)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = self.AllNotificationDic[indexPath.row]["key"] as? String ?? ""
        print(key,"key")
        Helper.dbRef.collection("Notifications").document(key).updateData(["read": "read"]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                return
            }
            if var updatedDic = self.AllNotificationDic[indexPath.row] as? [String: Any] {
                updatedDic["read"] = "read"
                self.AllNotificationDic[indexPath.row] = updatedDic as NSDictionary
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    
    func getUserNotificationData() {
        showIndicator(caption: "Please wait...")
        Helper.dbRef.collection("Notifications").whereField("uid", isEqualTo: Helper.userId).addSnapshotListener { []querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hideIndicator()
            } else {
                self.AllNotificationDic.removeAll()
                for document in querySnapshot!.documents {
                    let dict = document.data() as NSDictionary
                    
                    self.AllNotificationDic.append(dict)
                    removeNoData()
                    self.NotificationTableView.reloadData()
                    
                }
                if self.AllNotificationDic.isEmpty {
                    showNoData(table: self.NotificationTableView, deatilText: "Notification Not Found", animationName: " ")
                }
            }
            self.hideIndicator()
            self.NotificationTableView.reloadData()
        }
    }
    
    
}
    
