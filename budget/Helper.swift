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
    
    static var pickedAccountData : AccountTable?
    static var bankIcon = "bank"
    static var currency : String? = nil
    static var currencySymbol : String? = nil
    
    static let colors: [UIColor] = [UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1),UIColor(red: 254/255, green: 129/255, blue: 0, alpha: 1),UIColor(red: 50/255, green: 195/255, blue: 0, alpha: 1),UIColor(red: 255/255, green: 33/255, blue: 67/255, alpha: 1),UIColor(red: 69/255, green: 68/255, blue: 205/255, alpha: 1)]
    
    
    
    
    
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
    
    static func getLocalCurrencySymbl(currencyCode : String) -> String
    {
        let locales: NSArray = NSLocale.availableLocaleIdentifiers()
        for localeID in locales as! [NSString] {
            let locale = NSLocale(localeIdentifier: localeID as String)
                        let code = locale.objectForKey(NSLocaleCurrencyCode) as? String
            if code == currencyCode{
                print(currencyCode, localeID)

                let symbol = locale.objectForKey(NSLocaleCurrencySymbol) as? String
                print(symbol)
                return symbol!
             
            }
        }
        
        return  "$"
    }
    
    static func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
    }
    
    static let units = [
        Unit(name: "Home/Rent", image: "home",sname: ["Mortgage", "Mortgage-2nd","Rent", "Association fee", "Property tax"],simage: ["home", "home","home", "home", "home"]),
        
        Unit(name: "Utilities", image: "Utilities",sname: ["Electricity", "Gas/Heating","Telephone", "CellPhone", "Internet", "Cable/Dish", "Water", "Garbage"],simage: ["Utilities", "Gas","Telephone", "CellPhone", "Internet", "Cable", "Water", "Garbage"]),
        
        Unit(name: "Food/Groceries", image: "Food",sname: ["Groceries", "Restaurant/Fast food"], simage: ["Groceries", "Restaurant"]),
        
        Unit(name: "Departmental", image: "Departmental",sname: ["Clothing", "Personal Items", "Kids/Toys", "Books/Magazines"], simage: ["Clothing", "Departmental", "Kids", "Books"]),
        
        Unit(name: "Entertainment", image: "Entertainment",sname: ["Movies", "DVD rental", "Music"],simage: ["Movies", "DVD", "Entertainment"]),
        
        Unit(name: "Car/Auto", image: "car",sname: ["Gasoline", "Auto Loan", "Oil Change"],simage: ["car", "Auto", "Auto"]),
        
        Unit(name: "Insurance/Medical", image: "Insurance",sname: ["Insurance - Auto", "Insurance - Home", "Insurance - Medical", "Medical Expenses/Co-pay"],simage: ["Auto", "home", "Insurance", "Medical"]),
        
        Unit(name: "Misc/One-time", image: "Misc",sname: ["Air tickets", "Hotel/Lodging", "Gifts/Charity"],simage: ["Air", "Hotel", "Gifts"])
    ]
    
}

struct Unit {
    let name: String
    let image: String
    let sname: [String]
    let simage: [String]
    
    
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
        if let currencyCode = Helper.currency
        {
            /*let components = [ NSLocaleCurrencyCode : currencyCode ]
            let localeIdentifier = NSLocale.localeIdentifierFromComponents(components)
           // print(localeIdentifier)
            let localeForDefaultCurrency = NSLocale(localeIdentifier: localeIdentifier)
            //print(localeForDefaultCurrency)
            
           formatter.locale = localeForDefaultCurrency
            */
           formatter.currencyCode = currencyCode
            formatter.currencySymbol = Helper.currencySymbol
           /* let locales: NSArray = NSLocale.availableLocaleIdentifiers()
            for localeID in locales as! [NSString] {
                let locale = NSLocale(localeIdentifier: localeID as String)
                let code = locale.objectForKey(NSLocaleCurrencyCode) as? String
                if code == currencyCode {
                    let symbol = locale.objectForKey(NSLocaleCurrencySymbol) as? String
                    print(symbol!)
                    
                }
            }*/
         // formatter.currencySymbol = formatter.locale.objectForKey(NSLocaleCurrencySymbol) as? String
            //print(formatter.internationalCurrencySymbol)
            
            //formatter.locale = NSLocale(localeIdentifier: "en_US")
           
        }else
        {
        formatter.locale = NSLocale.currentLocale()
        }
        return formatter.stringFromNumber(self)!
    }
    

}
