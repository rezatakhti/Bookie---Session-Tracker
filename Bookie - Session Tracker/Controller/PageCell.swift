//
//  PageCell.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 12/7/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell{
    var page : Page? {
        didSet {
            guard let page = page else {
                return
            }
            
            let image = UIImage(named: page.imageName)
            imageView.image = image
            
            let color = UIColor(white: 0.2, alpha: 1)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium), NSAttributedString.Key.foregroundColor : color]
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: attributes)
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedString.Key.foregroundColor : color]))
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let length = attributedText.string.count
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle : paragraph], range: NSRange(location: 0, length: length))
            textView.attributedText = attributedText
        }
    }
  
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample text"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    let lineSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpViews()
    }
    
    
    private func setUpViews(){
        
        backgroundColor = .white
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeperatorView)

            
    
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0.8).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width*0.1).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width*0.1).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        lineSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        lineSeperatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineSeperatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineSeperatorView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        lineSeperatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
}
