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
                performSegue(withIdentifier: "goToNewSession", sender: self)
            }
            if touch.view == pastSessionsImageView{
                print("past ession view tapped")
                performSegue(withIdentifier: "goToPastSessions", sender: self)
            }
        }
    }
    
}

