//
//  SessionDetailController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 3/26/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class SessionDetailController: UIViewController {
    
    @IBOutlet weak var startPageNumberLabel: UILabel!
    @IBOutlet weak var endPageNumberLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    var selectedSession : CurrentSession?
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setBackground()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){

        if let startPageNumber = selectedSession?.startPageNumber{
            startPageNumberLabel.text = "Start Page Number: " + String(startPageNumber)
        }
        if let endPageNumber = selectedSession?.endPageNumber{
            endPageNumberLabel.text = "End Page Number: " + String(endPageNumber)
        }
        startTimeLabel.text = "Start Time: " + (selectedSession?.startTime)!
        endTimeLabel.text = "End Time: " + (selectedSession?.endTime)!
        if let summary = selectedSession?.summary {
            summaryLabel.text = "Summary: " + summary
        }
        bookTitleLabel.text = "Book Title: " + (selectedSession?.bookTitle)!
    }
    func setBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "background")
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
