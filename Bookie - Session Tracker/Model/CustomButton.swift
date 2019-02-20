//
//  CustomButton.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/19/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
import ChameleonFramework
class CustomButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
     //   setShadow()
        setTitleColor(.white, for: .normal)
        
        backgroundColor = UIColor.flatLime() //()?.darken(byPercentage: 0.15)
        titleLabel?.font = UIFont(name: "AvenirNext-Demi", size: 18)
        layer.cornerRadius = 10
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
//    private func setShadow(){
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        layer.shadowRadius = 10
//        layer.shadowOpacity = 0.5
//        clipsToBounds = true
//        layer.masksToBounds = false
//    }

}
