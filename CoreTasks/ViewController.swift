//
//  ViewController.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/10/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    let dataController = DataController.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: AnyObject) {
        // Method to dismiss current View Controller
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save(sender: AnyObject) {
        // First let's make sure there is actually text in this text field
        guard let text = textField.text else { return }
        
        // Now we create an instance of Item. Rather than directly creating an instance however, we need to insert a new object pertaining to a Core Data entity into the ManagedObjectContext, and then use that object as our instance
        
        // Remember that all Managed Object Models need to be registered with a context, and this is how we do it
        // Secondly we need to specify a ManagedObjectContext for inManagedObjectContext
        
        // We don't have access to managedObjectContext here
        // So we're going to add an instance of our DataControlelr as a stored property to the view controller LINE 14
        // dataController is our Core Data stack and we call it's managedObjectContext property to insert
        
        // This creates an instance of Item, inserts it into the ManagedObjectContext and then returns that instance for us to use
        // It returns it as an instance of NSManagedObject, but we need it as an instance of Item, so let's cast it to the specific subclass
        let item = NSEntityDescription.insertNewObjectForEntityForName(Item.identifier, inManagedObjectContext: dataController.managedObjectContext) as! Item
        
        // Now that we have an instance of Item, we can assign the text from the text Field to the instance
        // Since the instance of item is registered with the context, it keeps track of this change
        // Since the text property on Item is an NSManagedProperty, the storage is also handled by Core Data
        item.text = text
        
        // The ManagedObjectCONTEXT is a scratchpad - so far these changes have only happened in memory
        // THe MOC just took note that we've assigned some text to a new object
        // Nothing has been saved - Good because we don't want every minor change happening the second we make it
        
        // To persist data, we need to call a save method
        // Before we do this, we need to write out our save method as a part of our Data Controller
        
        dataController.saveContext()
        
        
         dismissViewControllerAnimated(true, completion: nil)
    }
}

// Once we've typed out some text in a text field, we're going to call save