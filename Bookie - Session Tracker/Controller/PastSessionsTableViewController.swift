//
//  PastSessionsTableViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/18/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class PastSessionsTableViewController: UITableViewController {
    
    var pastSessionsArray = [CurrentSession]()
    var selectedSessions = [IndexPath : CurrentSession]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.rowHeight = 100.0
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
        self.navigationItem.rightBarButtonItem = editButton
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func trashButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete these sessions?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Yes", style: .default, handler: { action in
            for session in self.selectedSessions.reversed() {
                self.context.delete(session.value)
                self.saveItems()
            }
            self.loadItems()
            self.tableView.reloadData()
        })
        
        let action2 = UIAlertAction(title: "No", style: .default, handler:  nil)
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert,animated: true, completion: nil)
        
        navigationController?.setToolbarHidden(true, animated: true)
        self.tableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.title = "Edit"
    }
    
    @objc func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableView.isEditing == true)
        {
            navigationController?.setToolbarHidden(true, animated: true)
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            selectedSessions.removeAll()
        }
        else
        {
            navigationController?.setToolbarHidden(false, animated: true)
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastSessionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionsCell", for: indexPath) as! SessionsCell
        cell.delegate = self
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
        if self.tableView.isEditing == false{
            performSegue(withIdentifier: "goToSession", sender: self)
        } else {
            let selectedSession = pastSessionsArray[indexPath.row]
            print(selectedSession.startTime)
            print(indexPath.row)
            selectedSessions[indexPath] = selectedSession
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.tableView.isEditing == true{
            print(selectedSessions[indexPath]?.startTime)
            print(indexPath.row)
            selectedSessions[indexPath] = nil
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SessionDetailController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedSession = pastSessionsArray[indexPath.row]
        }
    }
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}

extension PastSessionsTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this session?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                self.context.delete(self.pastSessionsArray[indexPath.row])
                self.pastSessionsArray.remove(at: indexPath.row)
                self.saveItems()
                tableView.reloadData()
            })
            
            let action2 = UIAlertAction(title: "No", style: .default, handler:  nil)
            alert.addAction(action)
            alert.addAction(action2)
            self.present(alert,animated: true, completion: nil)
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
}
