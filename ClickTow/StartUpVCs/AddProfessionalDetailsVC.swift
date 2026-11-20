//
//  AddProfessionalDetailsVC.swift
//  ClickTow
//
//  Created by M Hayat on 17/02/2023.
//

import UIKit

class AddProfessionalDetailsVC: UIViewController {
    
    
    @IBOutlet weak var addCNICImageView: UIImageView!
    @IBOutlet weak var AddInsuranceImageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var AllowBtn: UIButton!

    
    var sentImage1:UIImage?
    var imgUrl1 = ""
    var sentImage2:UIImage?
    var imgUrl2 = ""
    var selectImage = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Add professional details"
        
        UserDefaults.standard.set("3", forKey: "status")
        addCNICImageView.layer.cornerRadius = 10
        AddInsuranceImageView.layer.cornerRadius = 10
        nextBtn.roundButton()
        AllowBtn.isSelected = false
        
        
        let TapGesture = UITapGestureRecognizer()
        TapGesture.addTarget(self, action: #selector(addCNICImage))
        addCNICImageView.isUserInteractionEnabled = true
        addCNICImageView.addGestureRecognizer(TapGesture)
        
        let TapGesture1 = UITapGestureRecognizer()
        TapGesture1.addTarget(self, action: #selector(changeProfileImg))
        AddInsuranceImageView.isUserInteractionEnabled = true
        AddInsuranceImageView.addGestureRecognizer(TapGesture1)
        
    }
    
    @objc func addCNICImage(){
        
        self.selectImage = "1"
        self.getImage(fromSourceType: .photoLibrary)
       // self.showAlert()
    }
    @objc func changeProfileImg(){
        self.selectImage = "2"
        self.getImage(fromSourceType: .photoLibrary)
       // self.showAlert()
    }
    
    @IBAction func AllowBtnAction(_ sender: Any) {
        if AllowBtn.isSelected == false {
            AllowBtn.isSelected = true
            nextBtn.isUserInteractionEnabled = true
        } else {
            AllowBtn.isSelected = false
            nextBtn.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        if sentImage1 == nil {
            Toast.showToast(message: "Please select id image", controller: self)
        } else if sentImage2 == nil {
        Toast.showToast(message: "Please select insurance image", controller: self)
            
        } else if AllowBtn.isSelected == false {
            Toast.showToast(message: "Please agree to our terms and conditions", controller: self)
        } else  {
            
        uploadImage1()
            
        }
        
        
    }
    
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
                
                let para = ["cnic_img":imgUrl]
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
                let para = ["insurance_img":imgUrl]
                Helper.dbRef.collection("Users").document(Helper.userId).updateData(para as [AnyHashable : Any])
                self.hideIndicator()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVehicleNavigation")
                vc!.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            }
        }
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress as Any)
        }
    }
    
    
    
}

// MARK: - Image Picker

extension AddProfessionalDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                self.addCNICImageView.image = image
            } else {
                self.sentImage2 = image
                self.AddInsuranceImageView.image = image
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
