//
//  Helper.swift
//  budget
//
//  Created by Azam Rahmat on 8/12/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData
import UIKit


struct  Helper {
    static var pickCategory = false
    static var categoryPicked = false
   
    
    static var pickedSubCaregory : SubCategoryTable?
    

    static var datePic : NSDate? = nil
    static var pickAccount = false
    static var accountPicked = false
    static var currency = "RS"
    static var pickedAccountData : AccountTable?
    static var bankIcon = "bank"
    
    
    static func getFormattedDate( date : NSDate ) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.stringFromDate(date)
        
    }
    static func saveChanges(context : NSManagedObjectContext, viewController : UIViewController)
    {
        do {
            try context.save()
            viewController.navigationController?.popViewControllerAnimated(true)
            
        } catch {
            print("error")
        }
    }
    
}

struct Currency {
    
    let code, displayName: String
    
    init?(code: String?) {
        if let code = code,
            displayName = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencyCode, value:code) {
            self.code = code
            self.displayName = displayName
        } else {
            return nil
        }
    }
    
}

struct CurrencyDataSource {
    
    let currencies: [Currency] = {
        // The first `map` can be replaced with `flatMap` in Swift 2.0
        // to remove the `filter` and `map` calls afterwards
        NSLocale.commonISOCurrencyCodes().map {
            return Currency(code: $0 )
            }.filter { $0 != nil }.map { $0! }
    }()
    
}

extension Float {
    var asLocaleCurrency:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(self)!
    }
}