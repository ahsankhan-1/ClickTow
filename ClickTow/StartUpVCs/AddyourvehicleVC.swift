//
//  AddyourvehicleVC.swift
//  ClickTow
//
//  Created by M Hayat on 17/02/2023.
//

import UIKit
import iOSDropDown

class AddyourvehicleVC: UIViewController {
    
    
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var SelectVehicleTypeTF: DropDown!
    
    @IBOutlet weak var licenceNumberTF: UITextField!
    @IBOutlet weak var plateNumberTF: UITextField!
    @IBOutlet weak var DriverlicenceexpirydateTF: UITextField!
    @IBOutlet weak var VehiclelicenceexpirydateTF: UITextField!
    
    @IBOutlet weak var Image2: UIImageView!
    @IBOutlet weak var Image3: UIImageView!
    @IBOutlet weak var Image4: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var SelectVehicleTypeArray = [String]()
    var catidsArray = [String]()
    var selectedCatids = ""
    
    var sentImage1:UIImage?
    var sentImage2:UIImage?
    var sentImage3:UIImage?
    var sentImage4:UIImage?
    var selectImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Now Add your vehicle"
        
        getAllCategories()
        hideKeyboardWhenTappedAround()
        
        UserDefaults.standard.set("4", forKey: "status")
        Image1.layer.cornerRadius = 7
        Image2.layer.cornerRadius = 7
        Image3.layer.cornerRadius = 7
        Image4.layer.cornerRadius = 7
        
        SelectVehicleTypeTF.shadowWithRightPadding()
        licenceNumberTF.shadowWithPaddingBothSide()
        plateNumberTF.shadowWithPaddingBothSide()
        DriverlicenceexpirydateTF.shadowWithPaddingBothSide()
        VehiclelicenceexpirydateTF.shadowWithPaddingBothSide()
        nextBtn.roundButton()
        
        pickImageView.layer.cornerRadius = pickImageView.layer.frame.height/2
    
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.addTarget(self, action: #selector(dateChange(datepicker:)), for: UIControl.Event.valueChanged)
        datepicker.frame.size = CGSize(width: 0, height: 300)
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.minimumDate = Date()
        DriverlicenceexpirydateTF.inputView = datepicker
        
        let datepicker1 = UIDatePicker()
        datepicker1.datePickerMode = .date
        datepicker1.addTarget(self, action: #selector(Datechange(datepicker:)), for: UIControl.Event.valueChanged)
        datepicker1.frame.size = CGSize(width: 0, height: 300)
        datepicker1.preferredDatePickerStyle = .wheels
        datepicker1.minimumDate = Date()
        VehiclelicenceexpirydateTF.inputView = datepicker1
        
        let TapGesture = UITapGestureRecognizer()
        TapGesture.addTarget(self, action: #selector(pickImage1))
        pickImageView.isUserInteractionEnabled = true
        pickImageView.addGestureRecognizer(TapGesture)
        
        let TapGesture1 = UITapGestureRecognizer()
        TapGesture1.addTarget(self, action: #selector(pickImage2))
        Image2.isUserInteractionEnabled = true
        Image2.addGestureRecognizer(TapGesture1)
        
        let TapGesture2 = UITapGestureRecognizer()
        TapGesture2.addTarget(self, action: #selector(pickImage3))
        Image3.isUserInteractionEnabled = true
        Image3.addGestureRecognizer(TapGesture2)
        
        let TapGesture3 = UITapGestureRecognizer()
        TapGesture3.addTarget(self, action: #selector(pickImage4))
        Image4.isUserInteractionEnabled = true
        Image4.addGestureRecognizer(TapGesture3)
        
    }
    
    @objc func dateChange(datepicker: UIDatePicker) {
        DriverlicenceexpirydateTF.text = FormatDate(date: datepicker.date)
    }

    func FormatDate(date: Date) ->  String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM / yyyy"
        return formatter.string(from: date)
    }
    
    @objc func Datechange(datepicker: UIDatePicker) {
        VehiclelicenceexpirydateTF.text = formatDate(date: datepicker.date)
    }

    func formatDate(date: Date) ->  String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM / yyyy"
        return formatter.string(from: date)
    }
    
    @objc func pickImage1(){
        
        self.selectImage = "1"
        self.getImage(fromSourceType: .photoLibrary)
       // self.showAlert()
    }
    @objc func pickImage2(){
        self.selectImage = "2"
        self.getImage(fromSourceType: .photoLibrary)
       // self.showAlert()
    }
    @objc func pickImage3(){
        self.selectImage = "3"
        self.getImage(fromSourceType: .photoLibrary)
       // self.showAlert()
    }
    @objc func pickImage4(){
        self.selectImage = "4"
        self.getImage(fromSourceType: .photoLibrary)
       // self.showAlert()
    }
    
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        let vehicleType = SelectVehicleTypeTF.text
        let licenceNumber = licenceNumberTF.text
        let plateNumber = plateNumberTF.text
        let DriverlicenceExpDate = DriverlicenceexpirydateTF.text
        let Vehiclelicenceexpirydate = VehiclelicenceexpirydateTF.text
        
        if sentImage1 == nil {
            errorWithMsg(message: "Please add vehicle image")
        } else if vehicleType == "" {
            errorWithMsg(message: "Please add vehicle type")
        } else if licenceNumber == "" {
            errorWithMsg(message: "Please add driving licence number")
        } else if plateNumber == "" {
            errorWithMsg(message: "Please add vehicle plate number")
        }else if DriverlicenceExpDate == "" {
            errorWithMsg(message: "Please add driving licence expire date")
        }else if Vehiclelicenceexpirydate == "" {
            errorWithMsg(message: "Please add vehicle licence expire date")
        }else if sentImage2 == nil {
            errorWithMsg(message: "Please add vehicle image with plate number")
        }else if sentImage3 == nil {
            errorWithMsg(message: "Please add driving licence image")
        }else if sentImage4 == nil {
            errorWithMsg(message: "Please add vehicle registration image")
        } else {
            
            let para = ["vehicle_type":vehicleType,"cat_key":self.selectedCatids,"license_num":licenceNumber,"plate_num":plateNumber,"license_exp_date":DriverlicenceExpDate,"veh_license_exp_date":Vehiclelicenceexpirydate]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
            
            uploadImage1()
            
        }
    }
    
// MARK: Uploading Images Functions  -
    func uploadImage1(){
        
        self.showIndicator(caption: "Uploading...")
        let data = self.sentImage1!.jpegData(compressionQuality: 20.0)
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
                
                let para = ["vehicle_img":imgUrl]
                Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
                self.uploadImage2()
                
            }
        }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
        }
    }
    
    func uploadImage2(){
        
    //    self.showIndicator(caption: "Uploading...")
        let data = self.sentImage2!.jpegData(compressionQuality: 20.0)
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
                
                let para = ["plate_num_img":imgUrl]
                Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
            
                self.uploadImage3()
            }
        }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
        }
    }
    
    func uploadImage3(){
        
        self.showIndicator(caption: "Uploading...")
        let data = self.sentImage3!.jpegData(compressionQuality: 20.0)
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
                
                let para = ["license_img":imgUrl]
                Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
                
                self.uploadImage4()
                
            }
        }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
        }
    }
    
    func uploadImage4(){
        
    //    self.showIndicator(caption: "Uploading...")
        let data = self.sentImage4!.jpegData(compressionQuality: 20.0)
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
                
                let para = ["reg_img":imgUrl]
                Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
                self.hideIndicator()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountRequestVC") as? AccountRequestVC
                vc!.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
                
            }
        }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
        }
    }
    
    //MARK: Get Categories -
    
    func getAllCategories() {
        
        showIndicator(caption: "Please wait...")
        self.SelectVehicleTypeArray.removeAll()
        Helper.dbRef.collection("Categories").getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshots \(error!)")
                return
            }
            for document in snapshot.documents {
                
                let postTempDic = document.data() as NSDictionary
                let title = postTempDic["title"] as? String ?? ""
                let catids = postTempDic["key"] as? String ?? ""

                self.SelectVehicleTypeArray.append(title)
                self.catidsArray.append(catids)
                self.hideIndicator()
                print(self.SelectVehicleTypeArray,"SelectVehicleTypeArray")

                self.SelectVehicleTypeTF.optionArray = self.SelectVehicleTypeArray
                self.SelectVehicleTypeTF.didSelect{(selectedText , index ,id) in
                    self.SelectVehicleTypeTF.text = selectedText
                    self.selectedCatids = self.catidsArray[index]
                    print(selectedText,"selectedText")
                    print(self.selectedCatids,"catids")
                }
            }
        }
        self.hideIndicator()
    }
}

// MARK: - Image Picker

extension AddyourvehicleVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            if self.selectImage == "1" {
                self.sentImage1 = image
                self.Image1.image = image
            }else if self.selectImage == "2" {
                self.sentImage2 = image
                self.Image2.image = image
            }else if self.selectImage == "3" {
                self.sentImage3 = image
                self.Image3.image = image
            } else {
                self.sentImage4 = image
                self.Image4.image = image
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
