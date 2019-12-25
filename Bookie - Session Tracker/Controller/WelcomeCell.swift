//
//  WelcomeCell.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 12/22/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class WelcomeCell: UICollectionViewCell {
    let button = CustomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpButton()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButton(){
        button.setTitle("Begin", for: .normal)
        button.layer.borderWidth = 0
    }
    
    func setUpConstraints(){
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
}
