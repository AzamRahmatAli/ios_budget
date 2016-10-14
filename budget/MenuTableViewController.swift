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
