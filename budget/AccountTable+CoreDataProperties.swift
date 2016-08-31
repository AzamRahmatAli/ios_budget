//
//  AccountTable+CoreDataProperties.swift
//  budget
//
//  Created by Azam Rahmat on 8/31/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AccountTable {

    @NSManaged var amount: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var icon: String?
    @NSManaged var name: String?
    @NSManaged var accountType: AccountTypeTable?
    @NSManaged var expense: NSSet?
    @NSManaged var income: NSSet?

}
