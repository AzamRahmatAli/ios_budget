//
//  SCBudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/8/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.

import UIKit
import CoreData

class SCBudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    var expenseData = [SubCategoryTable]()
    var category = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        UpdateView()
    }
    
    func UpdateView()
    {
        
        
        expenseData = []
        
        
        do{
            
            let predicate = NSPredicate(format: "category.name == %@", category)
            let request = NSFetchRequest(entityName: "SubCategoryTable")
            request.predicate = predicate
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [SubCategoryTable]
            
            expenseData = queryResult
            
        }
        catch let error {
            print("error : ", error)
        }
        
        tableView.reloadData()
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(expenseData.count)
        return expenseData.count
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
        
        if Helper.pickCategory
        {
            
            Helper.pickedSubCaregory = expenseData[indexPath.row]
            
            Helper.pickCategory = false
            Helper.categoryPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("setBudget", sender: nil)
        }
        
        
    }
    
    
    
    func getExpensesForCategory(row : Int) -> Float?
    {
       // if expenseData[row].expense != nil{
        var amount : Float = 0.0
       
            if let expenses = expenseData[row].expense?.allObjects as? [ExpenseTable]
            {
                for expense in expenses
                {
                amount += Float(expense.amount ?? "0") ?? 0.0
                }
            }
            
        
        if amount != 0
        {
            return amount
        }
        //}
        return nil
    }
    
    func getBudgetForCategory(row : Int) -> Float?
    {
        
        var amount : Float = 0.0
        
        if let price = Float(expenseData[row].amount ?? "0")
        {
            amount += price
        }
        
        
        if amount != 0
        {
            return amount
        }
        return nil
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
       
        
        cell.leftUp.text = expenseData[indexPath.row].name
        
        if let budget = getBudgetForCategory(indexPath.row)
        {
            cell.rightUp.text = budget.asLocaleCurrency
            if let expenses = getExpensesForCategory(indexPath.row)
            {
            cell.leftDown.text = expenses.asLocaleCurrency
                cell.rightDown.text = (budget - expenses).asLocaleCurrency
            }
            
        }
        else if let expenses = getExpensesForCategory(indexPath.row)
        {
            cell.rightUp.text = Float(0).asLocaleCurrency
            cell.leftDown.text = expenses.asLocaleCurrency
            cell.rightDown.text = (0.0 - expenses).asLocaleCurrency
        }


        if let scicon = expenseData[indexPath.row].icon
        {
            cell.img.image = UIImage(named: scicon)
        }
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if (segue.identifier == "addSubCategory") {
        let dvc = segue.destinationViewController as! AddBudgetCGViewController
        
        dvc.addSubCategory = true
        dvc.category = category

        }
      
        else
       {
        let path = self.tableView.indexPathForSelectedRow!
        let dvc = segue.destinationViewController as! SetBudgetViewController
        
        dvc.crntCategory = expenseData[path.row].category!.name!
        dvc.crntSubCategory = expenseData[path.row].name!
        if let amount = expenseData[path.row].amount
        {
            dvc.crntAmount = amount
        }
        }
    }
    
}