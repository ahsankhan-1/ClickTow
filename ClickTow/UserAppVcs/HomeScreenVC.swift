//
//  HomeScreenVC.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import FirebaseFirestore


class HomeScreenVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var BackView: UIView!
    
    let locationManager = CLLocationManager()
    var MapView = GMSMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        UserData()
        getBookingsdata()
        
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        UserDefaults.standard.set("2", forKey: "status")
        
        
        BackGroundView(backGroundView: BackView)
        BackGroundView(backGroundView: locationView)
        locationTF.isUserInteractionEnabled = false
        
        locationTF.layer.borderWidth = 1
        locationTF.layer.borderColor = UIColor.black.cgColor
        locationTF.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(pickuplocation))
        locationView.isUserInteractionEnabled = true
        locationView.addGestureRecognizer(tapGesture)
        
        MapView.frame = mapView.bounds
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(MapView)
        
        MapView.settings.compassButton = true
        MapView.settings.myLocationButton = true
        MapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @objc func pickuplocation(){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookRideVC") as! BookRideVC
        vc.side = "1"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: User Data -
    func UserData() {
        showIndicator(caption: "Please wait...")
        Helper.dbRef.collection("Users").document(Helper.userId).getDocument { snapshot, error in
            guard let snap = snapshot?.data(), error == nil else {
                print(error?.localizedDescription as Any)
                print("No Data Found in Dictionary")
                self.hideIndicator()
                return
            }
            let dic = snap as NSDictionary
            Helper.userDic = dic
            //  print(Helper.userDic,"userDic")
            self.hideIndicator()
            
        }
    }
    
    //MARK: Get Current Location -
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        MapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
    
    func getBookingsdata() {
        
        Helper.dbRef.collection("Bookings").whereField("uid",isEqualTo : Helper.userId).getDocuments { []querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hideIndicator()
            } else {
                for document in querySnapshot!.documents {
                    let dict = document.data() as NSDictionary
                    let status = dict["status"] as? String ?? ""
                    print(status,"status")
                    let catkey = dict["cat_ky"] as? String ?? ""
                    print(catkey,"catkey")
                    if status == "pending" {
                        print(status,"statussssssssssss")
                        let vc = self.storyboard?.instantiateViewController(identifier: "ConfirmToVC") as! ConfirmToVC
                        vc.categoryTypeid = catkey
                        vc.count = 2
                        print(vc.categoryTypeid,"categoryTypeid")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else if status == "active" {
                        let vc = self.storyboard?.instantiateViewController(identifier:"ConfirmToVC") as! ConfirmToVC
                        vc.categoryTypeid = catkey
                        vc.count = 2
                        print(vc.categoryTypeid,"categoryTypeid")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else if status == "arrive" {
                        
                        let vc = self.storyboard?.instantiateViewController(identifier:"ConfirmToVC") as! ConfirmToVC
                        vc.categoryTypeid = catkey
                        vc.count = 2
                        print(vc.categoryTypeid,"categoryTypeid")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else if status == "reached" {
                        
                        let vc = self.storyboard?.instantiateViewController(identifier: "CompletionRequestVC") as! CompletionRequestVC
                        vc.categoryid = catkey
                     // vc.count = 2
                        print(vc.categoryid,"categoryTypeid")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        
                        print("No data found")
                        self.hideIndicator()
                        
                    }
                }
            }
        }
    }
    
}
