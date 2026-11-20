//
//  ChatingVc.swift
//  ClickTow
//
//  Created by M Hayat on 10/03/2023.
//

import UIKit
import FirebaseDatabase
import IQKeyboardManagerSwift
import SDWebImage
import FirebaseFirestore

class ChatingVc: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MessageTableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var ChatTextView: UITextView!
    @IBOutlet weak var tvBottomConstraint: NSLayoutConstraint!
    
    
    var CallImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var name = ""
    var recevireid = ""
    var chatkeys = [String]()
    var chattingDic:[NSDictionary] = []
    var phone = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserskeys()
        
        self.title = name
        sendBtn.roundButton()
        print(recevireid,"recevireid")
     
        MessageTableView.delegate = self
        MessageTableView.dataSource = self
        
        ChatTextView.layer.cornerRadius = ChatTextView.layer.frame.height/2
        ChatTextView.layer.borderWidth = 0.7
        ChatTextView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 0.7614513675)
        ChatTextView.delegate = self
        ChatTextView.text = "Write your message here...."
        ChatTextView.textColor = UIColor.lightGray
        ChatTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        MessageTableView.estimatedRowHeight = 50
        MessageTableView.rowHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        CallImage.image = UIImage(named:"call")
        CallImage.layer.cornerRadius = CallImage.frame.height / 2
        
        let barButtonItem = UIBarButtonItem(customView: CallImage)
        navigationItem.rightBarButtonItem = barButtonItem
        CallImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDetail))
        CallImage.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func showDetail() {
        
        if let phoneCallURL = URL(string: "tel://\(self.phone)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tvBottomConstraint.constant = keyboardSize.height + 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tvBottomConstraint.constant = 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "Write your message here...."
            textView.textColor = UIColor.lightGray
            
        }
    }
    
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if ChatTextView.text == "" || ChatTextView.text == "Write your message here...." {
            
            
        } else {
            
            let txt =  ChatTextView.text ?? ""
            let mesgKey = (Helper.dbChatRef.childByAutoId().key)!
            let date1 = Date().millisecondsSince1970
            let chatPara = ["msg":txt,"recieverId":self.recevireid,"seen":false,"senderId":Helper.userId,"time":"\(date1)","type":"text"] as [String : Any]
            Helper.dbChatRef.child("Chats").child(mesgKey).setValue(chatPara)
            
            let chatListpara = ["id":self.recevireid] as [String : Any]
            Helper.dbChatRef.child("chatList").child(Helper.userId).child(self.recevireid).updateChildValues(chatListpara)
            
            let chatList = ["id":Helper.userId] as [String : Any]
            Helper.dbChatRef.child("chatList").child(self.recevireid).child(Helper.userId).updateChildValues(chatList)
            
            ChatTextView.text = ""
            
        }
    }
    
    //MARK: Table View -
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattingDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.sendLbl.layer.cornerRadius = 16
        cell.sendLbl.layer.masksToBounds = true
        cell.sendLbl.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
        
        cell.receiveLbl.layer.cornerRadius = 16
        cell.receiveLbl.layer.masksToBounds = true
        cell.receiveLbl.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.sendLbl.isHidden = true
        cell.receiveLbl.isHidden = true
        cell.seenLbl.isHidden = true
        cell.recevertimeLbl.isHidden = true
        
        if self.chattingDic[indexPath.row]["recieverId"] as? String ?? "" == Helper.userId {
            cell.receiveLbl.text = self.chattingDic[indexPath.row]["msg"] as? String ?? ""
            let time = self.chattingDic[indexPath.row]["time"] as? String ?? ""
            cell.recevertimeLbl.text = timestampToStringAgo(timestamp: Int64(time) ?? 0)
            cell.receiveLbl.isHidden = false
            cell.recevertimeLbl.isHidden = false
            
        }else if self.chattingDic[indexPath.row]["senderId"] as? String ?? "" == Helper.userId {
            cell.sendLbl.text = self.chattingDic[indexPath.row]["msg"] as? String ?? ""
            let time = self.chattingDic[indexPath.row]["time"] as? String ?? ""
            cell.seenLbl.text = timestampToStringAgo(timestamp: Int64(time) ?? 0)
            cell.sendLbl.isHidden = false
            cell.seenLbl.isHidden = false
            
        }
        return cell
    }
    //MARK: tableView willDisplay -
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            tableView.scrollToBottom(animated: true)
        }
    }
    
    //MARK: get Users keys -
    func getUserskeys(){
        
        showIndicator(caption: "Please wait...")
        
        Helper.dbChatRef.child("Chats").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let keys = Array(dictionary.keys)
                self.chatkeys  =  keys.sorted(by: <)
                print(self.chatkeys,"chatkeys")
                let connectedRef = Database.database().reference(withPath: ".info/connected")
                connectedRef.observe(.value, with: { (snapshot) in
                    if snapshot.value as? Bool ?? false {
                        print("retriveMessageData")
                        self.retriveMessageData()
                    } else {
                        print("error loading")
                        return
                    }
                })
            }
        })
        {
            (error) in
            print(error.localizedDescription)
            let alert = UIAlertController(title: "No Network", message: "Please connect to internet and try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        }
    }
    //MARK: retrive MessageData -
    func retriveMessageData(){
        self.chattingDic.removeAll()
        for key in self.chatkeys {
            Helper.dbChatRef.child("Chats").child(key).observe(.value) { snapshot in
                guard snapshot.exists() else {
                    print("Post not found")
                    return
                }
                let snap = snapshot.value as? NSDictionary ?? [:]
                
                if (snap["senderId"] as? String ?? "" == Helper.userId && snap["recieverId"] as? String ?? "" == self.recevireid) || (snap["senderId"] as? String ?? "" == self.recevireid && snap["recieverId"] as? String ?? "" == Helper.userId) {
                    
                    self.chattingDic.append(snap)
                    print(self.chattingDic,"chattingDic")
                    self.hideIndicator()
                    self.reloadData()
                    
                }
                
                self.hideIndicator()
                self.reloadData()
//                if self.chattingDic == [] {
//                    showNoData(table: self.MessageTableView,deatilText: "No Chatting",animationName: " ")
//                    self.hideIndicator()
//                    self.reloadData()
//
//                }
            }
        }
    }


    func reloadData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [self] in
            let contentOffset = MessageTableView.contentOffset
            MessageTableView.reloadData()
            MessageTableView.layoutIfNeeded()
            MessageTableView.setContentOffset(contentOffset, animated: false)
            
            let scrollPoint = CGPoint(x: 0, y: self.MessageTableView.contentSize.height - self.MessageTableView.frame.size.height)
            self.MessageTableView.setContentOffset(scrollPoint, animated: true)
        }
    }
}

//MARK: Auto Message Function -
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}

extension UIViewController{
    func TimestampToStringAgo(timestamp: Int64) -> String{
        let actualTime = Int64(Date().timeIntervalSince1970*1000)
        var lastSeenTime = actualTime - timestamp
        lastSeenTime /= 1000 //seconds
        var lastTimeString = ""
        if lastSeenTime < 60 {
            if lastSeenTime == 10 {
                lastTimeString = "Just now"
            } else {
                lastTimeString = "just now"
            }
        } else {
            lastSeenTime /= 60
            if lastSeenTime < 60 {
                if lastSeenTime == 1 {
                    lastTimeString = "Active" + " " + String(lastSeenTime) + " minute ago"
                } else {
                    lastTimeString = "Active" + " " + String(lastSeenTime) + " minute ago"
                }
            } else {
                lastSeenTime /= 60
                if lastSeenTime < 24 {
                    if lastSeenTime == 1 {
                        lastTimeString = "Active" + " " + String(lastSeenTime) + " hour ago"
                    } else {
                        lastTimeString = "Active" + " " + String(lastSeenTime) + " hours ago"
                    }
                } else {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d"
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    lastTimeString = formatter.string(from: Date(milliseconds: timestamp))
                    print(lastTimeString,"Day")
                    if lastTimeString == "1" {
                        lastTimeString = "Active" + " " + lastTimeString + " " + "day ago"
                    } else {
                        lastTimeString = "Active" + " " + lastTimeString + " " + "days ago"
                    }
                }
            }
        }
        return lastTimeString
    }
}

extension String {
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

