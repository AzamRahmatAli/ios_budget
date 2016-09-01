//
//  AddIncomeViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/5/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData


class AddIncomeViewController: UIViewController , UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        dateValue.delegate = self
        amount.delegate = self
        account.delegate = self
        
        
        
        if updateIncome
        {
            
            category.text = incomeData!.category
            amount.text = incomeData!.amount
            
            
            incomeDate = incomeData!.createdAt
            
            note.text = incomeData!.note
            if let acount = incomeData!.account
            {
                account.text = acount.name
                
            }
            
            
        }

    }

    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    var incomeData : IncomeTable?
    var updateIncome = false
    
    @IBOutlet weak var dateValue: UITextField!
   
    @IBOutlet weak var note: UITextField!
    
    @IBOutlet weak var missing: UILabel!
    
    
    var incomeDate : NSDate? = NSDate()
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
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
            Helper.pickAccount = true
            self.performSegueWithIdentifier("pickAccount", sender: nil)
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
        
        if updateIncome
        {
            
            //let predicate = NSPredicate(format: "category == %@ AND subCategory == %@", crntCategory, crntSubCategory)
            
            //let fetchRequest = NSFetchRequest(entityName: "ExpenseTable")
            //fetchRequest.predicate = predicate
            
            
            if let entity =  managedObjectContext!.objectWithID(incomeData!.objectID)  as? IncomeTable
            {
                
                entity.amount = (amount.text != "") ? amount.text : "0"
                
                if let account = Helper.pickedAccountData
                {
                    entity.account = account
                    Helper.pickedAccountData = nil
                }
                
                
                
                
                entity.category = (category.text != "") ? category.text : "income"
                
                entity.createdAt = incomeDate
                
                entity.note = note.text
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
      
            else if let entity = NSEntityDescription.insertNewObjectForEntityForName("IncomeTable", inManagedObjectContext: managedObjectContext!) as? IncomeTable
        {
            
                
            entity.category = (category.text != "") ? category.text : "income"
            entity.amount = (amount.text != "") ? amount.text : "0"
            //entity.account = account.text
            if let account = Helper.pickedAccountData
            {
                entity.account = account
                Helper.pickedAccountData = nil
            }
            

            entity.createdAt = incomeDate
            entity.note = note.text
            
            //print(expense)
            do{
                try self.managedObjectContext?.save()
                navigationController?.popViewControllerAnimated(true)
                //receivedMessageFromServer()
                
            }
            catch{
                
            }
            
        }
        
        
     
        

    
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func receivedMessageFromServer() {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedData", object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
       
        
       
        if Helper.accountPicked
        {
            
            
            Helper.pickAccount = false
            Helper.accountPicked = false
            if let acount = Helper.pickedAccountData
            {
                account.text = acount.name
                
            }
        }
            
            
        else if let date  = Helper.datePic
        {
            incomeDate = date
            Helper.datePic = nil
            
            
        }
        
        dateValue.text = Helper.getFormattedDate(incomeDate!)

    }


}
