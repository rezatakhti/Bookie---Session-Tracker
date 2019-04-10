//
//  CoreDataManager.swift
//  Singleton Core Data Manager
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 4/9/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    static let sharedManager = CoreDataManager()
    lazy var context = persistentContainer.viewContext
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveItems() {
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    func loadItems(with request: NSFetchRequest<CurrentSession> = CurrentSession.fetchRequest()) -> [CurrentSession]{
        var sessionsArray = [CurrentSession]()
        
        do {
            sessionsArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        return sessionsArray
    }
}
