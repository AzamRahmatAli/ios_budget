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
    
     private static var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
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
    
    static func restoreBackup(dir : NSURL)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        //if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.URLByAppendingPathComponent("datafile.txt")
            do {
                let data = NSData(contentsOfURL : path) as NSData!
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let dic = json as? [String : AnyObject]
                {
                    if let accountTypes = dic["AccountTypeTable"]
                    {
                        if let names = accountTypes as? [String]
                        {
                            for name in names{
                                
                                AccountTypeTable.accontType(name, inManagedObjectContext: managedObjectContext!)
                            }
                        }
                    }
                    
                    if let records = dic["AccountTable"]
                    {
                        if let accounts =  records  as? [[String : String]]
                        {
                            for account in accounts{
                                
                                if let entity = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: managedObjectContext!) as? AccountTable
                                {
                                    
                                    
                                    
                                    entity.amount = account["amount"]
                                    entity.icon = account["icon"]
                                    
                                    entity.name = account["name"]
                                    let dateString = account["createdat"]
                                    
                                    //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                                    let dateObj = dateFormatter.dateFromString(dateString!)
                                    print(dateObj)
                                    entity.createdAt = dateObj
                                    entity.accountType = AccountTypeTable.accontType(account["accounttype"]!, inManagedObjectContext: managedObjectContext!)
                                    
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                    if let records = dic["CategoryTable"]
                    {
                        if let data =  records  as? [[String : String]]
                        {
                            for element in data{
                                
                                if let entity = NSEntityDescription.insertNewObjectForEntityForName("CategoryTable", inManagedObjectContext: managedObjectContext!) as? CategoryTable
                                {
                                    
                                    entity.name = element["name"]
                                    entity.icon = element["icon"]
                                    
                                    
                                }
                            }
                        }
                    }
                    if let records = dic["Other"]
                    {
                        if let data =  records  as? [[String : String]]
                        {
                            for element in data{
                                
                                if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: managedObjectContext!) as? Other
                                {
                                    if element["oneBudget"]  != ""
                                    {
                                    entity.oneBudget = element["oneBudget"]
                                    }
                                   
                                    
                                    
                                }
                            }
                        }
                    }
                    if let records = dic["SubCategoryTable"]
                    {
                        if let data =  records  as? [[String : String]]
                        {
                            for element in data{
                                
                                if let entity = NSEntityDescription.insertNewObjectForEntityForName("SubCategoryTable", inManagedObjectContext: managedObjectContext!) as? SubCategoryTable
                                {
                                    
                                    entity.name = element["name"]
                                    entity.icon = element["icon"]
                                    if element["amount"] != ""
                                    {
                                        entity.amount = element["amount"]
                                    }
                                    
                                    entity.category = CategoryTable.categoryByOnlyName(element["category"]!, inManagedObjectContext: managedObjectContext!)
                                }
                            }
                        }
                    }
                    if let records = dic["IncomeTable"]
                    {
                        if let data =  records  as? [[String : String]]
                        {
                            for element in data{
                                
                                if let entity = NSEntityDescription.insertNewObjectForEntityForName("IncomeTable", inManagedObjectContext: managedObjectContext!) as? IncomeTable
                                {
                                    
                                    entity.category = element["name"]
                                    entity.note = element["note"]
                                    if element["amount"] != ""
                                    {
                                        entity.amount = element["amount"]
                                    }
                                    let dateString = element["createdat"]
                                    
                                    let dateObj = dateFormatter.dateFromString(dateString!)
                                    
                                    entity.createdAt = dateObj
                                    if element["accountname"] != ""
                                    {
                                        
                                        
                                        entity.account = AccountTable.account(element["accountname"]!, type: element["accounttype"]!, inManagedObjectContext: managedObjectContext!)
                                    }
                                }
                            }
                        }
                    }
                    if let records = dic["ExpenseTable"]
                    {
                        if let data =  records  as? [[String : String]]
                        {
                            for element in data{
                                
                                if let entity = NSEntityDescription.insertNewObjectForEntityForName("ExpenseTable", inManagedObjectContext: managedObjectContext!) as? ExpenseTable
                                {
                                    if element["reciept"] != ""
                                    {
                                        //entity.reciept = element["reciept"]
                                    }
                                    entity.note = element["note"]
                                    if element["amount"] != ""
                                    {
                                        entity.amount = element["amount"]
                                    }
                                    let dateString = element["createdat"]
                                    
                                    let dateObj = dateFormatter.dateFromString(dateString!)
                                    
                                    entity.createdAt = dateObj
                                    if element["accountname"] != ""
                                    {
                                        
                                        
                                        entity.account = AccountTable.account(element["accountname"]!, type: element["accounttype"]!, inManagedObjectContext: managedObjectContext!)
                                    }
                                    
                                    
                                    entity.subCategory = SubCategoryTable.subCategory(element["subcategory"]!, categoryName: element["category"]!, inManagedObjectContext: managedObjectContext!)
                                    
                                }
                            }
                        }
                    }
                }
                
                
                print(json)
                do {
                    try managedObjectContext!.save()
                    
                    
                } catch {
                    print("error")
                }
                
            }
            catch {/* error handling here */}
        
        
    }
    
    static func doBackup() -> String?
    {
        do{
            var fetchRequest = NSFetchRequest(entityName: "AccountTypeTable")
            
            
            
            var fetchedData : [AnyObject]? = try managedObjectContext?.executeFetchRequest(fetchRequest)
            var names : [String] = []
            
            for element in (fetchedData! as! [AccountTypeTable])
                
            {
                names.append(element.name!)
            }
            var dictionary : [String : AnyObject] = ["AccountTypeTable" : names]
            
            
            
            fetchRequest = NSFetchRequest(entityName: "CategoryTable")
            
            
            
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            var sets  = [[String:AnyObject]]()
            sets = []
            for element in (fetchedData! as! [CategoryTable])
                
            {
                sets.append(["name" :element.name!, "icon" :element.icon!])
            }
            dictionary["CategoryTable"] =  sets
            
            
            
            fetchRequest = NSFetchRequest(entityName: "AccountTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [AccountTable])
                
            {
                sets.append(["name" :element.name!, "amount" :element.amount! , "icon" :element.icon! , "createdat" : String(element.createdAt!), "accounttype": element.accountType!.name!])
            }
            dictionary["AccountTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "SubCategoryTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [SubCategoryTable])
                
            {
                sets.append(["name" :element.name!, "amount" :element.amount ?? "" , "icon" :element.icon! , "category": element.category!.name!])
            }
            dictionary["SubCategoryTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "IncomeTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [IncomeTable])
                
            {
                sets.append(["name" :element.category!, "amount" :element.amount! , "note" :element.note! , "createdat" : String(element.createdAt!), "accountname" : element.account?.name ?? "", "accounttype" : element.account?.accountType?.name ?? ""])
            }
            dictionary["IncomeTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "ExpenseTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [ExpenseTable])
                
            {
                var a : [String : AnyObject] = ["amount" :element.amount! , "note" :element.note!, "reciept" :/*element.reciept ??*/ "", "createdat" : String(element.createdAt!)]
                a["accountname"] = element.account?.name ?? ""
                a["accounttype"] =  element.account?.accountType?.name ?? ""
                a["subcategory"] = element.subCategory!.name!
                a["category"] = element.subCategory!.category!.name!
                sets.append(a)
                
            }
            dictionary["ExpenseTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "Other")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [Other])
                
            {
                sets.append(["oneBudget" :element.oneBudget ?? ""])
                
            }
            dictionary["Other"] =  sets
            
            /*let dataInArr:NSArray = ManagedParser.convertToArray(fetchedGuest);
             NSLog("dataInArr \(dataInArr)");*/
            
            
            let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            let cdata = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            // print(cdata)
            /*if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.txt")
                /*if let file = NSFileHandle(forWritingAtPath:"datafile.txt") {
                 file.writeData(jsonData)
                 }*/
                //writing
                do {
                    try cdata.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                    
                }
                catch {/* error handling here */}
            }*/
            
            return cdata
            // let myEntities : [String] = Array(objectModel!.entitiesByName.keys)
            // print(myEntities)
            
        }
        catch let error {
            print("error : ", error)
        }
        return nil
    }
    
    
    static func clearCoreDataStore(dir : NSURL) {
        let objectModel : NSManagedObjectModel? =  (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectModel
        
        let entities = objectModel!.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest(entityName: entity.name!)
            let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext!.executeRequest(deleteReqest)
                
            } catch {
                print(error)
            }
            
        }
        do {
            try managedObjectContext!.save()
            restoreBackup(dir)
            
            
        } catch {
            print("error")
        }
    }
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



/*

class CloudDataManager {
    
    static let sharedInstance = CloudDataManager() // Singleton
    
    struct DocumentsDirectory {
        static let localDocumentsURL: NSURL? = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        static let iCloudDocumentsURL: NSURL? = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
        
    }
    
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> NSURL {
        print(DocumentsDirectory.iCloudDocumentsURL)
        print(DocumentsDirectory.localDocumentsURL)
            return DocumentsDirectory.localDocumentsURL!//DocumentsDirectory.iCloudDocumentsURL!
        
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    // Delete All files at URL
    
    func deleteFilesInDirectory(url: NSURL?) {
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtPath(url!.path!)
        while let file = enumerator?.nextObject() as? String {
            
            do {
                try fileManager.removeItemAtURL(url!.URLByAppendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
    // Move local files to iCloud
    // iCloud will be cleared before any operation
    // No data merging
    
    func moveFileToCloud() {
        if isCloudEnabled() {
            deleteFilesInDirectory(DocumentsDirectory.iCloudDocumentsURL!) // Clear destination
            let fileManager = NSFileManager.defaultManager()
            let enumerator = fileManager.enumeratorAtPath(DocumentsDirectory.localDocumentsURL!.path!)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.setUbiquitous(true,
                                                  itemAtURL: DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(file),
                                                  destinationURL: DocumentsDirectory.iCloudDocumentsURL!.URLByAppendingPathComponent(file))
                    print("Moved to iCloud")
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                }
            }
        }
    }
    
    // Move iCloud files to local directory
    // Local dir will be cleared
    // No data merging
    
    func moveFileToLocal() {
        
            deleteFilesInDirectory(DocumentsDirectory.localDocumentsURL!)
            let fileManager = NSFileManager.defaultManager()
            let enumerator = fileManager.enumeratorAtPath(DocumentsDirectory.iCloudDocumentsURL!.path!)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.setUbiquitous(false,
                                                  itemAtURL: DocumentsDirectory.iCloudDocumentsURL!.URLByAppendingPathComponent(file),
                                                  destinationURL: DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(file))
                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    
    
    
    
}
*/