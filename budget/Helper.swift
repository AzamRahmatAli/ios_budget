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
    
    static let formatter = NSNumberFormatter()
   
    static var pickedSubCaregory : SubCategoryTable?
    static var expandedAndCollapsedSectionsIncome  : [Bool] = []
    static var expandedAndCollapsedSectionsAccount : [Bool] = []
    static var expandedAndCollapsedSectionsExpense : [Bool] = []
    static var datePic : NSDate? = nil
    static var pickAccount = false
    static var accountPicked = false
    
    static var pickedAccountData : AccountTable?
    static var bankIcon = "bank"
    static var currency : String? = nil
    static var currencySymbol : String? = nil
    
    static let colors: [UIColor] = [UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1),UIColor(red: 254/255, green: 129/255, blue: 0, alpha: 1),UIColor(red: 50/255, green: 195/255, blue: 0, alpha: 1),UIColor(red: 255/255, green: 33/255, blue: 67/255, alpha: 1),UIColor(red: 69/255, green: 68/255, blue: 205/255, alpha: 1)]
    
    static var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
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
    static func addMenuButton(controller : UIViewController)
    {
    if  controller.revealViewController() != nil {
    //  menuButton.target = self.revealViewController()
    //  menuButton.action = "rightRevealToggle:"
    
    
    let myBtn: UIButton = UIButton()
    myBtn.setImage(UIImage(named: "menu"), forState: .Normal)
    myBtn.frame = CGRectMake(0, 0, 50, 50)
    myBtn.backgroundColor = UIColor.clearColor()
    // myBtn.addTarget(self, action: "rightRevealToggle:", forControlEvents: .TouchUpInside)
    myBtn.addTarget(controller.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    controller.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: myBtn), animated: true)
    
    
  
    }

    }
    
}


extension Float {
    var asLocaleCurrency:String {
        
        return Helper.formatter.stringFromNumber(self)!
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