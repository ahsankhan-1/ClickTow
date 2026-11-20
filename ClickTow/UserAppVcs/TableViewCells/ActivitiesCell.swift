//
//  ActivitiesCell.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import GoogleMaps

class ActivitiesCell: UITableViewCell {
    
    
    @IBOutlet weak var BackGroundView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var drivernameLbl: UILabel!
    @IBOutlet weak var confirmLbl: UILabel!
    @IBOutlet weak var startlocationImageView: UIImageView!
    @IBOutlet weak var startlocationLbl: UILabel!
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var ZoominoutView: UIStackView!
    @IBOutlet weak var ZoominBtn: UIButton!
    @IBOutlet weak var zoomoutBtn: UIButton!
    
    var ZoominPressed: (() -> ()) = {}
    var ZoomoutPressed: (() -> ()) = {}
    var MapView = GMSMapView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        MapView.frame = mapView.bounds
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(MapView)
        
        
    }
    
    @IBAction func zoomin(_ sender: Any) {
        ZoominPressed()
    }
    @IBAction func zoomout(_ sender: Any) {
        ZoomoutPressed()
    }
    

  
}
