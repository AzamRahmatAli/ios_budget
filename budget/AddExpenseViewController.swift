//
//  AddExpenseViewController.swift
//  budget
//
//  Created by Azam Rahmat on 7/29/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class AddExpenseViewController: UIViewController, UITextFieldDelegate {

  
    @IBOutlet weak var category: UITextField!

    @IBOutlet weak var subCategory: UITextField!
    @IBOutlet weak var amount: UITextField!
    

    @IBOutlet weak var missing: UILabel!
   
    @IBOutlet weak var expnseDate: UITextField!
    
    @IBOutlet weak var note: UITextField!
    
    @IBOutlet weak var payFrom: UITextField!
    var dateValue = NSDate()
    var updateExpens = false
     var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var expenseData : ExpenseTable?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        category.delegate = self
        subCategory.delegate = self
        expnseDate.delegate = self
        amount.delegate = self
        payFrom.delegate = self
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
       // Constants.Picker.chooseSubCategory = true
        if textField == expnseDate
        {
         self.performSegueWithIdentifier("pickDate", sender: nil)
        }else if textField  == amount
        {
            amount.text = ""
            return true
        }else if textField  == payFrom
        {
             Helper.pickAccount = true
            self.performSegueWithIdentifier("pickAccount", sender: nil)
        }

        else{
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
    
    
        if updateExpens
        {
            
            //let predicate = NSPredicate(format: "category == %@ AND subCategory == %@", crntCategory, crntSubCategory)
            
            //let fetchRequest = NSFetchRequest(entityName: "ExpenseTable")
            //fetchRequest.predicate = predicate
            
        
                if let entity =  managedObjectContext!.objectWithID(expenseData!.objectID)  as? ExpenseTable
                {
                
                entity.expenses = amount.text
                
                
                entity.category = category.text
                entity.expenses = amount.text
                entity.subCategory = subCategory.text
                
                entity.createdAt = dateValue
               
                entity.note = note.text
                entity.account  = payFrom.text
                // ... Update additional properties with new values
                
                do {
                    try self.managedObjectContext!.save()
                    navigationController?.popViewControllerAnimated(true)
                } catch {
                    // Do something in response to error condition
                }
            }
           

        
        }
        
        else if let expense = NSEntityDescription.insertNewObjectForEntityForName("ExpenseTable", inManagedObjectContext: managedObjectContext!) as? ExpenseTable
    
        
        {
        
        if category.text != ""
        {
        expense.category = category.text
        expense.expenses = amount.text
        expense.subCategory = subCategory.text
       
        expense.createdAt = dateValue
            if Helper.pickedIcon != ""
            {
         expense.icon = Helper.pickedIcon
            }
        expense.note = note.text
            expense.account  = payFrom.text
        
        print(expense)
            do{
                try self.managedObjectContext?.save()
                navigationController?.popViewControllerAnimated(true)
                //receivedMessageFromServer()
                
            }
            catch{
                
            }
        
    }
    else{
    missing.text = "Select category"
    }
    
    
        }
    }
    
        override func viewWillAppear(animated: Bool) {
        if Helper.categoryPicked
        {
            category.text = Helper.pickedCategory
            
            subCategory.text = Helper.pickedSubCaregory
            Helper.pickedCategory = ""
            Helper.pickedSubCaregory = ""
           
            Helper.categoryPicked = false
            
        }
        if Helper.accountPicked
        {
            payFrom.text = Helper.pickedAccount
            
            
            Helper.pickedAccount = ""
            
            Helper.pickAccount = false
            Helper.accountPicked = false
            
        }
       
        if let date  = Helper.datePic
        {
            dateValue = date
            Helper.datePic = nil
            
         
                    }
            if updateExpens
            {
                
                category.text = expenseData!.category
                 amount.text = expenseData!.expenses
                 subCategory.text =  expenseData!.subCategory
                
                dateValue = expenseData!.createdAt!
                note.text = expenseData!.note
                payFrom.text = expenseData!.account

            }
        
        expnseDate.text = Helper.getFormattedDate(dateValue)
        

    }
    
     func receivedMessageFromServer() {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedData", object: nil)
    }

}
