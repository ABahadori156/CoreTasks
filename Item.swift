//
//  Item.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/11/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {
    
    // We put this static identifier called "Item" so we don't have to keep retyping the NSEntityDescription instance string "Item" over and over
    static let identifier = "Item"

// Insert code here to add functionality to your managed object subclass
    // We can even make this a static variable so it can be accessed without an instance by changing lazy var on line 21 to static let
    
    static let fetchRequest: NSFetchRequest = {
        
        // CREATING FETCH REQUEST
        // fetchRequest is going to be of type NSFetchRequest and as always, we're going to assign an executing closure
        // An NSFetchRequest class is initialized with an entity
        
        // This fetch request is for Items and can only be used to fetch Items which means that instead of having it as a variable of the tableView controller we can make it part of the Manage object

            
            //The identifier property of Item was made in Item.swift
            let request = NSFetchRequest(entityName: Item.identifier)
            // Notice that whatever operation we undertake whether it's inserting or fetching, we need to specify the entity name as a string for the NSEntityDescription instance
            
            // Our Item entity isn't that complex and there really isn't a predicate that we can include right now but just so that we can get some idea of how we can fine-tune a Fetch Request, let's add a sort descriptor
            
            // A Fetch Request has a setupable property, sortDescriptors, that takes an array of sort descriptors to order our entities
            // Let's order them in ascending order of their text attribute
            
            // First we create the sort descriptor
            // We order it by the text property and I'll set true for the ascending value
            let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
            
            // we pass in the array of sort descriptors so all we have is this one for now
            request.sortDescriptors = [sortDescriptor]
            
            return request
            
        }()

}
