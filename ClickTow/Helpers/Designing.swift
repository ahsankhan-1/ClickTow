//
//  Designing.swift
//  ClickTow
//
//  Created by M Hayat on 08/02/2023.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseFirestore
import Lottie
import iProgressHUD
import GoogleMaps

let animationView = LottieAnimationView(name: "loadiing")
var animationViewForData = LottieAnimationView()
let detailLbl = UILabel(frame: CGRect(x: 0, y: 130, width: 150, height: 20))

func BackGroundViewtableCell(backGroundView: UIView) {
    
   backGroundView.layer.cornerRadius = 7
   backGroundView.layer.shadowOpacity = 0.5
   backGroundView.layer.shadowRadius = 2.0
   backGroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
   backGroundView.layer.shadowOffset = CGSize(width: 0.0, height: 1)
   backGroundView.layer.masksToBounds = false
    
}
func BackGroundRound(backGroundView: UIView) {
    
   backGroundView.layer.cornerRadius = 5
   backGroundView.layer.shadowOpacity = 0.5
   backGroundView.layer.shadowRadius = 2.0
   backGroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
   backGroundView.layer.shadowOffset = CGSize(width: 0.0, height: 1)
   backGroundView.layer.masksToBounds = false
    
}

func BackGroundView(backGroundView: UIView) {
    
    backGroundView.layer.cornerRadius = 10
    backGroundView.layer.shadowOpacity = 1.0
    backGroundView.layer.shadowRadius = 8
    backGroundView.layer.shadowColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 0.7614513675)
    backGroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    backGroundView.layer.masksToBounds = false
    
}

func ShadowTextView(textView: UITextView) {
    
    textView.layer.cornerRadius = 5
    textView.layer.shadowOpacity = 0.5
    textView.layer.shadowRadius = 2
    textView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.9013565771)
    textView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    textView.layer.masksToBounds = false
    
}

func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
            print(number,"number")
            print(randomNumber,"randomNumber")
        }
        return number
 }

func showNoData(table:UITableView,deatilText:String = "no Data found",animationName:String = "noData") {
    animationViewForData.translatesAutoresizingMaskIntoConstraints = false
    animationViewForData = .init(name:animationName)
    animationViewForData.loopMode = .loop
    animationViewForData.play()
    detailLbl.font = UIFont.systemFont(ofSize: 17.0)
    detailLbl.text = deatilText
    detailLbl.textAlignment = .center
    detailLbl.translatesAutoresizingMaskIntoConstraints = false
    table.addSubview(detailLbl)
    table.addSubview(animationViewForData)
    
    table.addConstraint(NSLayoutConstraint(item: animationViewForData, attribute: .centerX, relatedBy: .equal, toItem: table, attribute: .centerX, multiplier: 1.0, constant: 1))
    table.addConstraint(NSLayoutConstraint(item: animationViewForData, attribute: .centerY, relatedBy: .equal, toItem: table, attribute: .centerY, multiplier: 0.8, constant: 1))
    animationViewForData.addConstraint(NSLayoutConstraint(item: animationViewForData, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
    animationViewForData.addConstraint(NSLayoutConstraint(item: animationViewForData, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
    
    table.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .centerX, relatedBy: .equal, toItem: table, attribute: .centerX, multiplier: 1.0, constant: 1))
    table.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .centerY, relatedBy: .equal, toItem: table, attribute: .centerY, multiplier: 1.0, constant: 1))
    detailLbl.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 180))
    detailLbl.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 180))
}

func removeNoData() {
    animationViewForData.stop()
    animationViewForData.removeFromSuperview()
    detailLbl.removeFromSuperview()
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


func getBestRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (_ route: [CLLocation], _ polyline: GMSPolyline?) -> Void) {
    
    let originString = "\(origin.latitude),\(origin.longitude)"
    let destinationString = "\(destination.latitude),\(destination.longitude)"
    
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destinationString)&mode=driving&key=AIzaSyCjxRhtdw74nJ9YdYaGjvY5IZUEA5Ux0JA"
    
    guard let url = URL(string: urlString) else {
        completion([], nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil, let data = data else {
            completion([], nil)
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            completion([], nil)
            return
        }
        
        guard let routes = json["routes"] as? [[String: Any]], let route = routes.first else {
            completion([], nil)
            return
        }
        
        if let overviewPolyline = route["overview_polyline"] as? [String: Any], let points = overviewPolyline["points"] as? String {
            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            DispatchQueue.main.async {
                polyline.strokeWidth = 6
                polyline.strokeColor = .black
            }
            
            var locations: [CLLocation] = []
            if let legs = route["legs"] as? [[String: Any]], let leg = legs.first, let steps = leg["steps"] as? [[String: Any]] {
                for step in steps {
                    if let polyline = step["polyline"] as? [String: Any], let points = polyline["points"] as? String {
                        let path = GMSPath(fromEncodedPath: points)
                        for i in 0..<(path?.count())! {
                            let coordinate = path!.coordinate(at: i)
                            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                            locations.append(location)
                        }
                    }
                }
            }
            
            completion(locations, polyline)
        } else {
            completion([], nil)
        }
    }
    
    task.resume()
}
