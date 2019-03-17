//
//  CustomLabel.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 3/15/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
import ChameleonFramework

class CustomLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupButton()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupButton()
    }
    
    func setupButton(){
        clipsToBounds = true
        textColor = UIColor.flatRedColorDark()
        font = UIFont.boldSystemFont(ofSize: 18)
       // font = font.withSize(20)
    }
    
}
