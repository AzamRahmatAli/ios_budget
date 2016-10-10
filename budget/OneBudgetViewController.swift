//
//  OneBudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/10/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class OneBudgetViewController: UIViewController {

    @IBOutlet weak var oneBudget: UITextField!
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest(entityName: "Other")
        if managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request).first as! Other
                
                oneBudget.text = queryResult.oneBudget
            }
            catch let error {
                print("error : ", error)
            }
        }


        // Do any additional setup after loading the view.
    }


    @IBAction func info(sender: UIButton) {
        let alertController = UIAlertController(title: "Account Type", message: "Enter one of Checking, Savings, Credit, Debit, Cash, etc", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
        
        
        let request = NSFetchRequest(entityName: "Other")
        
        
       
        if managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
             
            
                let queryResult = try managedObjectContext?.executeFetchRequest(request).first as! Other
                
                queryResult.oneBudget = (oneBudget.text != "") ? oneBudget.text : "0"
          
            }
            catch let error {
                print("error : ", error)
            }
            

            
        }
        
        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: managedObjectContext!) as? Other
        {
            
            entity.oneBudget = (oneBudget.text != "") ? oneBudget.text : "0" //if else condition
           
            
            
            
        }
        do {
            try self.managedObjectContext!.save()
            navigationController?.popViewControllerAnimated(true)
        } catch {
            print("error")
        }
    }
    
}
