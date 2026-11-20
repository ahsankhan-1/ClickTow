//
//  DriverHomeVC.swift
//  ClickTow
//
//  Created by M Hayat on 15/02/2023.
//

import UIKit
import SDWebImage
import FirebaseFirestore
import GoogleMaps
import CoreLocation
import Switches


class DriverHomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var OnlineSwitch: YapSwitch!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var SecoundView: UIView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var arriveBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var RequestCollectionView: UICollectionView!
    
    
    var BookingDic:[NSDictionary] = []
    var id = ""
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    var polyline: GMSPolyline?
    
    var pickupLat = 0.0
    var pickupLong = 0.0
    var dropOffLat = 0.0
    var dropOffLong = 0.0
    var Distance = ""
    var Duration = ""
    var userlat = 0.0
    var userlong = 0.0
    var BtnTitle = ""
    var bookingid = ""
    var fcm = ""
    var fcm1 = ""
    var createrBookingid = ""
    var phoneNumber = ""
    var phoneNumber1 = ""
    var MapView = GMSMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(Helper.userId,"userid")
        
        UserDefaults.standard.set("5", forKey: "status")
        
        BackGroundViewtableCell(backGroundView: FirstView)
        BackGroundViewtableCell(backGroundView: SecoundView)
        
        UserImage.layer.cornerRadius = UserImage.layer.frame.height/2
        arriveBtn.roundButton()
        
        self.RequestCollectionView.delegate = self
        self.RequestCollectionView.dataSource = self
        
        MapView.frame = mapView.bounds
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(MapView)
        
        MapView.settings.compassButton = true
        MapView.settings.myLocationButton = true
        MapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let compassButtonPadding: CGFloat = 12
        MapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: compassButtonPadding)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        self.userlat = location.coordinate.latitude
        self.userlong = location.coordinate.longitude
        print(self.userlat,"userlat")
        print(self.userlong,"userlong")
        MapView.camera = camera
        MapView.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
        
        UserData()
        
        
    }
    
    @IBAction func onlineSwithAction(_ sender: YapSwitch) {
        
        if sender.isOn {
            
            print("Switch is turned on")
            self.OnlineSwitch.onThumbTintColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 1)
            self.OnlineSwitch.onThumbImage = UIImage(named: "online")!.maskWithColor(color: UIColor.Applink!)
            self.OnlineSwitch.onTintColor = UIColor.Applink!
            let para = ["online":"online"]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para)
            
        } else {
            print("Switch is turned off")
            OnlineSwitch.offThumbImage = UIImage(named: "online")!.maskWithColor(color: UIColor.Applink!)
            OnlineSwitch.offThumbTintColor = UIColor.white
            OnlineSwitch.offTintColor = UIColor.white
            let para = ["online":"offline"]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para)
        }
        
    }
    
    @IBAction func ArriveBtnAction(_ sender: Any) {
        
        if self.BtnTitle == "1" {
            
            let para = ["available":"arrive"]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para)
            let paras = ["status":"arrive"]
            Helper.dbRef.collection("Bookings").document(self.bookingid).updateData(paras)
            
            let autoid = self.customAutoId()
            let parametter = ["created":NSDate.now,"descreptin":"Reached your pickup location","driverId":Helper.userId,"key":autoid,"read":"unread","title":"test","uid":self.id] as [String : Any]
            Helper.dbRef.collection("Notifications").document(autoid).setData(parametter)
            
            PushNotificationSender.sendPushNotification(to:self.fcm1, title:"Reached your pickup location",body: "test")
            
        } else {
            
            let para = ["available":"available"]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para)
            let paras = ["status":"reached"]
            Helper.dbRef.collection("Bookings").document(self.bookingid).updateData(paras)
            
            let autoid = self.customAutoId()
            let parametter = ["created":NSDate.now,"descreptin":"Reached your drop location","driverId":Helper.userId,"key":autoid,"read":"unread","title":"test","uid":self.id] as [String : Any]
            Helper.dbRef.collection("Notifications").document(autoid).setData(parametter)
            
            PushNotificationSender.sendPushNotification(to:self.fcm1, title:"Reached your drop location", body: "test")
            
        }
    }
    
    @IBAction func CallBtnAction(_ sender: Any) {
        
        print(self.phoneNumber,"phoneNumber")
        
        let  Number = self.phoneNumber.replacingOccurrences(of: " ", with: "")

        if let phoneCallURL = URL(string: "tel://\(Number)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func ChatBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatingVc") as! ChatingVc
        vc.recevireid = self.id
        vc.name = nameLbl.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func CancelBtnAction(_ sender: Any) {
        
        let para = ["available":"available"]
        Helper.dbRef.collection("Users").document(Helper.userId).updateData(para)
        
        let paras = ["status":"rejected"]
        Helper.dbRef.collection("Bookings").document(self.bookingid).updateData(paras)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  BookingDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = RequestCollectionView.dequeueReusableCell(withReuseIdentifier: "RequestCollectionViewCell", for: indexPath) as! RequestCollectionViewCell
        
        cell.nameLbl.text = BookingDic[indexPath.row]["first_name"] as? String ?? ""
        let imgUrl = BookingDic[indexPath.row]["dp"] as? String ?? ""
        cell.UserImageView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "profile"))
        
//        let Userlatlong = BookingDic[indexPath.row]["lat_lon"] as! GeoPoint
//        let userlat = Userlatlong.latitude
//        let userlong = Userlatlong.longitude
        let pickuplatlong = BookingDic[indexPath.row]["pic_latlon"] as! GeoPoint
        let pickuplat = pickuplatlong.latitude
        let pickuplong = pickuplatlong.longitude
        
        let originCoordinate = CLLocationCoordinate2D(latitude: self.userlat, longitude: self.userlong)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: pickuplat, longitude: pickuplong)
        
        getDrivingDistanceAndDuration(origin: originCoordinate, destination: destinationCoordinate) { (distance, duration) in
            if let distance = distance, let duration = duration {
                print("Distance: \(distance), Duration: \(duration)")
                
                DispatchQueue.main.async {
                    cell.distanceLbl.text = distance
                    cell.timeLbl.text = duration
                }
            } else {
                print("Unable to get distance and duration")
            }
        }
        
        cell.AcceptedTaped = {
            
            let bookingkey = self.BookingDic[indexPath.row]["key"] as? String ?? ""
            let uid = self.BookingDic[indexPath.row]["uid"] as? String ?? ""
            let fcm = self.BookingDic[indexPath.row]["fcm"] as? String ?? ""
            
            self.FirstView.isHidden = false
            self.SecoundView.isHidden = true
            
            let para = ["available":"busy"]
            Helper.dbRef.collection("Users").document(Helper.userId).updateData(para)
            
            let paras = ["status":"active","driver_id":Helper.userId]
            Helper.dbRef.collection("Bookings").document(bookingkey).updateData(paras)
            
            let autoid = self.customAutoId()
            let parametter = ["created":NSDate.now,"descreptin":"Accept your request and on the way","driverId":Helper.userId,"key":autoid,"read":"unread","title":"test","uid":uid] as [String : Any]
            Helper.dbRef.collection("Notifications").document(autoid).setData(parametter)
            
            PushNotificationSender.sendPushNotification(to:fcm, title:"Accept your request and on the way", body: "test")
            
        }
        
        cell.UserImageView.layer.cornerRadius = cell.UserImageView.layer.frame.height/2
        cell.acceptBtn.roundButton()
        
        return cell
    }
    
    //MARK: customAutoId -
    func customAutoId() -> String{
        let milliseconds = Int64(Date().timeIntervalSince1970 * 1000)
        let randomDigits = String(format: "%04d", arc4random_uniform(10000))
        return "\(milliseconds)_\(randomDigits)"
    }
    
    
    //MARK: User Data -
    func UserData() {
        
        showIndicator(caption: "Please wait...")
        Helper.dbRef.collection("Users").document(Helper.userId).addSnapshotListener { snapshot, error in
            guard let snap = snapshot?.data(), error == nil else {
                print(error?.localizedDescription as Any)
                print("No Data Found in Dictionary")
                self.hideIndicator()
                return
            }
            let dic = snap as NSDictionary
            Helper.userDic = dic
            
            let available = dic["available"] as? String ?? ""
            let online = dic["online"] as? String ?? ""
            if online == "online" {
                print(online)
                self.OnlineSwitch.isOn = true
                self.OnlineSwitch.onThumbTintColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 1)
                self.OnlineSwitch.onThumbImage = UIImage(named: "online")!.maskWithColor(color: UIColor.Applink!)
                self.OnlineSwitch.onTintColor = UIColor.Applink!
            } else {
                self.OnlineSwitch.isOn = false
                self.OnlineSwitch.offThumbImage = UIImage(named: "online")!.maskWithColor(color: UIColor.Applink!)
                self.OnlineSwitch.offThumbTintColor = UIColor.white
                self.OnlineSwitch.offTintColor = UIColor.white
            }
            let catid = dic["cat_key"] as? String ?? ""
            print(catid,"catid")
            if available == "available" || available == "busy" || available == "arrive"  && online == "online" {
                
                print(available,"available")
                
            Helper.dbRef.collection("Bookings").whereField("cat_ky", isEqualTo : catid).addSnapshotListener { []querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        self.hideIndicator()
                    } else {
                        
                        for document in querySnapshot!.documents {
                            let dict = document.data() as NSDictionary
                            let status = dict["status"] as? String ?? ""
                            let uid = dict["uid"] as? String ?? ""
                            let piclatlon = dict["pic_latlon"] as? GeoPoint
                            print(uid,"uid")
                            print(status,"status")
                            let key = dict["key"] as? String ?? ""
                            if status == "pending" {
                                print(status,"status")
                                self.BookingDic.removeAll()
                                Helper.dbRef.collection("Users").document(uid).getDocument { snapshot, error in
                                    guard let snap = snapshot?.data(), error == nil else {
                                        print(error?.localizedDescription as Any)
                                        print("No Data Found in Dictionary")
                                        self.hideIndicator()
                                        return
                                    }
                                    var dic = snap as [String: Any]
                                    dic["key"] = key
                                    dic["pic_latlon"] = piclatlon
                                    self.BookingDic.append(dic as NSDictionary)
                                    print(self.BookingDic.count,"count")
                                    
                                    self.FirstView.isHidden = true
                                    self.SecoundView.isHidden = false
                                    self.hideIndicator()
                                    self.RequestCollectionView.reloadData()
                                    
                                }
                                self.hideIndicator()
                                self.RequestCollectionView.reloadData()
                                
                        
                            } else if status == "active" || status == "arrive"  {
                                
                                if status == "active" {
                                    self.BtnTitle = "1"
                                    self.arriveBtn.setTitle("Arrived", for: .normal)
                                } else if status == "arrive" {
                                    self.BtnTitle = "2"
                                    self.arriveBtn.setTitle("Reached", for: .normal)
                                }
                                
                                self.bookingid = dict["key"] as? String ?? ""
                                
                                
                                
                                self.id = uid
                                Helper.dbRef.collection("Users").document(uid).getDocument { snapshot, error in
                                    guard let snap = snapshot?.data(), error == nil else {
                                        print(error?.localizedDescription as Any)
                                        print("No Data Found in Dictionary")
                                        self.hideIndicator()
                                        return
                                    }
                                    
                                    let dic = snap as [String: Any]
                                    self.fcm1 = dic["fcm"] as? String ?? ""
                                    self.phoneNumber = dic["phone"] as? String ?? ""
                                    self.nameLbl.text = dic["first_name"] as? String ?? ""
                                    let imgUrl = dic["dp"] as? String ?? ""
                                    self.UserImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "profile"))
                                    
                                    //  let Userlatlong = dic["lat_lon"] as! GeoPoint
                                    //  let userlat = Userlatlong.latitude
                                    //  let userlong = Userlatlong.longitude
                                    let pickuplatlong = dict["pic_latlon"] as! GeoPoint
                                    let pickuplat = pickuplatlong.latitude
                                    let pickuplong = pickuplatlong.longitude
                                    
                                    let originCoordinate = CLLocationCoordinate2D(latitude: self.userlat, longitude: self.userlong)
                                    let destinationCoordinate = CLLocationCoordinate2D(latitude: pickuplat, longitude: pickuplong)
                                    getDrivingDistanceAndDuration(origin: originCoordinate, destination: destinationCoordinate) { (distance, duration) in
                                        if let distance = distance, let duration = duration {
                                            print("Distance: \(distance), Duration: \(duration)")
                                            
                                            DispatchQueue.main.async {
                                                self.distanceLbl.text = distance
                                                self.timeLbl.text = duration
                                            }
                                        } else {
                                            print("Unable to get distance and duration")
                                        }
                                    }
                                    
                                    getBestRoute(origin: originCoordinate, destination: destinationCoordinate) { [self] (locations, polyline) in
                                        if locations.count > 0 {
                                            polyline?.map = self.MapView
                                            print("Locations: \(locations)")
                                        } else {
                                            print("Unable to get route")
                                        }
                                    }
                                    
                                    let marker = GMSMarker(position: originCoordinate)
                                    if let image = UIImage(named: "truck") {
                                        let size = CGSize(width: 32, height: 32)
                                        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                                        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
                                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                        UIGraphicsEndImageContext()
                                        marker.icon = resizedImage
                                    }
                                    marker.map = self.MapView
                                    
                                    let marker1 = GMSMarker(position: destinationCoordinate)
                                    if let image = UIImage(named: "destination location") {
                                        let size = CGSize(width: 25, height: 25)
                                        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                                        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
                                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                        UIGraphicsEndImageContext()
                                        marker1.icon = resizedImage
                                    }
                                    marker1.map = self.MapView
                                    
                                    self.FirstView.isHidden = false
                                    self.SecoundView.isHidden = true
                                    self.hideIndicator()
                                    
                                }
                                
                            } else if status == "reached" || status == "rejected" {
                                
                                self.MapView.clear()
                                let originCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                                let destinationCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                                getBestRoute(origin: originCoordinate, destination: destinationCoordinate) { [self] (locations, polyline) in
                                    if locations.count > 0 {
                                        polyline?.map = self.MapView
                                        self.polyline = polyline
                                    } else {
                                    }
                                }
                                
                                self.polyline?.map = nil
                                self.polyline = nil
                                
                                self.hideIndicator()
                                self.FirstView.isHidden = true
                                self.SecoundView.isHidden = true
                                
                            }
                        }
                    }
                }
            } else {
                
                self.userlat = 0
                self.userlong = 0
                self.hideIndicator()
                self.FirstView.isHidden = true
                self.SecoundView.isHidden = true
                
            }
            
        }
        
        self.hideIndicator()
        self.FirstView.isHidden = true
        self.SecoundView.isHidden = true
        
    }
}

