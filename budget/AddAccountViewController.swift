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
        
        if let entity = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: managedObjectContext!) as? AccountTable
        {
            
            entity.amount = amount.text!
            entity.name = subCategory.text
            entity.createdAt = idate
         entity.accountType = AccountTypeTable.accontType(category.text!, inManagedObjectContext: managedObjectContext!)
            
            print(entity)
            
            
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
       /* if Helper.categoryPicked
        {
            category.text = Helper.pickedSubCaregory?.category!.name
            
            subCategory.text = Helper.pickedSubCaregory?.name
            
            Helper.pickedSubCaregory = nil
            
            Helper.categoryPicked = false
            
        }*/
        
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
