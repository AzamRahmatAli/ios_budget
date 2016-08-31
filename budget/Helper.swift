//
//  Helper.swift
//  budget
//
//  Created by Azam Rahmat on 8/12/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData



struct  Helper {
    static var pickCategory = false
    static var categoryPicked = false
   
    
    static var pickedSubCaregory : SubCategoryTable?
    

    static var datePic : NSDate? = nil
    static var pickAccount = false
    static var accountPicked = false
    static var currency = "RS"
    static var objectIDofAccountRecord : NSManagedObjectID?
    
    
    static func getFormattedDate( date : NSDate ) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.stringFromDate(date)
        
    }

}