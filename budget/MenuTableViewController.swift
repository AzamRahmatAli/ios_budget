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
                            if let accounts =  records  as? [[String : AnyObject]]
                            {
                                for account in accounts{
                                    
                                    if let entity = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: managedObjectContext!) as? AccountTable
                                    {
                                        
                                        
                                        
                                        entity.amount = account["amount"] as? String
                                        entity.icon = account["icon"] as? String
                                        
                                        entity.name = account["name"] as? String
                                        let dateString = account["createdat"] as? String
                                        let dateFormatter = NSDateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
                                        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                                        let dateObj = dateFormatter.dateFromString(dateString!)
                                        print(dateObj)
                                        entity.createdAt = dateObj
                                        entity.accountType = AccountTypeTable.accontType((account["accounttype"] as!String), inManagedObjectContext: managedObjectContext!)
                                        
                                     
                                        
                                       
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
                    sets.append(["name" :element.name!, "amount" :element.amount ?? "" , "icon" :element.icon! , "createdat" : String(element.createdAt ), "category": element.category!.name!])
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
                    a["accountType"] =  element.account?.accountType?.name ?? ""
                    a["subcategory"] = element.subCategory!.name!
                    a["category"] = element.subCategory!.category!.name!
                    sets.append(a)
                  
                }
                dictionary["ExpenseTable"] =  sets
                
                
                
                            /*let dataInArr:NSArray = ManagedParser.convertToArray(fetchedGuest);
             NSLog("dataInArr \(dataInArr)");*/
                
                
                let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
                let cdata = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                   // print(cdata)
                if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                    let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.json")
                /*if let file = NSFileHandle(forWritingAtPath:"datafile.json") {
                    file.writeData(jsonData)
                }*/
                    //writing
                    do {
                        try cdata.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                    }
                    catch {/* error handling here */}
                }
                               // let myEntities : [String] = Array(objectModel!.entitiesByName.keys)
               // print(myEntities)

            }
            catch let error {
                print("error : ", error)
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
