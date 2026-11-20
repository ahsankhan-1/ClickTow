//
//  SigninVC.swift
//  ClickTow
//
//  Created by M Hayat on 07/02/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Firebase
import AuthenticationServices
import Alamofire
import CryptoKit
import GoogleSignIn
import IQKeyboardManagerSwift


class SigninVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    
    
    var currentNonce :String?
    var nonce = ""
    var appleFname = ""
    var appleLname = ""
    var appleEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        hideKeyboardWhenTappedAround()
        
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        UserDefaults.standard.set("0", forKey: "status")
        
        emailTF.shadowWithPaddingBothSide()
        passwordTF.shadowWithPaddingBothSide()
        
        appleBtn.roundButton()
        loginBtn.roundButton()
        googleBtn.roundButton()
        facebookBtn.roundButton()
        
        passwordTF.returnKeyType = .done
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            passwordTF.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    @IBAction func showpasswordAction(_ sender: Any) {
        if eyeBtn.isSelected == true {
            eyeBtn.isSelected = false
            passwordTF.isSecureTextEntry = true
        } else {
            eyeBtn.isSelected = true
            passwordTF.isSecureTextEntry = false
        }
    }
    
    @IBAction func forgotAction(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ForgotpasswordVC") as! ForgotPasswordVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ChoseAccountVC") as! ChoseAccountVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if emailTF.text == "" {
            Toast.showToast(message: "Please give email", controller: self)
        } else if passwordTF.text == "" {
            Toast.showToast(message: "Please give password", controller: self)
        } else {
            
            showIndicator(caption: "Please wait..")
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { authResult, error in
                if let authResult = authResult {
                    
                    Helper.userId = authResult.user.uid
                    UserDefaults.standard.set(Helper.userId, forKey: "id")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    
                    Helper.dbRef.collection("Users").document(Helper.userId).addSnapshotListener { querySnapshot, error in
                        let dict = querySnapshot?.data()
                        let userType = dict?["user_type"] as? String ?? ""
                        UserDefaults.standard.set(userType, forKey: "userType")
                        print(userType,"user")
                        Helper.dbRef.collection("Users").document( Helper.userId).updateData(["fcm":AppDelegate.token])
                        
                        if userType == "user" {
                            print(userType,"userType")
                            UserDefaults.standard.set("user",forKey:"userType")
                            self.hideIndicator()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTabBar")
                            vc!.modalPresentationStyle = .fullScreen
                            self.present(vc!, animated: true, completion: nil)
                            
                        } else {
                            
                            self.hideIndicator()
                            UserDefaults.standard.set("driver",forKey:"userType")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverTabBar")
                            vc!.modalPresentationStyle = .fullScreen
                            self.present(vc!, animated: true, completion: nil)
                        }
                    }
                    
                } else {
                    
                    self.hideIndicator()
                    self.errorWithMsg(message: error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Apple login -
    
    @IBAction func appleloginBtnAction(_ sender: Any) {
        
        Helper.SigninWith = "apple"
        
        startSignInWithAppleFlow()
        
        
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @IBAction func facebookloginBtnAction(_ sender: Any) {
        
        
        
    }
    
    //MARK: Google login -
    
    @IBAction func googleloginBtnAction(_ sender: Any) {
        
        Helper.SigninWith = "google"
        // Set up sign-in configuration
        guard (FirebaseApp.app()?.options.clientID) != nil else {
            print("FirebaseApp is not configured.")
            return
        }
        // Start the sign in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { GidUser, error in
            if error == nil {
                
                let email = GidUser!.user.profile!.email
                let firstName = (GidUser!.user.profile!.givenName)!
                let lastName = (GidUser!.user.profile!.familyName)!
                //   let idtoken = GidUser!.user.idToken
                //   let accesstoken = GidUser!.user.accessToken
                //   let imgUrl = GidUser!.user.profile!.imageURL(withDimension: 320)
                
                let credential = GoogleAuthProvider.credential(withIDToken: GidUser!.user.idToken!.tokenString, accessToken: GidUser!.user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                    if (error != nil){
                        return
                    }else{
                        
                        let id = authResult!.user.uid
                        Helper.userId = id
                        print(Helper.userId,"Helper.userId")
                        self.showIndicator(caption:"Please wait...")
                        
                        Helper.dbRef.collection("Users").whereField("email", isEqualTo : email).getDocuments { [self] querySnapshot, err in
                            if  querySnapshot!.documents == [] {
                                self.hideIndicator()
                                
                                AccountasVC.googlefirstName = firstName
                                AccountasVC.googlelastName = lastName
                                AccountasVC.googleemail = email
                                
                                print("User first name: \(AccountasVC.googlefirstName)")
                                print("User last name: \(AccountasVC.googlelastName)")
                                print("User email: \(AccountasVC.googleemail)")
                                
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountasVC") as? AccountasVC  {
                                    if #available(iOS 15.0, *) {
                                        if let sheet = vc.sheetPresentationController {
                                            //  sheet.detents = [.medium() ]
                                            if #available(iOS 16.0, *) {
                                                sheet.detents = [
                                                    .custom { _ in
                                                        return 570
                                                    }
                                                ]
                                                vc.sheetPresentationController?.preferredCornerRadius = 30
                                            } else {
                                                sheet.detents = [.large() ]                }
                                            vc.sheetPresentationController?.preferredCornerRadius = 30
                                        }
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    //  vc.delegate = self
                                    self.present(vc , animated: true)
                                }
                            } else {
                                for document in querySnapshot!.documents {
                                    let dict = document.data()
                                    Helper.userId = (dict["uid"] as? String ?? "")
                                    
                                    Helper.dbRef.collection("Users").document( Helper.userId).updateData(["fcm":AppDelegate.token])
                                    
                                    let auth = dict["account_type"] as? String ?? ""
                                    if auth == "google" {
                                        
                                        UserDefaults.standard.set(Helper.userId, forKey: "id")
                                        print(Helper.userId,"userId")
                                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                        let userType = dict["user_type"] as? String ?? ""
                                        if userType == "user" {
                                            UserDefaults.standard.set("user",forKey:"userType")
                                            self.hideIndicator()
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTabBar")
                                            vc!.modalPresentationStyle = .fullScreen
                                            self.present(vc!, animated: true, completion: nil)
                                        } else {
                                            UserDefaults.standard.set("driver",forKey:"userType")
                                            self.hideIndicator()
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverTabBar")
                                            vc!.modalPresentationStyle = .fullScreen
                                            self.present(vc!, animated: true, completion: nil)
                                            
                                        }
                                    } else {
                                        self.hideIndicator()
                                        Toast.showToast(message: "This email is already in use", controller: self)
                                    }
                                }
                            }
                        }
                    }
                })
            }else{
                print(error!.localizedDescription,"getting error")
            }
        }
    }
}

//MARK: Apple login extension -

extension SigninVC:ASAuthorizationControllerPresentationContextProviding {
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
    }
    
extension SigninVC:ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple Faild: \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                print(currentNonce as Any )
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            print(appleIDCredential, "idcred")
            print(idTokenString, "hh-idtoken")
            self.appleFname = appleIDCredential.fullName?.givenName ?? ""
            self.appleLname = appleIDCredential.fullName?.familyName ?? ""
            self.appleEmail = appleIDCredential.email ?? ""
            AccountasVC.appleemail = appleIDCredential.email ?? ""
            AccountasVC.applefirstName = appleIDCredential.fullName?.givenName ?? ""
            AccountasVC.applelastName = appleIDCredential.fullName?.familyName ?? ""
            
            print("User first name: \(AccountasVC.applefirstName)")
            print("User last name: \(AccountasVC.applelastName)")
            print("User email: \(AccountasVC.appleemail)")
            
            UserDefaults.standard.synchronize()
            //  print(appleIDCredential.fullName, "applefname")
            print(self.appleLname, "appleL")
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
            // Sign in with Firebase
            //   ShowIndicator()
            print("aff","Login as apple")
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    self.hideIndicator()
                    print(error!.localizedDescription)
                    self.errorWithMsg(message: "Error")
                    return
                }else{
                    print("aff","elseSignUp")
                    Helper.userId = (authResult?.user.uid)!
                    let currentUser = (authResult?.user)!
                    print("user sign sucessfully ","user d id \(Helper.userId)  ",currentUser)
                    
                    Helper.dbRef.collection("Users").whereField("email", isEqualTo : self.appleEmail).getDocuments { [self] querySnapshot, err in
                        if  querySnapshot!.documents == [] {
                            self.hideIndicator()
                            
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountasVC") as? AccountasVC  {
                                if #available(iOS 15.0, *) {
                                    if let sheet = vc.sheetPresentationController {
                                        //  sheet.detents = [.medium() ]
                                        if #available(iOS 16.0, *) {
                                            sheet.detents = [
                                                .custom { _ in
                                                    return 570
                                                }
                                            ]
                                            vc.sheetPresentationController?.preferredCornerRadius = 30
                                        } else {
                                            sheet.detents = [.large() ]                }
                                        vc.sheetPresentationController?.preferredCornerRadius = 30
                                    }
                                } else {
                                    // Fallback on earlier versions
                                }
                                //  vc.delegate = self
                                self.present(vc , animated: true)
                            }
                        } else {
                            for document in querySnapshot!.documents {
                                let dict = document.data()
                                Helper.userId = (dict["uid"] as? String ?? "")
                                Helper.dbRef.collection("Users").document( Helper.userId).updateData(["fcm":AppDelegate.token])
                                let auth = dict["account_type"] as? String ?? ""
                                if auth == "apple" {
                                    
                                    UserDefaults.standard.set(Helper.userId, forKey: "id")
                                    print(Helper.userId,"userId")
                                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                    let userType = dict["user_type"] as? String ?? ""
                                    
                                    if userType == "user" {
                                        
                                        UserDefaults.standard.set("user",forKey:"userType")
                                        self.hideIndicator()
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTabBar")
                                        vc!.modalPresentationStyle = .fullScreen
                                        self.present(vc!, animated: true, completion: nil)
                                        
                                    } else {
                                        UserDefaults.standard.set("driver",forKey:"userType")
                                        self.hideIndicator()
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverTabBar")
                                        vc!.modalPresentationStyle = .fullScreen
                                        self.present(vc!, animated: true, completion: nil)
                                        
                                    }
                                    
                                } else {
                                    self.hideIndicator()
                                    Toast.showToast(message: "This email is already in use", controller: self)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
}
