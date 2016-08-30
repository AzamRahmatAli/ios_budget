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
            
            let predicate = NSPredicate(format: "category == %@", category)
            let request = NSFetchRequest(entityName: "SubCategoryTable")
            request.predicate = predicate
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [SubCategoryTable]
            if (queryResult[0].name != "" )
            {
            expenseData = queryResult
            }
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
        
      /*  if Helper.pickCategory
        {
            Helper.pickedCategory = category
            Helper.pickedSubCaregory = expenseData[indexPath.row].subCategory!
            Helper.pickedIcon = expenseData[indexPath.row].icon ?? ""
            Helper.pickCategory = false
            Helper.categoryPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("setBudget", sender: nil)
        }*/
        
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
      /*  // let index = expenseData.startIndex.advancedBy(indexPath.row)
        
        cell.leftUp.text = expenseData[indexPath.row].subCategory
        cell.rightUp.text = expenseData[indexPath.row].expenses
        if let scicon = expenseData[indexPath.row].icon
        {
            cell.img.image = UIImage(named: scicon)
        }*/
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     /*  if (segue.identifier == "addSubCategory") {
        let dvc = segue.destinationViewController as! AddBudgetCGViewController
        
        dvc.addSubCategory = true
        dvc.category = category

        }
      
        else
       {
        let path = self.tableView.indexPathForSelectedRow!
        let dvc = segue.destinationViewController as! SetBudgetViewController
        
        dvc.crntCategory = expenseData[path.row].category!
        dvc.crntSubCategory = expenseData[path.row].subCategory!
        if let amount = expenseData[path.row].expenses
        {
            dvc.crntAmount = amount
        }
        }*/
    }
    
}