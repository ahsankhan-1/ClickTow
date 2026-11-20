//
//  ConfirmToVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import GoogleMaps
import SDWebImage
import FirebaseFirestore
import CoreLocation

class ConfirmToVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var Lbl1: UILabel!
    @IBOutlet weak var Lbl2: UILabel!
    @IBOutlet weak var Lbl3: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var AddPaymentTF: UITextField!
    @IBOutlet weak var AddPaymentBtn: UIButton!
    @IBOutlet weak var confirmTowBtn: UIButton!
    
    @IBOutlet weak var SecoundView: UIView!
    @IBOutlet weak var confirm2Btn: UIButton!
    
    @IBOutlet weak var ThirdView: UIView!
    @IBOutlet var multipleViews: [UIView]!
    @IBOutlet weak var dropoffTimeLbl: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    
    
    @IBOutlet weak var FourthView: UIView!
    @IBOutlet weak var onthewayLbl: UILabel!
    @IBOutlet weak var minBackView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var plateNumberLbl: UILabel!
    @IBOutlet weak var MessageBtn: UIButton!
    @IBOutlet weak var drivNameLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var location1Lbl: UILabel!
    @IBOutlet weak var addorChangeBtn: UIButton!
    @IBOutlet weak var cardPriceLbl: UILabel!
    @IBOutlet weak var switch1Btn: UIButton!
    @IBOutlet weak var tripstatusLbl: UILabel!
    @IBOutlet weak var switch2Btn: UIButton!
    
    @IBOutlet weak var SixthView: UIView!
    @IBOutlet weak var lastLocationLbl: UILabel!
    @IBOutlet weak var timeLblBackView: UIView!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var LocatioLbl: UILabel!
    @IBOutlet weak var AddOrChangeBtn: UIButton!
    @IBOutlet weak var lastpriceLbl: UILabel!
    @IBOutlet weak var lastCreditcardLbl: UILabel!
    @IBOutlet weak var switch3Btn: UIButton!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var switch4Btn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    
    
    var categoryTypeid = ""
    let locationManager = CLLocationManager()
    var phyAddPoints: GeoPoint?
    var phyAddPoints1: GeoPoint?
    var totalearning = ""
    var count = 0
    var userlat = 0.0
    var userlong = 0.0
    static var imageUrl = ""
    static var driverid = ""
    static var bookingid = ""
    
    var AllData:NSDictionary = [:]
    var driverid = ""
    var currentTime = Date()
    var duration = 0
    var phoneNumber = ""
    var autoId = ""
    var MapView = GMSMapView()
    var reachedStatusHandled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .plain, target: nil, action: nil)
        
        //   getBookingsdata()
        
        ImageView.layer.cornerRadius = 5
        confirmTowBtn.roundButton()
        AddPaymentTF.isUserInteractionEnabled = false
        
        confirm2Btn.roundButton()
        
        for view in multipleViews {
            view.layer.cornerRadius = view.layer.frame.height/2
            view.clipsToBounds = true
        }
        
        minBackView.layer.cornerRadius = 5
        userImage.layer.cornerRadius = userImage.layer.frame.height/2
        MessageBtn.roundButton()
        callBtn.roundButton()
        
        timeLblBackView.layer.cornerRadius = 5
        ratingView.layer.cornerRadius = ratingView.layer.frame.height/2
        
        MapView.frame = mapView.bounds
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(MapView)
        
        MapView.settings.compassButton = true
        MapView.settings.myLocationButton = true
        MapView.isMyLocationEnabled = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if Helper.Paymentfrom == "" {
            
        }else {
            AddPaymentTF.text = Helper.Paymentfrom
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
        self.userlat = location.coordinate.latitude
        self.userlong = location.coordinate.longitude
        print(self.userlat,"userlat")
        print(self.userlong,"userlong")
        MapView.camera = camera
        MapView.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
        
        
        if categoryTypeid != "" {
            print(categoryTypeid,"22222")
            getBookingsdata()
            categoryData()
            
        }else {
            print(categoryTypeid,"33333333")
        }
        
    }
    
    @IBAction func AddPaymentAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentOptionsVC") as! PaymentOptionsVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func confirmTowBtnAction(_ sender: Any) {
        
        if Helper.Paymentfrom == "" {
            Toast.showToast(message: "Please add payment method", controller: self)
        }else {
            FirstView.isHidden = true
            SecoundView.isHidden = false
        }
        
    }
    
    @IBAction func crossAction(_ sender: Any) {
        
//        let para = ["available":"available"]
//        Helper.dbRef.collection("Users").document(ConfirmToVC.driverid).updateData(para)
        
     //   let paras = ["status":"rejected"]
        
        if let bookingId = UserDefaults.standard.value(forKey: "Bookingid") as? String {
            print("Booking ID: \(bookingId)")
            
            Helper.dbRef.collection("Bookings").document(bookingId).delete()
            
            let vc = self.storyboard?.instantiateViewController(identifier:"UserTabBar")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
            
        } else {
            print("Booking ID not found")
        }
                
    }
    
    @IBAction func confirm2BtnAction(_ sender: Any) {
        
        showIndicator(caption: "Please wait...")
        
        let Ref = Helper.dbRef.collection("Bookings")
        self.autoId = Ref.document().documentID
        
        let latitude = BookRideVC.dropOffLat
        let longitude = BookRideVC.dropOffLong
        self.phyAddPoints = GeoPoint(latitude: latitude, longitude:  longitude)
        
        let latitude1 = BookRideVC.pickupLat
        let longitude1 = BookRideVC.pickupLong
        self.phyAddPoints1 = GeoPoint(latitude: latitude1, longitude:  longitude1)
        let para = ["avg":0,"cat_dec":"","cat_img":"","cat_ky":self.categoryTypeid,"cat_title":"","created":NSDate.now,"distance":BookRideVC.TotalDistance,"dp":"","driver_id":"","driver_latlon":"","drop_latlon":self.phyAddPoints!,"drop_location":BookRideVC.dropoOfflocation,"duration":BookRideVC.TotalDuration,"earning":self.totalearning,"key":autoId,"name":"","phone":"","pic_latlon":self.phyAddPoints1!,"pic_location":BookRideVC.pickUplocation,"rating":"","status":"pending","uid":Helper.userId] as [String : Any]
        
        Helper.dbRef.collection("Bookings").document(autoId).setData(para)
        UserDefaults.standard.set(autoId, forKey: "Bookingid")
        
        Helper.Paymentfrom = ""
        SecoundView.isHidden = true
        ThirdView.isHidden = false
        self.hideIndicator()
        
    }
    
    @IBAction func MessageBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatingVc") as! ChatingVc
        vc.name = driverNameLbl.text ?? ""
        vc.recevireid = self.driverid
        vc.phone = self.phoneNumber
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func CallBtnAction(_ sender: Any) {
        
        if let phoneCallURL = URL(string: "tel://\(self.phoneNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelRequestVC") as? CancelRequestVC  {
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
    }
    
    @IBAction func ChangeLocationBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookRideVC") as! BookRideVC
        
        vc.side = "2"
        print(BookRideVC.Selectedlocation,"Selectedlocation")
        vc.bookingid = self.AllData["key"] as? String ?? ""
        BookRideVC.pickUplocation = self.AllData["pic_location"] as? String ?? ""
        BookRideVC.dropoOfflocation = self.AllData["drop_location"] as? String ?? ""
        print(BookRideVC.pickUplocation,"pickUplocation")
        print(BookRideVC.dropoOfflocation,"dropoOfflocation")
        let pickuplatlong = self.AllData["pic_latlon"] as! GeoPoint
        BookRideVC.pickupLat = pickuplatlong.latitude
        BookRideVC.pickupLong = pickuplatlong.longitude
        
        let droplatlong = self.AllData["drop_latlon"] as! GeoPoint
        BookRideVC.dropOffLat = droplatlong.latitude
        BookRideVC.dropOffLong = droplatlong.longitude
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func creditCardSwitchBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentOptionsVC") as! PaymentOptionsVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func ChangeLocationBtn1(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookRideVC") as! BookRideVC
        vc.side = "2"
        print(BookRideVC.Selectedlocation,"Selectedlocation")
        vc.bookingid = self.AllData["key"] as? String ?? ""
        BookRideVC.pickUplocation = self.AllData["pic_location"] as? String ?? ""
        BookRideVC.dropoOfflocation = self.AllData["drop_location"] as? String ?? ""
        print(BookRideVC.pickUplocation,"pickUplocation")
        print(BookRideVC.dropoOfflocation,"dropoOfflocation")
        let pickuplatlong = self.AllData["pic_latlon"] as! GeoPoint
        BookRideVC.pickupLat = pickuplatlong.latitude
        BookRideVC.pickupLong = pickuplatlong.longitude
        
        let droplatlong = self.AllData["drop_latlon"] as! GeoPoint
        BookRideVC.dropOffLat = droplatlong.latitude
        BookRideVC.dropOffLong = droplatlong.longitude
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func creditCardSwitchBtn3(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentOptionsVC") as! PaymentOptionsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelbBtn(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelRequestVC") as? CancelRequestVC  {
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
    }
    
    
    
    //MARK: Get Category Data -
    func categoryData() {
        showIndicator(caption:"Please wait...")
        Helper.dbRef.collection("Categories").document(self.categoryTypeid).getDocument { snapshot, error in
            guard let snap = snapshot?.data(), error == nil else {
                print(error?.localizedDescription as Any)
                print("No Data Found in Dictionary")
                self.hideIndicator()
                return
            }
            let dic = snap as NSDictionary
            
            let imgUrl = dic["img_url"] as? String ?? ""
            self.ImageView.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "profile"))
            self.nameLbl.text = dic["title"] as? String ?? ""
            self.Lbl3.text = dic["dec"] as? String ?? ""
            
            self.Lbl2.text = BookRideVC.Duration
            
            let price = dic["price"] as? Int ?? 0
            let distanceString = BookRideVC.TotalDistance
            self.Lbl1.text =  String(BookRideVC.Distance)
            print(distanceString,"distanceString")
            let distanceComponents = distanceString.components(separatedBy: " ")
            if let distanceValue = Double(distanceComponents.first ?? "0") {
            let multipliedDistanceValue = distanceValue * Double(price)
        //  self.totalearning = "\(multipliedDistanceValue)"
        //  print("Multiplied distance: \(multipliedDistanceValue)")
                
                //  let totalrating = Double(rating / counter)
                let formattedString = String(format: "%.1f", multipliedDistanceValue)
                self.totalearning = formattedString
                //      self.totalearning = String(formattedString)
                self.priceLbl.text = "$ " + String(formattedString)
                
                //    self.priceLbl.text = "$" + " " + "\(multipliedDistanceValue)" + "0"
            } else {
                print("Invalid distance string: \(distanceString)")
            }
            
            self.hideIndicator()
        }
    }
    
    func getBookingsdata() {
        
        Helper.dbRef.collection("Bookings").whereField("uid", isEqualTo : Helper.userId).addSnapshotListener { []querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dict = document.data() as NSDictionary
                    let status = dict["status"] as? String ?? ""
                    if status == "pending" {
                        print(status,"pending")
                        self.navigationController?.isNavigationBarHidden = true
                        self.tabBarController?.tabBar.isHidden = true
                        self.FirstView.isHidden = true
                        self.SecoundView.isHidden = true
                        self.ThirdView.isHidden = false
                        self.FourthView.isHidden = true
                        self.SixthView.isHidden = true
                        
                        //MARK: Timer repeats Every minutes -
                        
                        let duration = BookRideVC.TotalDuration    //dict["duration"] as? String ?? ""
                        if duration == "1 min" {
                            
                            let timeValueString = duration.replacingOccurrences(of: " min", with: "")
                            
                            print(timeValueString,"timeValueString")
                            if let timeValue = Int(timeValueString) {
                                
                                print(timeValue,"timeValue")
                                let timer = Timer(fire: Date(), interval: 60, repeats: true) { timer in
                                    let calendar = Calendar.current
                                    //     let minuteComponent
                                    let minuteComponent = calendar.component(.minute, from: Date())
                                    let secondsUntilNextMinute = 60 - calendar.component(.second, from: Date())
                                    timer.fireDate = Date().addingTimeInterval(TimeInterval(secondsUntilNextMinute))
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "hh:mm a"
                                    let currentTime = Date()
                                    let twoMinutesLater = Calendar.current.date(byAdding: .minute, value: timeValue, to: currentTime)
                                    if let dropoffTime = twoMinutesLater {
                                        let dropoffTimeString = formatter.string(from: dropoffTime)
                                        print(dropoffTimeString,"Dropoff")
                                        self.dropoffTimeLbl.text = "Dropoff by \(dropoffTimeString)"
                                    }
                                }
                                RunLoop.current.add(timer, forMode: .default)
                            } else {
                                print("Invalid time string format")
                            }
                        } else {
                            let timeValueString = duration.replacingOccurrences(of: " mins", with: "")
                            
                            print(timeValueString,"timeValueString")
                            if let timeValue = Int(timeValueString) {
                                print(timeValue,"timeValue")
                                let timer = Timer(fire: Date(), interval: 60, repeats: true) { timer in
                                    let calendar = Calendar.current
                                    //     let minuteComponent
                                    let minuteComponent = calendar.component(.minute, from: Date())
                                    let secondsUntilNextMinute = 60 - calendar.component(.second, from: Date())
                                    timer.fireDate = Date().addingTimeInterval(TimeInterval(secondsUntilNextMinute))
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "hh:mm a"
                                    let currentTime = Date()
                                    let twoMinutesLater = Calendar.current.date(byAdding: .minute, value:timeValue, to: currentTime)
                                    if let dropoffTime = twoMinutesLater {
                                        let dropoffTimeString = formatter.string(from: dropoffTime)
                                        self.dropoffTimeLbl.text = "Dropoff by \(dropoffTimeString)"
                                    }
                                }
                                RunLoop.current.add(timer, forMode: .default)
                                
                            } else {
                                print("Invalid time string format")
                            }
                            
                        }
                        
                        
                    } else if status == "active" {
                        print(status,"active")
                        self.navigationController?.isNavigationBarHidden = true
                        self.tabBarController?.tabBar.isHidden = true
                        self.FirstView.isHidden = true
                        self.SecoundView.isHidden = true
                        self.ThirdView.isHidden = true
                        self.FourthView.isHidden = false
                        self.SixthView.isHidden = true
                        
                        let uid = dict["driver_id"] as? String ?? ""
                        self.driverid = uid
                        ConfirmToVC.driverid = uid
                        let bookingkey = dict["key"] as? String ?? ""
                        ConfirmToVC.bookingid = bookingkey
                        Helper.dbRef.collection("Users").document(uid).addSnapshotListener { snapshot, error in
                            guard let snap = snapshot?.data(), error == nil else {
                                print(error?.localizedDescription as Any)
                                print("No Data Found in Dictionary")
                                self.hideIndicator()
                                return
                            }
                            self.AllData = dict
                            let dic = snap as [String: Any]
                            self.phoneNumber = dic["phone"] as? String ?? ""
                            let fullName = (dic["first_name"] as? String ?? "" ) + " " + (dic["last_name"] as? String ?? "")
                            self.driverNameLbl.text = fullName
                            self.onthewayLbl.text = "\(fullName) is on the way"
                            self.drivNameLbl.text = "Message to \(fullName)"
                            let imgUrl = dic["dp"] as? String ?? ""
                            ConfirmToVC.imageUrl = imgUrl
                            self.userImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "profile"))
                            self.plateNumberLbl.text = dic["plate_num"] as? String ?? ""
                            self.location1Lbl.text = dict["drop_location"] as? String ?? ""
                            
                           
//                            let formattedString = String(format: "%.1f", totalrating)
//                            cell.ratingLbl.text = String(formattedString)
                            self.cardPriceLbl.text = "$ " + (dict["earning"] as? String ?? "")
                            let count = dic["counter"] as? Int ?? 0
                            let rating = dic["rating"] as? Double ?? 0.0
                            
                            let total = rating / Double(count)
                            print(total,"total")
                            self.ratingLbl.text = "\(total)"
                            
                            //  let Userlatlong = dic["lat_lon"] as! GeoPoint
                            //  let userlat = Userlatlong.latitude
                            //   let userlong = Userlatlong.longitude
                            let pickuplatlong = dict["pic_latlon"] as! GeoPoint
                            let pickuplat = pickuplatlong.latitude
                            let pickuplong = pickuplatlong.longitude
                            
                            let originCoordinate = CLLocationCoordinate2D(latitude: self.userlat, longitude: self.userlong)
                            let destinationCoordinate = CLLocationCoordinate2D(latitude: pickuplat, longitude: pickuplong)
                            getDrivingDistanceAndDuration(origin: originCoordinate, destination: destinationCoordinate) { (distance, duration) in
                                if let distance = distance, let duration = duration {
                                    print("Distance: \(distance), Duration: \(duration)")
                                    
                                    DispatchQueue.main.async {
                                        
                                        if duration == "1 min" {
                                            
                                            let timeValueString = duration.replacingOccurrences(of: " min", with: "")
                                            
                                            print(timeValueString,"timeValueString")
                                            if let timeValue = Int(timeValueString) {
                                                self.timeLbl.text = "\(timeValue)"
                                                print(timeValue) // prints 1
                                            } else {
                                                print("Invalid time string format")
                                            }
                                        } else {
                                            let timeValueString = duration.replacingOccurrences(of: " mins", with: "")
                                            
                                            print(timeValueString,"timeValueString")
                                            if let timeValue = Int(timeValueString) {
                                                self.timeLbl.text = "\(timeValue)"
                                                self.minLbl.text = "mins"
                                                print(timeValue) // prints 1
                                            } else {
                                                print("Invalid time string format")
                                            }
                                            
                                        }
                                        
                                        
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
                            
                        }
                        
                        break
                    } else if status == "arrive" {
                        self.navigationController?.isNavigationBarHidden = true
                        self.tabBarController?.tabBar.isHidden = true
                        self.FirstView.isHidden = true
                        self.SecoundView.isHidden = true
                        self.ThirdView.isHidden = true
                        self.FourthView.isHidden = true
                        self.SixthView.isHidden = false
                        
                        let uid = dict["driver_id"] as? String ?? ""
                        self.driverid = uid
                        Helper.dbRef.collection("Users").document(uid).getDocument { snapshot, error in
                            guard let snap = snapshot?.data(), error == nil else {
                                print(error?.localizedDescription as Any)
                                print("No Data Found in Dictionary")
                                self.hideIndicator()
                                return
                            }
                            self.AllData = dict
                            let dic = snap as [String: Any]
                            let fullName = (dic["first_name"] as? String ?? "" ) + " " + (dic["last_name"] as? String ?? "")
                            self.lastLocationLbl.text = "\(fullName) is on the way"
                            let imgUrl = dic["dp"] as? String ?? ""
                            ConfirmToVC.imageUrl = imgUrl
                            self.LocatioLbl.text = dict["drop_location"] as? String ?? ""
                            self.lastpriceLbl.text = "$ " + (dict["earning"] as? String ?? "")
                            
                            self.distanceLbl.text = dict["duration"] as? String ?? ""
//                          let Userlatlong = dic["lat_lon"] as! GeoPoint
//                          let userlat = Userlatlong.latitude
//                          let userlong = Userlatlong.longitude
                            let pickuplatlong = dict["drop_latlon"] as! GeoPoint
                            let droplat = pickuplatlong.latitude
                            let droplong = pickuplatlong.longitude
                            
                            let originCoordinate = CLLocationCoordinate2D(latitude: self.userlat, longitude: self.userlong)
                            let destinationCoordinate = CLLocationCoordinate2D(latitude: droplat, longitude: droplong)
                              
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
                            
                        }
                        
                    } else if status == "reached" {
                        
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(identifier: "CompletionRequestVC") as! CompletionRequestVC
                            print(vc.categoryid,"categoryTypeid")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    } else if status == "rejected" {
                        print("rejected")
                        let vc = self.storyboard?.instantiateViewController(identifier:"UserTabBar")
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
                        
                    } else {
                        print("No Working")
                    }
                }
            }
        }
        
        self.FirstView.isHidden = false
        self.SecoundView.isHidden = true
        self.ThirdView.isHidden = true
        self.FourthView.isHidden = true
        self.SixthView.isHidden = true
        
    }
    
}
