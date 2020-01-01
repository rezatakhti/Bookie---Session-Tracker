//
//  PastSessionsTableViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 2/18/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
import SwipeCellKit

class PastSessionsTableViewController: UITableViewController {
    
    var pastSessionsArray = [CurrentSession]()
    var selectedSessions = [IndexPath : CurrentSession]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        pastSessionsArray = CoreDataManager.sharedManager.loadItems()
        tableView.reloadData()
        tableView.rowHeight = 100.0
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        if #available(iOS 13.0, *){
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = UIColor.flatLime()
            navBarAppearance.titleTextAttributes = [ .foregroundColor : UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [ .foregroundColor : UIColor.white]
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.backgroundColor = UIColor.flatGray()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    @IBAction func trashButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete these sessions?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Yes", style: .default, handler: { action in
            for session in self.selectedSessions.reversed() {
                CoreDataManager.sharedManager.context.delete(session.value)
                CoreDataManager.sharedManager.saveItems()
            }
            self.pastSessionsArray = CoreDataManager.sharedManager.loadItems()
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastSessionsArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        //if currently in session we do not want to display current session as past session
        let isInSession = defaults.bool(forKey: "isInSession")
        if(isInSession && indexPath.row == pastSessionsArray.count - 1)
        {
            rowHeight = 0.0
        } else {
            rowHeight = 100.0
        }
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionsCell", for: indexPath) as! SessionsCell
        let isInSession = defaults.bool(forKey: "isInSession")
        //if currently in session we do not want to display current session as past session
        if(isInSession && indexPath.row == pastSessionsArray.count - 1){
            cell.isHidden = true
        }
        else{
            cell.isHidden = false
        }
        
        cell.delegate = self
        let session = pastSessionsArray[indexPath.row]
        cell.sessionLabel.text = session.bookTitle
        cell.sessionLabel.textColor = UIColor.white
        cell.dateLabel.text = session.startTime
        cell.dateLabel.textColor = UIColor.white
        
        return cell
        
    }
    
    // MARK: - Data Model Manipulation Methods
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.isEditing == false{
            performSegue(withIdentifier: "goToSession", sender: self)
        } else {
            let selectedSession = pastSessionsArray[indexPath.row]
            selectedSessions[indexPath] = selectedSession
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.tableView.isEditing == true{
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
    
}

extension PastSessionsTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this session?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                CoreDataManager.sharedManager.context.delete(self.pastSessionsArray[indexPath.row])
                self.pastSessionsArray.remove(at: indexPath.row)
                CoreDataManager.sharedManager.saveItems()
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
