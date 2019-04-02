//
//  CustomTextView.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 3/16/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class customTextView : UITextView{
    
    init(frame: CGRect, textContainer: NSTextContainer){
        super.init(frame: frame, textContainer: textContainer)
        setShadow()
        setUpField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setShadow()
        setUpField()
    }
    
    private func setShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
        contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10)
        
    }
    
    private func setUpField() {
        tintColor             = .white
        textColor             = .white
        font                  = UIFont.systemFont(ofSize: 18)
        backgroundColor       = UIColor(white: 1.0, alpha: 0.5)
        autocorrectionType    = .yes
        layer.cornerRadius    = 15.0
        clipsToBounds         = true
        
       
    }
    
    
    
}
