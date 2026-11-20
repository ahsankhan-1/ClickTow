//
//  CompletionRequestVC.swift
//  ClickTow
//
//  Created by M Hayat on 27/03/2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import GoogleMaps


class CompletionRequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
   
    
    
    @IBOutlet weak var CompletionTableView: UITableView!
    
    var CompletionDic:[NSDictionary] = []
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    var categoryid = ""
    
    static var driverid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBookingsdata()
        
        self.title = "Completion Request"
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        
        CompletionTableView.delegate = self
        CompletionTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CompletionDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CompletionTableView.dequeueReusableCell(withIdentifier: "CompletionRequestCell", for: indexPath) as! CompletionRequestCell
        
        cell.startlocationLbl.text = CompletionDic[indexPath.row]["pic_location"] as? String ?? ""
        cell.destinationLbl.text = CompletionDic[indexPath.row]["drop_location"] as? String ?? ""
        cell.priceLbl.text = "$ " + (CompletionDic[indexPath.row]["earning"] as? String ?? "")
        
        let created = CompletionDic[indexPath.row]["created"] as? Timestamp
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
        let driverid = CompletionDic[indexPath.row]["driver_id"] as? String ?? ""
        
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
            let counter = dic["counter"] as? Int ?? 0
            let rating = dic["rating"] as? Int ?? 0
            
//            if counter == 0 || rating == 0 {
//                cell.ratingLbl.text = "Non"
//            } else {
//                let totalrating = rating / counter
//                cell.ratingLbl.text = String(totalrating) + ".0"
//
//            }
        }
        
        let pickuplatlong = CompletionDic[indexPath.row]["pic_latlon"] as! GeoPoint
        let pickuplat = pickuplatlong.latitude
        let pickuplong = pickuplatlong.longitude
        let droplatlong = CompletionDic[indexPath.row]["drop_latlon"] as! GeoPoint
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
        
        let marker1 = GMSMarker(position: destinationCoordinate)
        if let image = UIImage(named: "destination location") {
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            marker1.icon = resizedImage
        }
        marker1.map = cell.MapView
        
        
        getBestRoute(origin: originCoordinate, destination: destinationCoordinate) { (locations, polyline) in
            if locations.count > 0 {
               polyline?.map = cell.MapView
                
                // Do something with the array of CLLocation objects
                print("Locations: \(locations)")
            } else {
                print("Unable to get route")
            }
        }
        
        
        
        cell.disputePressed = {
           
            
        }
        
        cell.approvedPressed = {
           
            let bookingid = self.CompletionDic[indexPath.row]["key"] as? String ?? ""
            CompletionRequestVC.driverid = self.CompletionDic[indexPath.row]["driver_id"] as? String ?? ""
            
            print(bookingid,"bookingid")
            print(CompletionRequestVC.driverid,"driverid")
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RateTripVC") as! RateTripVC
            self.addChild(vc)
            vc.view.frame = self.view.frame
            // vc.delegate = self
            
            let para = ["status":"complete","created":NSDate.now]
            Helper.dbRef.collection("Bookings").document(bookingid).updateData(para)

            let paras = ["available":"available"]
            Helper.dbRef.collection("Users").document(CompletionRequestVC.driverid).updateData(paras)
            
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        
        
        cell.disputeBtn.roundButton()
        cell.approveCompletionBtn.roundButton()
        BackGroundViewtableCell(backGroundView: cell.BackGroundView)
        cell.MapView.layer.cornerRadius = 5
        cell.driverImageView.layer.cornerRadius = cell.driverImageView.layer.frame.height/2
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func getBookingsdata() {
        
        showIndicator(caption: "Please wait...")
        
        Helper.dbRef.collection("Bookings").whereField("status", isEqualTo: "reached").getDocuments { []querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hideIndicator()
            } else {
                for document in querySnapshot!.documents {
                    let dict = document.data() as NSDictionary
                   
                    self.CompletionDic.append(dict)
                    self.hideIndicator()
                    removeNoData()
                    self.CompletionTableView.reloadData()
                    
                    
                }
            }
        }
        showNoData(table: self.CompletionTableView,deatilText:"No Activities",animationName: " ")
        self.hideIndicator()
        self.CompletionTableView.reloadData()
    }

    
   

}
