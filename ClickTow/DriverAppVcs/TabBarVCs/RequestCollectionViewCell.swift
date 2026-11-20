//
//  RequestCollectionViewCell.swift
//  ClickTow
//
//  Created by M Hayat on 14/03/2023.
//

import UIKit

class RequestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    
    
    var AcceptedTaped: (() -> ()) = {}
    
    
    @IBAction func acceptBtnTapped(_ sender: UIButton) {
       print("Accept")
        AcceptedTaped()
    }
    
}

