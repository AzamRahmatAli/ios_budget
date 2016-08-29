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
    
   
    var idate = NSDate()
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateValue.delegate = self
        amount.delegate = self
        //subCategory.delegate = self
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Constants.Picker.chooseSubCategory = true
        if textField == dateValue
        {
            self.performSegueWithIdentifier("pickDate", sender: nil)
        }else if textField  == amount
        {
            amount.text = ""
            return true
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
        
        if let expense = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: managedObjectContext!) as? AccountTable
        {
            expense.category = category.text
            expense.balance = amount.text
            expense.name = subCategory.text
            expense.createdAt = idate
         
            
            print(expense)
            
            
        }
        else{
            print("fail insert")
        }
        
        do{
            try self.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
            //receivedMessageFromServer()
            
        }
        catch{
            
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
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            if let date  = Helper.datePic
            {
                idate = date
                Helper.datePic = nil
                
                
            }
            
            let selectedDate = dateFormatter.stringFromDate(idate)
            dateValue.text = selectedDate
        
    }
    
    func receivedMessageFromServer() {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedData", object: nil)
    }
    
}
