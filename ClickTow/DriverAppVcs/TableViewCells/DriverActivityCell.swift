//
//  DriverActivityCell.swift
//  ClickTow
//
//  Created by M Hayat on 16/02/2023.
//

import UIKit
import GoogleMaps

class DriverActivityCell: UITableViewCell {
    
    
    @IBOutlet weak var BackGroundView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var drivernameLbl: UILabel!
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
