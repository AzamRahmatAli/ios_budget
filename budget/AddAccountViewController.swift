//
//  AddAccountViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class AddAccountViewController: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var subCategory: UITextField!
    @IBOutlet weak var amount: UITextField!
    

    @IBOutlet weak var dateValue: UITextField!
    var updateAccount = true
    var accountData : AccountTable?
    
   
    var accountDate : NSDate? = NSDate()
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateValue.delegate = self
        amount.delegate = self
        //subCategory.delegate = self
        
        
        if updateAccount
        {
            
            category.text = accountData!.accountType?.name
            amount.text = accountData!.amount
            
            
            accountDate = accountData!.createdAt!
            
            subCategory.text = accountData!.name
            
            
            
        }

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Constants.Picker.chooseSubCategory = true
        if textField == dateValue
        {
            self.performSegueWithIdentifier("pickDate", sender: nil)
        }else if textField  == amount
        {
            if amount.text == "0"
            {
            amount.text = ""
            return true
            }
        }else{
            Helper.pickCategory = true
            self.performSegueWithIdentifier("pickCategory", sender: nil)
        }
        return false
    }
    
    
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        let countdots = textField.text!.componentsSeparatedByString(".").count - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        return string == numberFiltered
        
    }

    
    @IBAction func Cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addExpense(sender: AnyObject) {
        
        if updateAccount
        {
            
            //let predicate = NSPredicate(format: "category == %@ AND subCategory == %@", crntCategory, crntSubCategory)
            
            //let fetchRequest = NSFetchRequest(entityName: "ExpenseTable")
            //fetchRequest.predicate = predicate
            
            
            if let entity =  managedObjectContext!.objectWithID(accountData!.objectID)  as? AccountTable
            {
                
                entity.amount = (amount.text != "") ? amount.text : "0"
                
                
                
                
                
                
                entity.createdAt = accountDate
                
                entity.name = subCategory.text
                if let accountType = AccountTypeTable.accontType(category.text!, inManagedObjectContext: managedObjectContext!)
                {
                    entity.accountType = accountType
                }

                
                //entity.account?.name = payFrom.text
                // ... Update additional properties with new values
                
                do {
                    try self.managedObjectContext!.save()
                    navigationController?.popViewControllerAnimated(true)
                } catch {
                    print("error")
                }
            }
            
            
            
        }
        
        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: managedObjectContext!) as? AccountTable
        {
            
            entity.amount = amount.text!
            entity.name = subCategory.text
            entity.createdAt = accountDate
         entity.accountType = AccountTypeTable.accontType(category.text!, inManagedObjectContext: managedObjectContext!)
            
            print(entity)
            
            
        
        
        do{
            try self.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
            //receivedMessageFromServer()
            
        }
        catch{
            
        }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
       /* if Helper.categoryPicked
        {
            category.text = Helper.pickedSubCaregory?.category!.name
            
            subCategory.text = Helper.pickedSubCaregory?.name
            
            Helper.pickedSubCaregory = nil
            
            Helper.categoryPicked = false
            
        }*/
        
        
            if let date  = Helper.datePic
            {
                accountDate = date
                Helper.datePic = nil
                
                
            }
            
        
            dateValue.text =  Helper.getFormattedDate(accountDate!)
        
    }
    
    func receivedMessageFromServer() {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedData", object: nil)
    }
    
}
