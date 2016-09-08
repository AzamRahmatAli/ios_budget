//
//  BudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/8/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData


class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    var expenseData : [CategoryTable]?

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        return expenseData!.count
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //return true
    }
   
    @IBAction func edit(sender: AnyObject) {
       
        if(self.tableView.editing)
        {
             tableView.setEditing(!tableView.editing, animated: false)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        else
        {
             tableView.setEditing(!tableView.editing, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    override func viewWillAppear(animated: Bool) {
        if Helper.categoryPicked
        {
            
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
        UpdateView()
        }

    }
    
    func UpdateView()
    {
    
        
        expenseData = []
        
        
        do{
            let request = NSFetchRequest(entityName: "CategoryTable")
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [CategoryTable]
            
            
                
                
            
                    expenseData = queryResult
                
                
            
            
        }
        catch let error {
            print("error : ", error)
        }
        
        tableView.reloadData()
        
    

    }
    
    func getBudgetForCategory(name : String, row : Int) -> Float?
    {
         let data = expenseData![row].subcategory!.allObjects as! [SubCategoryTable]
        var amount : Float = 0.0
        for element in data{
            if let price = Float(element.amount ?? "0")
            {
                amount += price
            }
        
        }
        if amount != 0
        {
            return amount
        }
    return nil
    }
    
    func getExpensesForCategory(row : Int) -> Float?
    {
        // if expenseData[row].expense != nil{
        var amount : Float = 0.0
        
        if let subCategories = expenseData![row].subcategory?.allObjects as? [SubCategoryTable]
        {
            for category in subCategories
            {
                if let expenses = category.expense?.allObjects as? [ExpenseTable]
                {
                    for expense in expenses
                    {
                        amount += Float(expense.amount ?? "0") ?? 0.0
                    }
                }            }
        }
        
        
        if amount != 0
        {
            return amount
        }
        //}
        return nil
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        let index = indexPath.row
        let ctgName = expenseData![index].name
        cell.leftUp.text = ctgName
       
        cell.img.image = UIImage(named: expenseData![index].icon!)
        
        if let budget = getBudgetForCategory(ctgName!,row: indexPath.row)
        {
        cell.rightUp.text = budget.asLocaleCurrency
            if let expenses = getExpensesForCategory(indexPath.row)
            {
                cell.leftDown.text = expenses.asLocaleCurrency
                cell.rightDown.text = (budget - expenses).asLocaleCurrency
                if (budget - expenses) >= 0
                {
                cell.rightDown.textColor = UIColor(red: 37/255, green: 162/255, blue: 77/255, alpha: 1)
                }
                else{
                    cell.rightDown.textColor = UIColor.redColor()
                }
            }
            
        }
        else if let expenses = getExpensesForCategory(indexPath.row)
        {
            cell.rightUp.text = Float(0).asLocaleCurrency
            cell.leftDown.text = expenses.asLocaleCurrency
            cell.rightDown.text = (0.0 - expenses).asLocaleCurrency
            if (0.0 - expenses) >= 0
            {
                cell.rightDown.textColor = UIColor(red: 37/255, green: 162/255, blue: 77/255, alpha: 1)
            }
            else{
                cell.rightDown.textColor = UIColor.redColor()
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
        
        
        
    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addCategory") {
            let dvc = segue.destinationViewController as! AddBudgetCGViewController
          
            dvc.addCategory = true
       
        }
      
        else
        {
            let path = self.tableView.indexPathForSelectedRow!
        let dvc = segue.destinationViewController as! SCBudgetViewController
        let index = path.row
        
        dvc.category = expenseData![index].name!
    }

    }
    
}