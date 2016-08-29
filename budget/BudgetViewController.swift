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
    
    
    var expenseData = [String:AnyObject]()

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        return expenseData.keys.count
        
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
    
        
        expenseData = [:]
        
        
        do{
            let request = NSFetchRequest(entityName: "BudgetTable")
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [BudgetTable]
            
            for element in queryResult
            {
                
                
                if (expenseData[element.category!] == nil)
                {
                    expenseData[element.category!] = [element]
                }
                else{
                    
                    var temp = expenseData[element.category!] as! [BudgetTable]
                    temp.append(element)
                    
                    expenseData[element.category!] = temp
                }
                
            }
            
        }
        catch let error {
            print("error : ", error)
        }
        
        tableView.reloadData()
        
    

    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        let index = expenseData.startIndex.advancedBy(indexPath.row)
        
        cell.leftUp.text = expenseData.keys[index]
        if let bt = expenseData[cell.leftUp.text!] as? [BudgetTable]
        {
            if let cicon = bt[0].iconCtg
            {
        cell.img.image = UIImage(named: cicon)
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
        let index = expenseData.startIndex.advancedBy(path.row)
        
       
        dvc.category = expenseData.keys[index]
    }

    }
    
}