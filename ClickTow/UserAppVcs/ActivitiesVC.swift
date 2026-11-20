//
//  ActivitiesVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import GoogleMaps

class ActivitiesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var ActivitesTableView: UITableView!
    
    var BookingDic:[NSDictionary] = []
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Activities"
        
        ActivitesTableView.delegate = self
        ActivitesTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getBookingsdata()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActivitesTableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as! ActivitiesCell
        
        cell.startlocationLbl.text = BookingDic[indexPath.row]["pic_location"] as? String ?? ""
        cell.destinationLbl.text = BookingDic[indexPath.row]["drop_location"] as? String ?? ""
        cell.priceLbl.text = "$ " + (BookingDic[indexPath.row]["earning"] as? String ?? "")
        
        let created = BookingDic[indexPath.row]["created"] as? Timestamp
        let timestamp = created?.dateValue().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timestamp ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy "
        let dateString = dateFormatter.string(from: date)
        cell.dateLbl.text = dateString
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "h:mm a"
        let dateString1 = dateFormatter1.string(from: date)
        cell.timeLbl.text = dateString1
        let driverid = BookingDic[indexPath.row]["driver_id"] as? String ?? ""
        
        Helper.dbRef.collection("Users").document(driverid).getDocument { snapshot, error in
            guard let snap = snapshot?.data(), error == nil else {
                print(error?.localizedDescription as Any)
                print("No Data Found in Dictionary")
                self.hideIndicator()
                return
            }
            let dic = snap as NSDictionary
            let imgUrl = dic["dp"] as? String ?? ""
            cell.driverImageView.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "profile"))
            cell.drivernameLbl.text = dic["first_name"] as? String ?? ""
            let counter = dic["counter"] as? Double ?? 0
            let rating = dic["rating"] as? Double ?? 0
            
            if counter == 0 || rating == 0 {
                cell.ratingLbl.text = "Non"
            } else {
                
                let totalrating = Double(rating / counter)
                let formattedString = String(format: "%.1f", totalrating)
                cell.ratingLbl.text = String(formattedString)
               
            }
        }
        
        let pickuplatlong = BookingDic[indexPath.row]["pic_latlon"] as! GeoPoint
        let pickuplat = pickuplatlong.latitude
        let pickuplong = pickuplatlong.longitude
        let droplatlong = BookingDic[indexPath.row]["drop_latlon"] as! GeoPoint
        let droplat = droplatlong.latitude
        let droplong = droplatlong.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: pickuplat, longitude: pickuplong, zoom: 12)
        cell.MapView.camera = camera
        locationManager.stopUpdatingLocation()
        
        let originCoordinate = CLLocationCoordinate2D(latitude:pickuplat, longitude: pickuplong)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: droplat, longitude: droplong)
        
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
        marker.map = cell.MapView
        
        getBestRoute(origin: originCoordinate, destination: destinationCoordinate) { (locations, polyline) in
            if locations.count > 0 {
                // Draw the polyline on a GMSMapView
                
                polyline?.map = cell.MapView
                
                // Do something with the array of CLLocation objects
                print("Locations: \(locations)")
            } else {
                print("Unable to get route")
            }
        }
        
        
        
        BackGroundRound(backGroundView: cell.ZoominoutView)
        cell.ZoominPressed = {
            let currentCameraPosition = cell.MapView.camera
            let zoomInCameraPosition = GMSCameraPosition(target: currentCameraPosition.target, zoom: currentCameraPosition.zoom + 1)
            let cameraUpdate = GMSCameraUpdate.setCamera(zoomInCameraPosition)
            cell.MapView.animate(with: cameraUpdate)
            
        }
        cell.ZoomoutPressed = {
            let currentCameraPosition = cell.MapView.camera
            let zoomOutCameraPosition = GMSCameraPosition(target: currentCameraPosition.target, zoom: currentCameraPosition.zoom - 1)
            let cameraUpdate = GMSCameraUpdate.setCamera(zoomOutCameraPosition)
            cell.MapView.animate(with: cameraUpdate)
        }
        
        
        
        BackGroundViewtableCell(backGroundView: cell.BackGroundView)
        cell.MapView.layer.cornerRadius = 5
        cell.driverImageView.layer.cornerRadius = cell.driverImageView.layer.frame.height/2
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func getBookingsdata() {
        
        showIndicator(caption: "Please wait...")
        
        Helper.dbRef.collection("Bookings").whereField("status", isEqualTo: "complete").whereField("uid", isEqualTo: Helper.userId).getDocuments { []querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hideIndicator()
            } else {
                for document in querySnapshot!.documents {
                    let dict = document.data() as NSDictionary
                   
                    self.BookingDic.append(dict)
                    self.hideIndicator()
                    removeNoData()
                    self.ActivitesTableView.reloadData()
                    
                    
                }
            }
        }
        showNoData(table: self.ActivitesTableView,deatilText:"No Data Found",animationName: " ")
        self.hideIndicator()
        self.ActivitesTableView.reloadData()
    }

}
