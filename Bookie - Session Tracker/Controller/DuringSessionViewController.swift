//
//  DuringSessionViewController.swift
//  
//
//  Created by Reza Takhti on 3/14/19.
//

import UIKit

protocol startNewSessionDelegate{
    func userEnteredBookInfo(pageNum: Int, bookTitle: String)
}

class DuringSessionViewController: UIViewController {
    
    var delegate : startNewSessionDelegate?
    
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var pageNumberLabel: CustomLabel!
    @IBOutlet var bookTitleLabel: CustomLabel!
    @IBOutlet var currentTime: CustomLabel!
    
    var pageNumber = 0
    var bookTitle = ""
    var date = ""
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        pageNumberLabel.text = "Page Number: " + String(pageNumber)
        bookTitleLabel.text = "Book Title: " + bookTitle
        currentTime.text = date
        bookTitleLabel.lineBreakMode = .byWordWrapping
        bookTitleLabel.numberOfLines = 0
        bookTitleLabel.sizeToFit()
        // Do any additional setup after loading the view.
        let Tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
    
        
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func setBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "yellowBG")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.superview?.sendSubviewToBack(backgroundImageView)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
