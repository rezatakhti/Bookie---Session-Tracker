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
    
    var pastSessionArray = [CurrentSession]()
    let backgroundImageView = UIImageView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    @IBOutlet var bookNameTextField: CustomTextField!
    @IBOutlet var pageNumTextField: CustomTextField!
    @IBOutlet var startButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        loadTextField()
        //setting the delegate of the text field
        bookNameTextField.delegate = self
        pageNumTextField.delegate = self
        self.pageNumTextField.keyboardType = UIKeyboardType.numberPad
        let Tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
        
        
    }
    @IBAction func startButtonPressed(_ sender: Any) {
        
    }
    
    func loadTextField(){
        loadItems()
        if pastSessionArray.count == 0 {
            bookNameTextField.placeholder = "Book Name Here"
            pageNumTextField.placeholder = "Page Number Here"
        } else {
            let lastIndex = pastSessionArray.count - 1
            bookNameTextField.text = pastSessionArray[lastIndex].bookTitle
            pageNumTextField.text = String(pastSessionArray[lastIndex].endPageNumber)
        }
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
                
                //setting user defaults so if app closes app will open up at the right page
                defaults.set(true, forKey: "isInSession")
                
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
                newReadingSession.startPageNumber = Int64(destinationVC.pageNumber)
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
    
    //MARK: - Data Model Manipulation Methods
    
    func loadItems(){
        let request : NSFetchRequest<CurrentSession> = CurrentSession.fetchRequest()
        do {
            pastSessionArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
    }
    
    
}
