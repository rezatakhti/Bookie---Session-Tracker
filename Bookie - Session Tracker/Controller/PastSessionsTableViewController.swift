//
//  PastSessionsTableViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/18/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
import CoreData

class PastSessionsTableViewController: UITableViewController {

    var pastSessionsArray = [CurrentSession]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastSessionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionsCell", for: indexPath) as! SessionsCell
        let session = pastSessionsArray[indexPath.row]
        cell.sessionLabel.text = session.startTime
        return cell
    }

    // MARK: - Data Model Manipulation Methods
    
    func loadItems(with request: NSFetchRequest<CurrentSession> = CurrentSession.fetchRequest()){
        do{
            pastSessionsArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSession", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SessionDetailController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedSession = pastSessionsArray[indexPath.row]
        }
    }
    

}
