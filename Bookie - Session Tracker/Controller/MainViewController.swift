//
//  ViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/13/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var newSessionImageView: UIImageView!
    @IBOutlet weak var pastSessionsImageView: UIImageView!
    @IBOutlet weak var newSessionButton: UILabel!
    
    let defaults = UserDefaults.standard
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view, typically from a nib.
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.imageTapped(gesture:)))
//        newSessionImageView.addGestureRecognizer(tapGesture)
        newSessionImageView.isUserInteractionEnabled = true
        
//        pastSessionsImageView.addGestureRecognizer(tapGesture)
        pastSessionsImageView.isUserInteractionEnabled = true
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let isInSession = defaults.bool(forKey: "isInSession")
        if(isInSession){
            newSessionButton.text = "Current Session"
        }else{
            newSessionButton.text = "New Session"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    @objc func imageTapped(gesture: UIGestureRecognizer){
//        // if the tapped view is a UIImageView then set it to imageview
//        if(gesture.view as? UIImageView) != nil{
//            print("Image Tapped")
//            //Here you can initiate your new ViewController
//        }
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if touch.view == newSessionImageView{
                print("new session view tapped")
                
                let isInSession = defaults.bool(forKey: "isInSession")
                if (isInSession){
                    performSegue(withIdentifier: "goToCurrentSession", sender: self)
                }else {
                    performSegue(withIdentifier: "goToNewSession", sender: self)
                }
                
            }
            if touch.view == pastSessionsImageView{
                print("past ession view tapped")
                performSegue(withIdentifier: "goToPastSessions", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

