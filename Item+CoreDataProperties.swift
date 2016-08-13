//
//  Item+CoreDataProperties.swift
//  CoreTasks
//
//  Created by Pasha Bahadori on 8/11/16.
//  Copyright © 2016 Pelican. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var text: String?
    @NSManaged var completed: Bool

}
