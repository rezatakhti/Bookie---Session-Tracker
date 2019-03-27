//
//  DuringSessionViewController.swift
//  
//
//  Created by Reza Takhti on 3/14/19.
//

import UIKit
import CoreData

protocol startNewSessionDelegate{
    func userEnteredBookInfo(pageNum: Int, bookTitle: String)
}

class DuringSessionViewController: UIViewController {
    var delegate : startNewSessionDelegate?
    var currentSessionArray = [CurrentSession]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var pageNumberLabel: CustomLabel!
    @IBOutlet var bookTitleLabel: CustomLabel!
    @IBOutlet var currentTime: CustomLabel!
    
    var pageNumber = 0
    var bookTitle = ""
    var date = ""
    
    let backgroundImageView = UIImageView()
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        //loading item with matching date in order to add end date and optional summary
        let request : NSFetchRequest<CurrentSession> = CurrentSession.fetchRequest()
        let predicate = NSPredicate(format: "startTime MATCHES %@", date)
        request.predicate = predicate
        loadItems(with: request)
        
        let currentSession = currentSessionArray[0]
        if let summaryText = summaryTextView.text {
            currentSession.summary = summaryText
        }
        currentSession.endTime = getCurrentTime()
        saveItems()
        
        let alert = UIAlertController(title: "Save Complete", message: "Reading Session has been recorded.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        pageNumberLabel.text = "Page Number: " + String(pageNumber)
        bookTitleLabel.text = "Book Title: " + bookTitle
        currentTime.text = "Start Time: " + date
        bookTitleLabel.lineBreakMode = .byWordWrapping
        bookTitleLabel.numberOfLines = 0
        bookTitleLabel.sizeToFit()
        //move the textview up so we can type and see what we're typing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        // Do any additional setup after loading the view.
        let Tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
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
    
    func getCurrentTime() -> String {
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
        
        return String(year) + "-" + String(month) + "-" + String(day) + " " + String(hour) + ":" + stringMinute + timeOfDay
    }
    
    // MARK - Model Manipulation Methods
    
    func loadItems(with request: NSFetchRequest<CurrentSession> = CurrentSession.fetchRequest()){
        
        do {
            currentSessionArray = try context.fetch(request)
            print("sucess reading")
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
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
