//
//  CustomTextField.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/19/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
        setShadow()
    }
    
    
    private func setUpField() {
        tintColor             = .white
        textColor             = .white
        font                  = UIFont(name: "AvenirNext-Demi", size: 18)
        backgroundColor       = UIColor(white: 1.0, alpha: 0.5)
        autocorrectionType    = .yes
        layer.cornerRadius    = 15.0
        clipsToBounds         = true
        
        let placeholder       = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont   = UIFont(name: "AvenirNext-Demi", size: 18)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
             NSAttributedString.Key.font: placeholderFont])
        
        let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        leftView              = indentView
        leftViewMode          = .always
    }
    
    private func setShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
