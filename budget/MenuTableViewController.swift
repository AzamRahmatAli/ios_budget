//
//  MenuTableViewController.swift
//  H&H
//
//  Created by Azad on 19/03/2016.
//  Copyright © 2016 Azad. All rights reserved.
//

import UIKit
import CoreData



class MenuTableViewController: UITableViewController {

    @IBOutlet weak var cellAsButton: UIButton!
    
    func coreDataCleared()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.json")
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

    }
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      cellAsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
       
        if(indexPath.row == 0)
        {
            
            
        }
      
        
        if(indexPath.row == 1)
        {
            
            
        }
        if(indexPath.row == 2)
        {
        
        cell.detailTextLabel?.text = "PKR"
        }
        return cell
    }*/
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0)
        {
            clearCoreDataStore()
                   }
        else if(indexPath.row == 2)
        {
            Helper.performUIUpdatesOnMain
                {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("currency") as! UINavigationController
            self.presentViewController(nextViewController, animated:true, completion:nil)
           
            }
        }
        else if(indexPath.row == 3)
        {
            Helper.performUIUpdatesOnMain
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("emailBackup") as! UINavigationController
                    self.presentViewController(nextViewController, animated:true, completion:nil)
                    
            }

            
            
            
        }
        }
        
    
      
    
    
    func clearCoreDataStore() {
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
            coreDataCleared()
            
        } catch {
            print("error")
        }
    }
   
   
    }
/*
class ManagedParser: NSObject {
    static  var parsedObjs:NSMutableSet = NSMutableSet();
    
    class func convertToArray(managedObjects:NSArray?, parentNode:String? = nil) -> NSArray {
        let rtnArr:NSMutableArray = NSMutableArray();
        //--
        if let managedObjs:[NSManagedObject] = managedObjects as? [NSManagedObject] {
            for managedObject:NSManagedObject in managedObjs {
                if self.parsedObjs.member(managedObject) == nil {
                    self.parsedObjs.addObject(managedObject);
                    rtnArr.addObject(self.convertToDictionary(managedObject, parentNode: parentNode));
                }
            }
        }
        
        return rtnArr;
    } //F.E.
    
    class func convertToDictionary(managedObject:NSManagedObject, parentNode:String? = nil) -> NSDictionary {
        let rtnDict:NSMutableDictionary = NSMutableDictionary();
        //-
        let entity:NSEntityDescription = managedObject.entity;
        let properties:[String] = (entity.propertiesByName as NSDictionary).allKeys as? [String] ?? [];
        //--
        let parentNode:String = parentNode ?? managedObject.entity.name!;
        for property:String in properties  {
            if (property.caseInsensitiveCompare(parentNode) != NSComparisonResult.OrderedSame)
            {
                let value: AnyObject? = managedObject.valueForKey(property);
                //--
                if let set:NSSet = value as? NSSet {
                    rtnDict[property] = self.convertToArray(set.allObjects, parentNode: parentNode);
                } else if let orderedset:NSOrderedSet = value as? NSOrderedSet {
                    rtnDict[property] = self.convertToArray(NSArray(array: orderedset.array), parentNode: parentNode);
                } else if let vManagedObject:NSManagedObject = value as? NSManagedObject {
                    if self.parsedObjs.member(managedObject) == nil {
                        self.parsedObjs.addObject(managedObject);
                        if (vManagedObject.entity.name != parentNode) {
                            rtnDict[property] = self.convertToDictionary(vManagedObject, parentNode: parentNode);
                        }
                    }
                } else  if let vData:AnyObject = value {
                    rtnDict[property] = vData;
                }
            }
        }
        
        return rtnDict;
    } //F.E.
    
    
} //CLS END*/
