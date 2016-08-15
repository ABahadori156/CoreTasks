//
//  CoreDataStack.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/10/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import Foundation
import CoreData

// We said that the model layer is persisted or saved to the SQLlite database somewhere in the apps file system

// First thing we need to do is create that location in the file system where our database is going to be stored

// Let's create a class as a Core Data Object - We'll encapsulate all the functionality in that class

public class DataController: NSObject {
    // CREATING A SINGLETON
    
    static let sharedInstance = DataController()
    // Let's make it so we prevent people from creating an instance using the init method
    // We'll override and make it private
    
    private override init() {}
    // Now whenever we want an instance of DataController, we simple call DataController.sharedInstance
    
    
    
    // DOCUMENTS DIRECTORY
    // Let's create a lazy stored property that maintains a reference to this location on disk via a URL
    // NSURL stores any type of URL, including the one that refers to a location on disk
    
    // To this lazy property, we're going to assign a closure that is immediately executed the moment we use this property
    private lazy var applicationDocumentsDirectory: NSURL = {
        
        // Using NSFileManager, we're going to retrieve an array of URLs that specify the location of the documents directory
        // This gives us the default file manager that manages the file system of our app
        
         // From here we ask for the URLs using the URLsForDirectory method
        
        // 1st arguement in the URLsForDirectory method is NSSearchPathDirectory - which is an enum encapsulating all the different directories. We type in .DocumentDirectory since we want the document directory
        
        // 2nd arguement is a domainMask. This instructs the FileManager in which file system to look for the specified directory
        // .UserDomainMask means that we're looking in the user's home directory inside of this App
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // The method above returns an array of urls
        // The directories in the array are ordered according to the order of the domain mass constance, with items in the user domain first, and items in the system domain last
       
        // The URL we specifically want is at the very last position of the array so for the index we use endIndex.predecessor() which basically
        // endIndex returns an index value past the highest value subscript
        // This means that if your array has 5 items, the highest valid subscript or index is 4
        // Since endIndex returns a value just past the highest value, so 5 since it's one past 4
        // WE NEED ONE LESS THAN THE ENDINDEX so we put call the predecessor method on endIndex to get the value one less than that, which is the last index
        // This is the same as doing array.count minus one
        
        // STEP 1: We have a place to store our database
        return urls[urls.endIndex.predecessor()]
    }()
    
    // MANAGED OBJECT MODEL
    // We're going to create the Managed Object Model as a lazy stored property with an immediately executed closure just like before
   private lazy var managedObjectModel: NSManagedObjectModel = {
        // Since we'll be creating the Managed Object Model using an editor, we can initialize the ManagedObjectModel in code from a file
        // 1. We'll need a URL for the file that we're going to initialize with - We're going to use the NSBundle class to find the URL for a resource in the main bundle
    
    // The CoreTasks.momd file is our MANAGED OBJECT MODEL which is our OBJECT GRAPH LAYER
    // Our Managed Object Model is loaded from this CoreTasks.momd file
        let modelURL = NSBundle.mainBundle().URLForResource("CoreTasks", withExtension: "momd")!
        
        // 2. Let's create and return a Managed Object Model

        return NSManagedObjectModel(contentsOfURL: modelURL)!
             // For these we're using the force unwrap ! operator to unwrap the optional value that's returned. We actually do want the program to crash if we can't load our Manage Object Model
        // The Managed Object Model is not an optional property and if we can't find and load the model from the file, then none of this is going to work
        
        // When we use the DataController in the rest of our app, we don't want anyone touching the application documents directory, the Managed Object Model and so on so we put PRIVATE infront of them
        
        
    }()
    // STEP 3 CREATE THE PERSISTENT STORE COORDINATOR
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // since the coordinator communicates between the managed object model and the persistent store, we need to hook all of them up
        // 1st create the coordinator by initializing it with a managed object model
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Now we have a coordinator that is hooked up and aware of our Managed object Model
        // next the coordinator needs to know about where we're going to save data - the persistent store.
        // We haven't specified where we want to save the data yet
        
        // To specify we need a location which we're going to define as a URL
        // We'll use the Application Documents Directory URL that we created earlier and append a path component to that to specify the location of a SQLite file
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CoreTasks.sqlite")
        // Using this URL we can now ask Core Data to create a persistent store for us when it launches for the 1st time
        // The method to do this is to create a persistent store which is known as a Throwing Method
        // So we need to wrap it in a Do-Catch statement
        
        
        do {
            // The method we're going to use is called addPersistentStoreWithType and takes a type of persistent store that we want to add
            // We want a SQLlite Database, so we're going to pass in NSSQLliteStoreType
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            // Now if this works, this line of code executes correctly without throwing an error then we have a coordinator with an associated managed object model as well as a persistent store in the form of a SQLlite database saved in the AppsDocument Directory
            
            // Now if this doesn't work and an error is thrown, we need to provide some error handling code so that we know what went wrong
            
        } catch {
            // In a catch statement like this, the error is automatically bound to a local constant named error.
            let userInfo: [String: AnyObject] = [
                NSLocalizedDescriptionKey: "Failed to initialize the application's saved data",
                NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the application's saved data",
                NSUnderlyingErrorKey: error as NSError
           ]
            // Now we can use that to create an instance of NSError
            let wrappedError = NSError(domain: "com.Pelican.CoreDataError", code: 9999, userInfo: userInfo)
            print("Unresolved Error \(wrappedError), \(wrappedError.userInfo)")
            
            // Now at this point when we ship the app to actual users, we need to do something real with our error handling code, but for development purposes, we're just going to create this wrapper error, and log it and then terminate the app
            // We terminate the app by calling abort()
            abort()
        }
        
        
        
        // But before we do that and forget, we need to return the coordinator that we created
        // So lets use that to define some simple logic
        return coordinator;
        
        
    }()
    // CREATING OUR MANAGED OBJECT CONTEXT
    // It's giving an issue to making your variable public TO FIX MAKE THE WHOLE DATACONTROLLER CLASS PUBLIC
    public lazy var managedObjectContext: NSManagedObjectContext = {
        // 1. Assign the persistent store coordinator to a local constant
        let coordinator = self.persistentStoreCoordinator
        
        //2. We're going to create an instance of NSManagedObjectContext
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        // Remember that the context needs to communicate with the Persistent Store Coordinator
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    // CREATING OUR SAVE METHOD
    // We're going to add a single public method to the Data Controller class
    public func saveContext() {
        // We don't always want to save because saving is actually an expensive operation, particularly if we have complex saves to perform
        // Remember that we're saving to a location on disc, so we need to perform a write everytime we call save
        // To reduce the burden of this operation, we'll only call Save if there are actual changes that need to be saved
        
        if managedObjectContext.hasChanges {
            // There are changes that need to be saved so we're going to try and save them
            // When there is an operation that involves the disc in some way, things can go wrong, so this is going to be a THROWING METHOD
            // THROWING METHOD: wrap function involving disc with a do-catch statement
            do {
                // Here we're calling save on the context
                // Because the context communicates with the persistentStoreCoordinator and with the Persistent Store, Core Data drives the save operation from there
               
                try managedObjectContext.save()
                
                 // All we have to do is handle the error
            } catch let error as NSError{
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

// Now we can call save when we tap on the Save Button after adding our text
// Before that, right now every time we create an instance of Data Controller to access the ManagedObjectContext, we get a different instance 
// and thereby a different instance of the ManagedObjectContext

// ** We want the same context throughout our entire app
// One way we cn do this is to create an instance at the initial point of usage, and then pass that instance or the context around to each View Controller where we need it

// This pattern is called "Dependency Injection" and is very useful. 
// We can create an instance of the Data Controller in the TableView Controller, and then in a prepare for segue method, assign it to a property 
// of the Detail View Controller to use that for saving

// Option #2 is a Singleton
// A Singleton is an object creation design pattern whereby we always return the same instance when we instantiate a class
// Core Data Stacks out there in the real world tend to have Singleton Objects.













