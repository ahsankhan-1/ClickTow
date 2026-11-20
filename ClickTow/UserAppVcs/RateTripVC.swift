//
//  RateTripVC.swift
//  ClickTow
//
//  Created by M Hayat on 27/03/2023.
//

import UIKit
import Cosmos


class RateTripVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var DriverDic:NSDictionary = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        UserData()
        
        mainView.layer.cornerRadius = 5
        skipBtn.roundButton()
        submitBtn.roundButton()
        
        RatingView.settings.fillMode = .full
        
        RatingView.settings.updateOnTouch = true
        
        RatingView.didFinishTouchingCosmos = { rating in
            
        }
        RatingView.didTouchCosmos = { rating in
            let Per = Double(rating).rounded(toPlaces: 1)
            print(Per)
        }
        
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier:"UserTabBar")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        let counter = self.DriverDic["counter"] as? Int ?? 0
        let dbrating = self.DriverDic["rating"] as? Double ?? 0.0
        print(counter,"counter")
        print(dbrating,"dbrating")
        
        let count = counter + 1
        print(count,"count")
        let rating = RatingView.rating
        print(rating,"rating")
        let totalRating = dbrating + rating
        print(totalRating,"totalRating")
        
           
        
        
        let paras = ["rating":totalRating,"counter":count] as [String : Any]
        Helper.dbRef.collection("Users").document(CompletionRequestVC.driverid).updateData(paras)

        let vc = self.storyboard?.instantiateViewController(identifier:"UserTabBar")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    //MARK: User Data -
    func UserData() {
          showIndicator(caption: "Please wait...")
        Helper.dbRef.collection("Users").document(CompletionRequestVC.driverid).getDocument { snapshot, error in
            guard let snap = snapshot?.data(), error == nil else {
                print(error?.localizedDescription as Any)
                print("No Data Found in Dictionary")
                self.hideIndicator()
                return
            }
          let dic = snap as NSDictionary
            self.DriverDic = dic
            print(Helper.userDic,"userDic")
            self.hideIndicator()
            
         
        }
    }
    

}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
