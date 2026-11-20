//
//  Helper.swift
//  ClickTow
//
//  Created by M Hayat on 08/02/2023.
//

import FirebaseDatabase
import FirebaseStorage
import Foundation
import UIKit
import FirebaseFirestore
import Firebase

class Helper {
    
    static var dbRef =  Firestore.firestore()
    static var storRef = Storage.storage().reference()
    static var dbChatRef = Database.database().reference()
    static var dbChatStrRef = Storage.storage().reference()
    static var userId = ""
    static var userDic: NSDictionary = [:]
    
    static var userLat = 0.0
    static var userLong = 0.0
    static var userAdd = ""
    static var userCity = ""
    static var userCountry = ""
    static var PlacesKey = "AIzaSyCjxRhtdw74nJ9YdYaGjvY5IZUEA5Ux0JA"
    static var UserType = ""
    static var Paymentfrom = ""
    static var SigninWith = ""
    
}
