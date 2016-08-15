//
//  DetailViewController.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/14/16.
//  Copyright © 2016 Pelican. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    // We'll give our DetailViewController a property to store an instance of the Item here
    var item: Item?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else { fatalError("Cannot show detail without an item") }
        
        // Here we display the item's text in the textField
        textField.text = item.text
    }

    // UPDATE METHOD
    @IBAction func updatedItem(sender: AnyObject) {
        
        // We do the if let item = because theres an optional property and we need to unwrap it, then we'll get the items text
        if let item = item {
            
            // After updating, we'll assume at this point that the user's changed something, so we'll grab the new text from the textField and assign that to the item and then we'll call DataController
            item.text = textField.text
            DataController.sharedInstance.saveContext()
            
            // Once when we hit save, we want to go back, so this will transition us back to the previous ViewController in the Navigation Stack
            //
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
        
    }
    



}
