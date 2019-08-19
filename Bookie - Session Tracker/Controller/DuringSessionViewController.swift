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

class DuringSessionViewController: UIViewController, UITextFieldDelegate{
    
    var delegate : startNewSessionDelegate?
    var currentSessionArray = [CurrentSession]()
    var currentSession : CurrentSession?
    let defaults = UserDefaults.standard
    let isInSession = UserDefaults.standard.bool(forKey: "isInSession")
    var pageNumber = 0
    var bookTitle = ""
    var date = ""
    
    
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var pageNumberLabel: CustomLabel!
    @IBOutlet var bookTitleLabel: CustomLabel!
    @IBOutlet var currentTime: CustomLabel!
    @IBOutlet weak var endPageNumberTextField: CustomTextField!
    
    
    let backgroundImageView = UIImageView()
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
     
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel? This will delete your current session.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: alertHandler)
        let action2 = UIAlertAction(title: "No", style: .default, handler:  alertHandler)
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert,animated: true, completion: nil)
        
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
       
        //loading item with matching date in order to add end date and optional summary
        loadCurrentSession()
        if let summaryText = summaryTextView.text {
            currentSession!.summary = summaryText
        }
        currentSession!.endTime = getCurrentTime()
        if currentSession!.endTime == currentSession!.startTime {
            let alert = UIAlertController(title: "Error", message: "Session must be longer than a minute", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(action)
            present(alert,animated: true, completion: nil)

        } else {
            if let endPageNum = endPageNumberTextField.text, !endPageNum.isEmpty{
                currentSession!.endPageNumber = Int64(endPageNum)!
                self.navigationController?.popToRootViewController(animated: true)
                 defaults.set(false, forKey: "isInSession") // if app closes no longer needs to open up in duringSessionViewController
            }
            else{
                let alert = UIAlertController(title: "Error", message: "End page number cannot be empty", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default)
                alert.addAction(action)
                present(alert,animated: true, completion: nil)
            }
        }
        
        CoreDataManager.sharedManager.saveItems()
       
        let alert = UIAlertController(title: "Save Complete", message: "Reading Session has been recorded.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == endPageNumberTextField{
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if (self.isMovingFromParent)
//        {
//            let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel?", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Yes", style: .default)
//           // let action2 = UIAlertAction(title: "No", style: .default)
//            alert.addAction(action)
//           // alert.addAction(action2)
//            self.present(alert,animated: true, completion: nil)
//            print("hipota444444to")
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        loadDataIntoView()
        
        bookTitleLabel.lineBreakMode = .byWordWrapping
        bookTitleLabel.numberOfLines = 0
        bookTitleLabel.sizeToFit()
        endPageNumberTextField.delegate = self
        endPageNumberTextField.placeholder = "End Page Number Here"
        self.endPageNumberTextField.keyboardType = UIKeyboardType.numberPad
        
        //move the textview up so we can type and see what we're typing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        // Do any additional setup after loading the view.
        let Tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        if let rootVC = navigationController?.viewControllers.first{
            navigationController?.viewControllers = [rootVC, self]
        }
        
    }
    
    
    
    func loadDataIntoView(){
        if isInSession{
            loadCurrentSession()
            if let pageNumber = currentSession?.startPageNumber {
                pageNumberLabel.text = "Page Number: " + String(pageNumber)
            }
            bookTitleLabel.text = "Book Title: " + currentSession!.bookTitle!
            currentTime.text = "Start Time: " + currentSession!.startTime!
        } else {
            pageNumberLabel.text = "Page Number: " + String(pageNumber)
            bookTitleLabel.text = "Book Title: " + bookTitle
            currentTime.text = "Start Time: " + date
        }
    }
    
    @objc func cancelButtonAction(_ sender: UIBarButtonItem){
      
    }
    
    func alertHandler(alert: UIAlertAction){
        if alert.title == "Yes"
        {
            //delete the current session if cancelled
            loadCurrentSession()
            CoreDataManager.sharedManager.context.delete(currentSession!)
            CoreDataManager.sharedManager.saveItems()
            defaults.set(false, forKey: "isInSession") // if app closes no longer needs to open up in duringSessionViewController

            //go back to previous controller
            self.navigationController?.popToRootViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
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
        
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
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
    
    func loadCurrentSession(){
        
        if !isInSession{
        let request : NSFetchRequest<CurrentSession> = CurrentSession.fetchRequest()
        let predicate = NSPredicate(format: "startTime MATCHES %@", date)
        request.predicate = predicate
        currentSessionArray =  CoreDataManager.sharedManager.loadItems(with: request)
        
        currentSession = currentSessionArray[0]
        } else {
            currentSessionArray = CoreDataManager.sharedManager.loadItems()
            let arrayIndex = currentSessionArray.count - 1
            currentSession = currentSessionArray[arrayIndex]
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
