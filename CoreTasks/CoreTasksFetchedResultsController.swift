//
//  CoreTasksFetchedResultsController.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/13/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// In here we're going to create a custom subclass of NSFetchedResultsController
class CoreTasksFetchedResultsController: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    
    
    // We're going to add a private constant to a table View which will hold a reference to the TableView since we're going to need it to update it when the content changes
    
    private let tableView: UITableView
    
    // Next we'll create a designated initializer that takes 2 arguements: a managed object context and a tableview
    
    init(managedObjectContext: NSManagedObjectContext, withTableView tableViewInit: UITableView) {
        // In here we're going to assign the tableView that we're passing into the tableView the private property we created
        self.tableView = tableViewInit
        
        // Then we'll call the classes super init method which takes a fetch request, and since we added this to the model itself to the Manage Object we can simply say item.fetchRequest
        super.init(fetchRequest: Item.fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Since we, the CoreTasksFetchedResultsController Class is going to be acting as its own delegate after the super init
        
        // We're going to assign as a delegate of the controller
        // we get an error because self the CoreTasksController tableVC does not conform to the relevant delegate protocol - add NSFetchedResultsControllerDelegate
        
        self.delegate = self
        
        // From here, to wrap up the initializer we're going to call a Try-Fetch method
        
        
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch let error as NSError {
            print("Unresolved Error: \(error), \(error.userInfo)")
        }
    }
    
    
    // We're going to put the delegate methods in here too
    
    // MARK: NSFetchedResultsControllerDelegate
    
    
    // This method notifies the receiver that the FetchedResultsController is about to start processing of one or more changes due to an add, remove, move, or update
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // We call beginUpdates anytime we want insertions, deletions and cell selections to be animated simultaneously
        tableView.beginUpdates()
    }
    
    
    // This method is called when any content is updated in the context
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // We need to use endUpdates to inform the tableView to perform these animations of the beginUpdates method
        tableView.endUpdates()
        // So when the content changes, simply go ahead and reload the TableView and it should run through all these methods again and get new data from the data source
        
    }
    
    
    // This method named controller notifies the receiver that a Fetched Object has been changed due to either an add, remove, move or update
    /* 
     This method has 5 arguements:
     -The FetchedResultsController that sent the message
     -the object in the controllersFetchedResults that changed
     -The indexPath of this object
     -The type of change
     -The new indexPath and then a destination path for the object
    */
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // What we're going to do here is switch on the type of change that occurred in the moc and ask the tableView to animate that change appropriately
        
        // We need to insert the rows into the tableView at the new index path
        // The last arguement in this delegate method gives us the new index path in which the item is inserted into the FetchedResultsController
        // The indexPaths in the FetchedResultsController match those in our tableView so we can use this as our index to insert at
        
        // Since we're using a Switch statement we need to include all types and be exhaustive
        
        switch type {
        case .Insert:
            // The arguement is optional, since we don't always have a new index path
            // For example, a delete operation won't have a new indexPath since we're removing one and not inserting
            
            // We'll unwrap the index using a guard statement
            guard let indexPath = newIndexPath else { return }
            
            // The below method takes an array of indexPaths and we can pass in our indexPath inside this array arguement
            // Most cases we use the enum .Automatic but there are others we can play with
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case .Delete:
            // We'll get the indexPath, not the new one, the indexPath of the operation where the delete occured
            guard let indexPath = indexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            // For the last two cases which is update and move, we're going to provide the same implementation so we can easily combine them
        // We're simply going to reload those specific rows that were updated or moved
        case .Update, .Move:
            guard let indexPath = indexPath else { return }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
    }

  
    
    
    
    
}

// Make sure we're creating the fetchedResultsController appropriately. 








