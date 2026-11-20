//
//  editprofileVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import iOSDropDown
import FirebaseFirestore
import SDWebImage


class editprofileVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var FirstNameTF: UITextField!
    @IBOutlet weak var LastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
  
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var genderTF: DropDown!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    
    var sentImage:UIImage?
    var imgUrl = ""
    var gender = ""
    var value = ""
    var userLat = ""
    var userlong = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Edit Profile"
    //   hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = false
        
        FirstNameTF.TextFieldDesign()
        LastNameTF.TextFieldDesign()
        emailTF.TextFieldDesign()
        genderTF.TextFieldDesign()
        dateOfBirthTF.TextFieldDesign()
        cityTF.TextFieldDesign()
        stateTF.TextFieldDesign()
        addressTF.TextFieldDesign()
        
        emailTF.isUserInteractionEnabled = false
        genderTF.isUserInteractionEnabled = false
        cityTF.isUserInteractionEnabled = false
        stateTF.isUserInteractionEnabled = false
        addressTF.isUserInteractionEnabled = false
        
        FirstNameTF.delegate = self
        LastNameTF.delegate = self
       
        imagePickerView.layer.cornerRadius = imagePickerView.layer.frame.height/2
        imagePickerView.layer.borderWidth = 1
        imagePickerView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        userImageView.layer.cornerRadius = userImageView.layer.frame.height/2
        updateBtn.roundButton()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imgUrl = Helper.userDic["dp"] as? String ?? ""
        userImageView.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "profile"))
        FirstNameTF.text = Helper.userDic["first_name"] as? String ?? ""
        LastNameTF.text = Helper.userDic["last_name"] as? String ?? ""

        emailTF.text = Helper.userDic["email"] as? String ?? ""
        gender = Helper.userDic["gender"] as? String ?? ""
        genderTF.text = gender
        dateOfBirthTF.text = Helper.userDic["dob"] as? String ?? ""
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(changeProfileImg))
        imagePickerView.isUserInteractionEnabled = true
        imagePickerView.addGestureRecognizer(tapGesture)
        
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.addTarget(self, action: #selector(dateChange(datepicker:)), for: UIControl.Event.valueChanged)
        datepicker.frame.size = CGSize(width: 0, height: 300)
        datepicker.preferredDatePickerStyle = .wheels
        dateOfBirthTF.inputView = datepicker

    }
    
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        
        if Helper.userAdd != "" {
        
            addressTF.text = Helper.userAdd
            cityTF.text = Helper.userCity
            stateTF.text = Helper.userCountry
        } else {
            cityTF.text = Helper.userDic["city"] as? String ?? ""
            stateTF.text = Helper.userDic["country"] as? String ?? ""
            addressTF.text = Helper.userDic["address"] as? String ?? ""
            let geoPoint = Helper.userDic["lat_lon"] as! GeoPoint
            Helper.userLat = geoPoint.latitude
            Helper.userLong = geoPoint.longitude
         
        }
    }
    
    @objc func changeProfileImg(){

            self.showAlert()
        
    }
    @objc func dateChange(datepicker: UIDatePicker) {
        dateOfBirthTF.text = FormatDate(date: datepicker.date)
    }
    func FormatDate(date: Date) ->  String {
                let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.FirstNameTF:
            self.LastNameTF.becomeFirstResponder()
        default:
            self.LastNameTF.resignFirstResponder()
        }
    }
    
    
    
    @IBAction func locatioBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddUserLocationVC") as! AddUserLocationVC
        navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func uploadBtnAction(_ sender: Any) {
        
        let fname = FirstNameTF.text
        let lastname = LastNameTF.text
        let dateofbirth = dateOfBirthTF.text
        let city = cityTF.text
        let country = stateTF.text
        let address = addressTF.text

            var phyAddPoints: GeoPoint?
            let latitude = Helper.userLat
            let longitude = Helper.userLong
            phyAddPoints = GeoPoint(latitude: latitude, longitude:  longitude)

        let para = ["city":city!,"lat_lon":phyAddPoints!,"country":country!,"address":address!,"dob":dateofbirth!,"gender":gender,"first_name":fname!,"last_name":lastname!] as [String : Any]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])

            if self.value == "1" {
        uploadImage()
            } else {
                self.hideIndicator()
                self.navigationController?.popViewController(animated: true)

            }
    }
    
    func uploadImage (){
       
        self.showIndicator(caption: "Uploading..")
            let data = self.sentImage!.jpegData(compressionQuality: 20.0)
            let chatRef = Helper.storRef.child("VenueImages/\(Date().millisecondsSince1970)")
            let uploadTask = chatRef.putData(data!, metadata: nil) { mataData, error in
                guard mataData != nil else {
                    print(error!)
                    return
                }
                let size = mataData?.size
                print(size as Any)
                chatRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print(error as Any)
                        return
                    }
                    let imgUrl = String( downloadURL.absoluteString)
                    print(imgUrl,"imgUrl")
                    
                    let para = ["dp":imgUrl]
                    
                    Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
                    
                    self.hideIndicator()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
            }
        }
    
}

// MARK: - Image Picker

extension editprofileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showAlert() {
        let alert = UIAlertController(title: "image selection", message: "from where pick image", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo album", style: .default, handler: { (action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerViewDelegate.

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self.value = "1"
            self.sentImage = image
            self.userImageView.image = image
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
