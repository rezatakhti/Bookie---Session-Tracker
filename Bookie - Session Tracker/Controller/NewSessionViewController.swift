//
//  ViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/18/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class NewSessionViewController: UIViewController, UITextFieldDelegate {

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
