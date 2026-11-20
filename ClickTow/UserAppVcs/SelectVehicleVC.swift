//
//  SelectVehicleVC.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import UIKit
import FirebaseFirestore

class SelectVehicleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var VehicleTableView: UITableView!
    
    var CategoriesDic:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Vehicle"
        
        getAllCategories()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        VehicleTableView.delegate = self
        VehicleTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoriesDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VehicleTableView.dequeueReusableCell(withIdentifier: "SelectVehicleCell", for: indexPath) as! SelectVehicleCell
        
        cell.nameLbl.text = CategoriesDic[indexPath.row]["title"] as? String ?? ""
        cell.timeLbl.text = (CategoriesDic[indexPath.row]["capacity"] as? String ?? "")  + " kg"
        cell.AffordableLbl.text = CategoriesDic[indexPath.row]["dec"] as? String ?? ""
        cell.priceLbl.text = "$" + " " + String(CategoriesDic[indexPath.row]["price"] as? Int ?? 0)
        let imgUrl = CategoriesDic[indexPath.row]["img_url"] as? String ?? ""
        cell.UserImageView.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "profile"))
        
        cell.UserImageView.layer.cornerRadius = 5
        BackGroundViewtableCell(backGroundView: cell.BackGroundView)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConfirmToVC") as! ConfirmToVC
        vc.categoryTypeid = CategoriesDic[indexPath.row]["key"] as? String ?? ""
        vc.count = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Get Categories -
    func getAllCategories() {
        
        showIndicator(caption: "Please wait...")
        self.CategoriesDic.removeAll()
        Helper.dbRef.collection("Categories").getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshots \(error!)")
                return
            }
            for document in snapshot.documents {
                let postTempDic = document.data() as NSDictionary
                
                self.CategoriesDic.append(postTempDic)
                self.hideIndicator()
                self.VehicleTableView.reloadData()
                
            }
        }
        self.hideIndicator()
    }
    
    
}
