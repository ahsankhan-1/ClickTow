//
//  CreateprofileVc.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit
import iOSDropDown
import PMSuperButton
import FirebaseFirestore
import FlagPhoneNumber

class CreateprofileVc: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var genderTF: DropDown!
    @IBOutlet weak var dateofBirthTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var AddLocationBtn: UIButton!
    @IBOutlet weak var phoneTF: FPNTextField!
    @IBOutlet weak var validLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var sentImage:UIImage?
    var imgUrl = ""
    
    var gender = ["Gender","Male","Female"]
    var phyAddPoints: GeoPoint?
    
    static var googleEmail = ""
    static var googleName = ""
    static var last = ""
    
    var countryList = FPNCountryListViewController(style: .insetGrouped)
    var countrycode = ""
    var count = 0
    var isValid = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        UserDefaults.standard.set("1", forKey: "status")
        print(Helper.userId,"Helper.userId")
        
        validLbl.isHidden = true
        phoneTF.delegate = self
        phoneTF.setFlag(key: .US)
        phoneTF.delegate = self
        countryList.setup(repository: phoneTF.countryRepository)
        countryList.didSelect = { [weak self] country in
            self?.phoneTF.setFlag(countryCode: country.code)
            
        }
        
        phoneTF.backgroundColor = .white
        phoneTF.font = .systemFont(ofSize: 14)
        phoneTF.textColor = .black
        phoneTF.layer.cornerRadius = phoneTF.layer.frame.height/2
        phoneTF.layer.borderWidth = 0.0
        phoneTF.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        phoneTF.layer.shadowOpacity = 0.3
        phoneTF.layer.shadowRadius = 2.5
        phoneTF.layer.shadowOffset = CGSize(width: 0, height: 1)
        phoneTF.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        dateofBirthTF.shadowWithPaddingBothSide()
        countryTF.shadowWithPaddingBothSide()
        cityTF.shadowWithPaddingBothSide()
        addressTF.shadowWithPaddingBothSide()
        saveBtn.roundButton()
        mainView.layer.cornerRadius = mainView.layer.frame.height/2
        mainView.layer
            .borderWidth = 1
        mainView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileimageView.layer.cornerRadius = profileimageView.layer
            .frame.height/2
        
        countryTF.isUserInteractionEnabled = false
        cityTF.isUserInteractionEnabled = false
        
        genderTF.backgroundColor = .white
        genderTF.font = .systemFont(ofSize: 14)
        genderTF.textColor = .black
        genderTF.layer.cornerRadius = genderTF.layer.frame.height/2
        genderTF.layer.borderWidth = 0.0
        genderTF.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        genderTF.layer.shadowOpacity = 0.3
        genderTF.layer.shadowRadius = 2.5
        genderTF.layer.shadowOffset = CGSize(width: 0, height: 1)
        genderTF.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 16))
        genderTF.leftView = leftpaddingView
        genderTF.leftViewMode = .always
        genderTF.rightViewMode = .always
        
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.addTarget(self, action: #selector(dateChange(datepicker:)), for: UIControl.Event.valueChanged)
        datepicker.frame.size = CGSize(width: 0, height: 300)
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.maximumDate = Date()
        dateofBirthTF.inputView = datepicker
        
        let locationGesture = UITapGestureRecognizer()
        locationGesture.addTarget(self, action: #selector(goSearchLocationVC))
        addLocationView.isUserInteractionEnabled = true
        addLocationView.addGestureRecognizer(locationGesture)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(changeProfileImg))
        imagePicker.isUserInteractionEnabled = true
        imagePicker.addGestureRecognizer(tapGesture)
        
        self.genderTF.optionArray = self.gender
        self.genderTF.didSelect{(selectedText , index ,id) in
            self.genderTF.text = selectedText
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addressTF.text = Helper.userAdd
        cityTF.text = Helper.userCity
        countryTF.text = Helper.userCountry
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 20
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.phoneTF:
            self.addressTF.becomeFirstResponder()
        case self.addressTF:
            self.countryTF.becomeFirstResponder()
        case self.countryTF:
            self.cityTF.becomeFirstResponder()
        default:
            self.cityTF.resignFirstResponder()
        }
    }
    
    @objc func dateChange(datepicker: UIDatePicker) {
        dateofBirthTF.text = FormatDate(date: datepicker.date)
    }
    func FormatDate(date: Date) ->  String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    @objc func goSearchLocationVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddUserLocationVC") as! AddUserLocationVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeProfileImg(){
        self.getImage(fromSourceType: .photoLibrary)
    }
    
    @IBAction func createAction(_ sender: Any) {
        
        let phone = countrycode + "" + (self.phoneTF.text ?? "")
        print(phone,"phone")
        
        let gender = genderTF.text
        let dateofbirth = dateofBirthTF.text
        let location = addressTF.text
        let city = cityTF.text
        let country = countryTF.text
        
        if phoneTF.text == "" {
            errorWithMsg(message: "Please Enter Contact Number")
        } else if genderTF.text == "" {
            errorWithMsg(message: "Please Select Gender")
        } else if dateofBirthTF.text == "" {
            errorWithMsg(message: "Please Enter Date Of Birth")
        } else if addressTF.text == "" {
            errorWithMsg(message: "Please Enter Location")
        } else if dateofBirthTF.text == "" {
            errorWithMsg(message: "Please Enter Date Of Birth")
        } else if sentImage == nil{
            errorWithMsg(message: "Select image")
        } else {
            
            let latitude = Helper.userLat
            let longitude = Helper.userLong
            self.phyAddPoints = GeoPoint(latitude: latitude, longitude:  longitude)
            
            let para = ["phone":phone,"address":location!,"city":city!,"country":country!,"dob":dateofbirth!,"gender":gender!,"lat_lon":self.phyAddPoints!] as [String : Any]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
            
            uploadImage()
            
        }
    }
    
    func uploadImage (){
        
        self.showIndicator(caption: "Uploading...")
        let data = self.sentImage!.jpegData(compressionQuality: 20.0)
        let chatRef = Helper.storRef.child("VenueImages/\(Date().millisecondsSince1970)")
        let uploadTask = chatRef.putData(data!, metadata: nil) { mataData, error in
            guard mataData != nil else {
                print(error!)
                self.hideIndicator()
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
                Helper.dbRef.collection("Users").document(Helper.userId).getDocument { snapshot, error in
                    guard let snap = snapshot?.data(), error == nil else {
                        print(error?.localizedDescription as Any)
                        print("No Data Found in Dictionary")
                        self.hideIndicator()
                        return
                    }
                    let dic = snap as NSDictionary
                    let userType = dic["user_type"] as? String ?? ""
                    if userType == "user" {
                        let vc = self.storyboard?.instantiateViewController(identifier:"UserTabBar")
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProDetailsNavi")
                        vc!.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
                    }
                    self.hideIndicator()
                }
            }
        }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
        }
    }
}

// MARK: - Image Picker

extension CreateprofileVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showAlert() {
        let alert = UIAlertController(title: "Image Selection", message: "From where pick image", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { (action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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
            self.sentImage = image
            self.profileimageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateprofileVc: FPNTextFieldDelegate {
    
    /// The place to present/push the listController if you choosen displayMode = .list
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: countryList)
        
        present(navigationViewController, animated: true, completion: nil)
    }
    
    /// Lets you know when a country is selected
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
        
        self.countrycode = dialCode
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            
            print("00000")
            self.isValid = false
            self.validLbl.text = "Valid"
            self.validLbl.textColor = .green
            //   self.count = self.phoneTF.text?.count ?? 0
            // Do something...
            textField.getFormattedPhoneNumber(format: .E164)
            // Output "+33600000001"
            textField.getFormattedPhoneNumber(format: .International)
            // Output "+33 6 00 00 00 01"
            textField.getFormattedPhoneNumber(format: .National)
            // Output "06 00 00 00 01"
            textField.getFormattedPhoneNumber(format: .RFC3966)
            // Output "tel:+33-6-00-00-00-01"
            textField.getRawPhoneNumber()
            // Output "600000001"
        } else {
            
            if self.isValid == false {
                self.validLbl.isHidden = false
                self.validLbl.text = "inValid"
                self.validLbl.textColor = .red
            } else {
                self.validLbl.isHidden = true
            }
            // Do something...
        }
    }
}



