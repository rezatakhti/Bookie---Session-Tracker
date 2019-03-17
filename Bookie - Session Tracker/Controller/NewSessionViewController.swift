//
//  ViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/18/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit



class NewSessionViewController: UIViewController, UITextFieldDelegate,  startNewSessionDelegate {
    
    
    let backgroundImageView = UIImageView()
    
    @IBOutlet var bookNameTextField: CustomTextField!
    @IBOutlet var pageNumTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        //setting the delegate of the text field
        bookNameTextField.delegate = self
        pageNumTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        
        // Do any additional setup after loading the view.
        bookNameTextField.placeholder = "Book Name Here"
        pageNumTextField.placeholder = "Page Number Here"
        self.pageNumTextField.keyboardType = UIKeyboardType.numberPad
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
    
    //MARK: - TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pageNumTextField{
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //
    //        UIView.animate(withDuration: 0.5) {
    //            self.view.frame.origin.y = -28
    //            self.view.layoutIfNeeded()
    //        }
    //    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1) {
            self.view.frame.origin.y =  -keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Start New Session Delegate
    
    func userEnteredBookInfo(pageNum: Int, bookTitle: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startSessionClicked"{
            let destinationVC = segue.destination as! DuringSessionViewController
            destinationVC.delegate = self
            destinationVC.bookTitle = bookNameTextField.text!
            destinationVC.pageNumber = Int(pageNumTextField.text!)!
            
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            var hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            var timeOfDay = "AM"
            
            if(hour > 12)
            {
                hour -= 12
                timeOfDay = "PM"
            }
            
            destinationVC.date = String(year) + "-" + String(month) + "-" + String(day) + " " + String(hour) + ":" + String(minutes) + timeOfDay
        }
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
