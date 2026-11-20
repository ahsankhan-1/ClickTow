//
//  ButtonExtension.swift
//  ClickTow
//
//  Created by M Hayat on 09/02/2023.
//

import Foundation
import UIKit

extension UIButton {
    
    func roundButton(cornerRadius:CGFloat = 0.0){
        self.layer.cornerRadius = cornerRadius == 0.0 ? self.layer.frame.height/2 : cornerRadius
        let fontSize = self.titleLabel?.font.pointSize
        guard fontSize != nil else{return}
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!, weight: .semibold)
    }
    
    func radioButton(rightPadding:CGFloat = 0){
        self.semanticContentAttribute = .forceRightToLeft
        self.contentHorizontalAlignment = .left
        let titleimgWidthuser = (self.titleLabel!.frame.width) + (self.imageView!.frame.width) + rightPadding
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.size.width-titleimgWidthuser, bottom: 0, right: 0)
        let fontSize = self.titleLabel?.font.pointSize
        guard fontSize != nil else{return}
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!, weight: .semibold)
    }
    
    func roundButtonWithBorder(_ borderWidth:CGFloat = 1 ,cornerRadius:CGFloat = 0.0,bordercolor:UIColor = UIColor.black){
        self.layer.cornerRadius = cornerRadius == 0.0 ? self.layer.frame.height/2 : cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = bordercolor.cgColor
        let fontSize = self.titleLabel?.font.pointSize
        guard fontSize != nil else{return}
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!, weight: .semibold)
        
    }
}
