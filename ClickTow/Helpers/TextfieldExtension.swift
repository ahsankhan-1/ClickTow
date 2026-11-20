//
//  TextfieldExtension.swift
//  ClickTow
//
//  Created by M Hayat on 02/03/2023.
//

import Foundation
import UIKit

extension UITextField {
    
    func TextFieldDesign() {
        layer.cornerRadius = 3
      //  textfield.layer.borderWidth = 1
      //  textfield.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tintColor = #colorLiteral(red: 0, green: 0.7803921569, blue: 0.7450980392, alpha: 0.5045648032)

        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 16))
        leftView = leftpaddingView
        leftViewMode = .always
        let rightpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        rightView = rightpaddingView
        rightViewMode = .always
        
    }
    
    func shadowWithPaddingBothSide(){
       
        backgroundColor = .white
        font = .systemFont(ofSize: 14)
        textColor = .black
        layer.cornerRadius = layer.frame.height/2
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 16))
        leftView = leftpaddingView
        leftViewMode = .always
        let rightpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        rightView = rightpaddingView
        rightViewMode = .always
             
    }

    func shadowWithRightPadding(){
        
        backgroundColor = .white
        font = .systemFont(ofSize: 14)
        textColor = .black
        layer.cornerRadius = layer.frame.height/2
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 16))
        leftView = leftpaddingView
        leftViewMode = .always
        rightViewMode = .always
        
    }
    
}
