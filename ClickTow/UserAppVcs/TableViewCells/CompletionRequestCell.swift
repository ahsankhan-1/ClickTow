//
//  CompletionRequestCell.swift
//  ClickTow
//
//  Created by M Hayat on 27/03/2023.
//

import UIKit
import GoogleMaps

class CompletionRequestCell: UITableViewCell, CLLocationManagerDelegate {
    
    @IBOutlet weak var BackGroundView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var drivernameLbl: UILabel!
    @IBOutlet weak var startlocationImageView: UIImageView!
    @IBOutlet weak var startlocationLbl: UILabel!
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var disputeBtn: UIButton!
    @IBOutlet weak var approveCompletionBtn: UIButton!
    
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    var disputePressed: (() -> ()) = {}
    var approvedPressed: (() -> ()) = {}
    var MapView = GMSMapView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        MapView.frame = mapView.bounds
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(MapView)
        
        MapView.settings.compassButton = true
        MapView.settings.myLocationButton = true
        MapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
    }
    
    @IBAction func disputeBtnAction(_ sender: Any) {
        disputePressed()
    }
    
    @IBAction func approveCompletionBtn(_ sender: Any) {
       approvedPressed()
    }
    
    

    //MARK: Get Current Location -
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
        MapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
    
    

}
