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
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    
    @IBOutlet weak var dateValue: UITextField!
   
    @IBOutlet weak var note: UITextField!
    var idate = NSDate()
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
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
        
        if let entity = NSEntityDescription.insertNewObjectForEntityForName("IncomeTable", inManagedObjectContext: managedObjectContext!) as? IncomeTable
        {
            entity.category = category.text
            entity.amount = amount.text
            //entity.account = account.text
            entity.createdAt = idate
            entity.note = note.text
            
            //print(expense)
            
            
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


}
