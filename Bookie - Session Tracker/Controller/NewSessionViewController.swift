//
//  ViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/18/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
import CoreData


class NewSessionViewController: UIViewController, UITextFieldDelegate,  startNewSessionDelegate {
    
    
    let backgroundImageView = UIImageView()
    
    @IBOutlet var bookNameTextField: CustomTextField!
    @IBOutlet var pageNumTextField: CustomTextField!
    @IBOutlet var startButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        //setting the delegate of the text field
        bookNameTextField.delegate = self
        pageNumTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        // Do any additional setup after loading the view.
        bookNameTextField.placeholder = "Book Name Here"
        pageNumTextField.placeholder = "Page Number Here"
        self.pageNumTextField.keyboardType = UIKeyboardType.numberPad
        let Tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
        
        
    }
    @IBAction func startButtonPressed(_ sender: Any) {
        
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
    
    //MARK: - TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pageNumTextField{
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
      //  NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Start New Session Delegate
    
    func userEnteredBookInfo(pageNum: Int, bookTitle: String) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startSessionClicked"{
            let destinationVC = segue.destination as! DuringSessionViewController
            destinationVC.delegate = self
            //adding in error checking and ensuring book title and start page are not empty
            if let bookTitle = bookNameTextField.text, !bookTitle.isEmpty, let pageNumber = pageNumTextField.text, !pageNumber.isEmpty{
                destinationVC.bookTitle = bookTitle
                destinationVC.pageNumber = Int(pageNumber)!
                
                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                var hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                var timeOfDay = "AM"
                var stringMinute : String = ""
                
                if(hour > 12)
                {
                    hour -= 12
                    timeOfDay = "PM"
                }
                if(minutes < 10){
                    stringMinute = "0" + String(minutes)
                } else{
                    stringMinute = String(minutes)
                }
                
                let startTime = String(year) + "-" + String(month) + "-" + String(day) + " " + String(hour) + ":" + stringMinute + timeOfDay
                destinationVC.date = startTime
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                
                let newReadingSession = CurrentSession(context: context)
                newReadingSession.bookTitle = destinationVC.bookTitle
                newReadingSession.pageNumber = Int64(destinationVC.pageNumber)
                newReadingSession.startTime = destinationVC.date
                newReadingSession.endTime = ""
                do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Book title and starting page number are required", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default)
                alert.addAction(action)
                present(alert,animated: true, completion: nil)
            }
            
           
        }
    }
    
    
}
