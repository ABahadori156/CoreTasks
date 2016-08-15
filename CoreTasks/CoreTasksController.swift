//
//  CoreTasksController.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/11/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit
import CoreData

// We have to add the NSFetchedResultsControllerDelegate as a delegate
class CoreTasksController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    
    
    // CREATING THE MOC
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    
    
        
    
    // CREATING NSFETCHRESULTSCONTROLLER
    lazy var fetchedResultsController: CoreTasksFetchedResultsController = {
        // A Fetch Results Controller takes a fetch request that specifies the entity, a sort order and OPTIONALLY a filter predicate
        // In this lazy property the next step is to create a controller - 
        // the initializer we're going to use takes a fetch request, a managed object context, a section named key path and a cache name
        
        // The section named key path is used to pre-compute information about sections
        // We include a key path on result objects that returns a section name - we won't be using this so we pass nil
        
//        let controller = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // NEW REPLACING LINE 33 with
        let controller = CoreTasksFetchedResultsController(managedObjectContext: self.managedObjectContext, withTableView: self.tableView)
        
        
        // caches allow us to avoid the overhead of always performing fetch requests, but it's complex so we're not going to do it now
        
        // Know that when passing in these objects as initializer arguements, you need to use self for other stored properties
        // Since these are lazy stored properties that will be executed sometime after the controller has been initialized, you need to indicate that using self
        
    
        
        
        
        // For example, if you get rid of self from self.fetchRequest on line 65, the compiler will complain
        return controller
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
        
    
        
    }

    // Add the ToDo item to the list in the TableView once we saved that item - which requires fetching the Item
    
    
    // MARK: - Navigation
    // We come here to configure the Detail Control in the prepare for segue method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // First check the identifier
        if segue.identifier == "showItem" {
            // Now we can configure the View Controller we're transition to so we need a reference to the Detail View Controller instance and then an index path of the selected row up so we can grab that item and pass it on
            
            // If we don't have either of these then we do else return and that'll take us out of the function
            guard let dvc = segue.destinationViewController as? DetailViewController, indexPath = tableView.indexPathForSelectedRow else { return }
            
            let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            dvc.item = item
            
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //The fetchedResultsController stores the items so we can use it
        // If there isn't a count, we'll use a nil coalescing operator (??) to indicate that if the sections property is nil and therefore count doesn't have a value we're simply going to return 0
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The fetchedResultsController can contain many sections much like a tableView can. 
        // So first we need to get the relevant section that we want to work with
        // Notice here that the data source method 'numberOfRowsinSection' contains an argument for the section
        // As the TableView is setting up its sections, in our case, the first section would be 0
        
        // It just passes a value into the data source method. 
        // Let's use this to get the relevant section out of the fetchers I was controlling
        // This is an array so we need to pass it an index [section]
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
            return section.numberOfObjects
        
        // Else if there are no sections we're just going to return 0
        // What we did here was if we can't get a section out of the fetched results controller, then we don't have any sections so we just return 0 rows
    }
    
    
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Here we enter our helper method we made
        return configureCell(cell, atIndexPath: indexPath)
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // To configure a cell, we need an item object which is easy using the FetchedResults Controller
        // The method 'objectAtIndexPath' returns an object of type any object, so we need to cast it as a class Item
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        
        // Now that we have an item, we can assign the item's text to the cell's text label and return it
        cell.textLabel?.text = item.text
        return cell
        
    }
    
    // This is the 2nd method to implement to swipe to delete, from the new data source protocol
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // This method asks the data source to do is to commit the insertion or deletion of a specified row in the TableView
        // According to the docs, if you want to enable swipe to delete, we need this method
        // When we hit the delete button after swiping, the TableView sends a message to the Data Source asking it to commit the change
        
        // After the code in the commitEditingStyle method is executed, the table view calls delete rows at IndexPath to get rid of the row and the cell as well so in this method we're going to get item or entity that we want to delete and then ask the context to get rid of it
        
        // First we need the item, so to get it we ..
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        // We're casting it to a manage object because that's what the context needs to delete an object
        managedObjectContext.deleteObject(item)
        
        // Remember that the context simply keeps track of changes - here were asking to delete something and the context tracks this but it doesn't actually delete it from the store
        
        // TO DELETE FROM THE STORE, we need to call a save data controller not a shared instance save context 
        // Here we're calling save on the shared instance of the DataController even though we have access to the context as a stored property
        // This is because we don't want to call a THROWING METHOD
        
        // By calling saveContext() on the dataController, we're handling the error inside the controller itself
        DataController.sharedInstance.saveContext()
    }
    
    
      // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        // This method asks the delegate for the style that the tableView cell should display once it goes into this editing mode
        // The method returns a value of type UITableViewCellEditingStyle which is an enum
        
        return .Delete
    }
 
    
    
}












