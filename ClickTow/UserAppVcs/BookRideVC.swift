//
//  BookRideVC.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit
import GoogleMaps
import FirebaseFirestore

class BookRideVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var picklocationTF: UITextField!
    @IBOutlet weak var dropLocationTF: UITextField!
    @IBOutlet weak var pickuplocationBtn: UIButton!
    @IBOutlet weak var droplocationBtn: UIButton!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    static var pickupLat = 0.0
    static var pickupLong = 0.0
    static var dropOffLat = 0.0
    static var dropOffLong = 0.0
    static var pickUplocation = ""
    static var dropoOfflocation = ""
    static var Selectedlocation = ""
    
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    static var userlat = 0.0
    static var userlong = 0.0
    static var Distance = ""
    static var Duration = ""
    static var TotalDistance = ""
    static var TotalDuration = ""
    var bookingid = ""
    var side = ""
    
    var MapView = GMSMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Let’s Ride"
        MapView.layer.cornerRadius = 5
        continueBtn.roundButton()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        MapView.frame = mapView.bounds
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(MapView)
        
        if side != "2" {
            BookRideVC.Distance = ""
            BookRideVC.Duration = ""
            BookRideVC.pickupLat = 0.0
            BookRideVC.pickupLong = 0.0
            BookRideVC.Selectedlocation = ""
            BookRideVC.dropOffLat = 0.0
            BookRideVC.dropOffLong = 0.0
            BookRideVC.dropoOfflocation = ""
            
        }
        
        picklocationTF.isUserInteractionEnabled = false
        dropLocationTF.isUserInteractionEnabled = false
        
        MapView.settings.compassButton = true
        MapView.settings.myLocationButton = true
        MapView.isMyLocationEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if BookRideVC.Selectedlocation == "pick" {
            picklocationTF.text = BookRideVC.pickUplocation
        } else if BookRideVC.Selectedlocation == "drop" {
            dropLocationTF.text = BookRideVC.dropoOfflocation
        } else if side == "2" {
            picklocationTF.text = BookRideVC.pickUplocation
            dropLocationTF.text = BookRideVC.dropoOfflocation
        }
        
        MapView.clear()
        if BookRideVC.pickupLat != 0.0 && BookRideVC.pickupLong != 0.0 && BookRideVC.dropOffLat != 0.0 && BookRideVC.dropOffLong != 0.0 {
            let originCoordinate = CLLocationCoordinate2D(latitude: BookRideVC.pickupLat, longitude: BookRideVC.pickupLong)
            let destinationCoordinate = CLLocationCoordinate2D(latitude: BookRideVC.dropOffLat, longitude: BookRideVC.dropOffLong)
            
            // Create a marker at the origin location
            let marker = GMSMarker(position: originCoordinate)
            if let image = UIImage(named: "truck") {
                let size = CGSize(width: 32, height: 32)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                image.draw(in: CGRect(origin: CGPoint.zero, size: size))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                marker.icon = resizedImage
            }
            // Add the marker to the map
            marker.map = MapView
            
            
            getDrivingDistanceAndDuration(origin: originCoordinate, destination: destinationCoordinate) { (distance, duration) in
                if let distance = distance, let duration = duration {
                    print("Distance: \(distance), Duration: \(duration)")
                    BookRideVC.TotalDistance = distance
                    BookRideVC.TotalDuration = duration
                    
                    print(BookRideVC.TotalDistance,"TotalDistance")
                    print(BookRideVC.TotalDuration,"TotalDuration")
                } else {
                    print("Unable to get distance and duration")
                }
            }
            
            
            getBestRoute(origin: originCoordinate, destination: destinationCoordinate) { [self] (locations, polyline) in
                if locations.count > 0 {
                    // Draw the polyline on a GMSMapView
                    
                    polyline?.map = self.MapView
                    
                    // Do something with the array of CLLocation objects
                    print("Locations: \(locations)")
                } else {
                    print("Unable to get route")
                }
            }
        }
        
    }
    
    @IBAction func picklocationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddUserLocationVC") as! AddUserLocationVC
        BookRideVC.Selectedlocation = "pick"
        vc.selectedlocation = BookRideVC.Selectedlocation
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func droplocationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddUserLocationVC") as! AddUserLocationVC
        BookRideVC.Selectedlocation = "drop"
        vc.selectedlocation = BookRideVC.Selectedlocation
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        let pickupLocation =  self.picklocationTF.text
        let dropLocation =  self.dropLocationTF.text
        
        if pickupLocation == "" {
            Toast.showToast(message: "please select pickup location", controller: self)
        } else if dropLocation == "" {
            Toast.showToast(message: "please select drop location", controller: self)
        } else if pickupLocation == dropLocation  {
            Toast.showToast(message: "please change drop location", controller: self)
        } else {
            
            if self.side == "2" {
                
                let latitude = BookRideVC.dropOffLat
                let longitude = BookRideVC.dropOffLong
                let phyAddPoints = GeoPoint(latitude: latitude, longitude:  longitude)
                
                let latitude1 = BookRideVC.pickupLat
                let longitude1 = BookRideVC.pickupLong
                let phyAddPoints1 = GeoPoint(latitude: latitude1, longitude:  longitude1)
                
                let para = ["distance":BookRideVC.TotalDistance,"drop_latlon":phyAddPoints,"drop_location":BookRideVC.dropoOfflocation,"duration":BookRideVC.TotalDuration,"pic_latlon":phyAddPoints1,"pic_location":BookRideVC.pickUplocation] as [String : Any]
                Helper.dbRef.collection("Bookings").document(self.bookingid).updateData(para)
                
                navigationController?.popViewController(animated: true)
                
                
            } else {
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "SelectVehicleVC") as! SelectVehicleVC
                navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            
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
        BookRideVC.userlat = location.coordinate.latitude
        BookRideVC.userlong = location.coordinate.longitude
        print(BookRideVC.userlat,"userlat")
        print(BookRideVC.userlong,"userlong")
        MapView.camera = camera
        locationManager.stopUpdatingLocation()
        
        
        if BookRideVC.pickupLat != 0.0 && BookRideVC.pickupLong != 0.0 && BookRideVC.userlat != 0.0 && BookRideVC.userlong != 0.0 {
            let originCoordinate = CLLocationCoordinate2D(latitude: BookRideVC.userlat, longitude: BookRideVC.userlong)
            let destinationCoordinate = CLLocationCoordinate2D(latitude: BookRideVC.pickupLat, longitude: BookRideVC.pickupLong)
            getDrivingDistanceAndDuration(origin: originCoordinate, destination: destinationCoordinate) { (distance, duration) in
                if let distance = distance, let duration = duration {
                    print("Distance: \(distance), Duration: \(duration)")
                    
                    BookRideVC.Distance = distance
                    BookRideVC.Duration = duration
                    print(BookRideVC.Distance,"Distance")
                    print(BookRideVC.Duration,"Duration")
                    
                    
                } else {
                    print("Unable to get distance and duration")
                }
            }
        }
    }
    
    func getDrivingDistanceAndDuration(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (String?, String?) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origin.latitude),\(origin.longitude)&destinations=\(destination.latitude),\(destination.longitude)&key=AIzaSyCjxRhtdw74nJ9YdYaGjvY5IZUEA5Ux0JA"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            // Handle any errors
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            // Check that data was returned
            guard let data = data else {
                print("No data found")
                completion(nil, nil)
                return
            }
            
            // Parse the JSON data
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let rows = json["rows"] as? [[String: Any]], let elements = rows[0]["elements"] as? [[String: Any]], let element = elements[0]["distance"] as? [String: Any] {
                        let distance = element["text"] as? String ?? ""
                        let distanceValue = element["value"] as? Int ?? 0
                        print("Distance: \(distance) (\(distanceValue) meters)")
                        if let element = elements[0]["duration"] as? [String: Any] {
                            let duration = element["text"] as? String ?? ""
                            let durationValue = element["value"] as? Int ?? 0
                            print("Duration: \(duration) (\(durationValue) seconds)")
                            completion(distance, duration)
                        } else {
                            completion(nil, nil)
                        }
                    } else {
                        completion(nil, nil)
                    }
                }
            } catch let error as NSError {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }.resume()
    }
    
}
