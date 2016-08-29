//
//  AccountsViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class AccountsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    
    var expenseMonthDate = NSDate()
    
    var expenseData : [String:[AccountTable]]?
    
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var expenseDataForSection = [AccountTable]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addExpense(sender: AnyObject) {
         self.performSegueWithIdentifier("addAccount", sender: nil)
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
    }
    
    
    
    
    @IBAction func nextMonth(sender: AnyObject) {
        
        selectedIndexPath = nil
        let cal = NSCalendar.currentCalendar()
        expenseMonthDate = cal.dateByAddingUnit(.Month, value: 1, toDate: expenseMonthDate, options: [])!
        updateMonthlyExpenseView(expenseMonthDate)
    }
    
    
    @IBAction func prevMonth(sender: AnyObject) {
        selectedIndexPath = nil
        let cal = NSCalendar.currentCalendar()
        expenseMonthDate = cal.dateByAddingUnit(.Month, value: -1, toDate: expenseMonthDate, options: [])!
        updateMonthlyExpenseView(expenseMonthDate)
    }
    
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ExpenseViewController.myAction(_:)))
        cell!.addGestureRecognizer(headerTapGesture)
        
        let index = expenseData!.startIndex.advancedBy(section)
        
        header.catg.text = expenseData!.keys[index]
        
        
        
        let data = expenseData!.values[index]
        var price = 0.0
        for element in data{
            price += Double(element.balance!)!
        }
        header.price.text = Helper.currency + String(price)
        
        
        
        if section == sectionTapped
        {
            header.image.image = UIImage(named: "arrowDown")
            header.separator.hidden = true
        }
        else{
            header.image.image = UIImage(named: "arrowRight")
            header.separator.hidden = false
        }
        header.headerCellSection = section
        
        return header
    }
    
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
    
    
    func myAction (sender: UITapGestureRecognizer) {
        
        
        // Get the view
        let senderView = sender.view as! TableSectionHeader
        
        // Get the section
        sectionTapped  = senderView.headerCellSection
        
        
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionTapped
        {
            let index = expenseData!.values.startIndex.advancedBy(section)
            
            let array = expenseData!.values[index]
            expenseDataForSection = array
            
            return array.count
        }
        else
        {
            return 0
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return expenseData!.keys.count
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        expenseMonthDate = NSDate()
        updateMonthlyExpenseView(expenseMonthDate)
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        
        
        cell.subCatg.text = expenseDataForSection[indexPath.row].name
        cell.leftDown.text = "Reconciled: " + Helper.currency +  expenseDataForSection[indexPath.row].balance!
        if (expenseDataForSection[indexPath.row].fundsOut != nil), let fo =  Double(expenseDataForSection[indexPath.row].fundsOut!)
        {
           if (expenseDataForSection[indexPath.row].fundsIn != nil), let fi =  Double(expenseDataForSection[indexPath.row].fundsIn!)
           {
            cell.rightUp.text = String(Double(expenseDataForSection[indexPath.row].balance!)! + fi - fo)
            }
           else {
            cell.rightUp.text = String(Double(expenseDataForSection[indexPath.row].balance!)! - fo)
            }
        }else if (expenseDataForSection[indexPath.row].fundsIn != nil), let fi =  Double(expenseDataForSection[indexPath.row].fundsIn!){
            cell.rightUp.text = String(Double(expenseDataForSection[indexPath.row].balance!)! + fi)
        }
        else{
            cell.rightUp.text = expenseDataForSection[indexPath.row].balance
        }
        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
       
        
    }
    
    func updateMonthlyExpenseView(expenseMonthDate : NSDate)
    {
        
        
               expenseData = [:]
        
        
        
        do{
            let request = NSFetchRequest(entityName: "AccountTable")
            
            
        
        
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTable]
            
            for element in queryResult
            {
                
                if (expenseData![element.category!] == nil)
                {
                    expenseData![element.category!] = [element]
                }
                else{
                
                    expenseData![element.category!]!.append(element)                }
                
            }
            
        }
        catch let error {
            print("error : ", error)
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
        
        if Helper.pickAccount        {
            //  let index = expenseData.startIndex.advancedBy(indexPath.row)
            Helper.objectIDofAccountRecord = expenseDataForSection[indexPath.row].objectID
            
           
            Helper.accountPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("addAccount", sender: nil)
        }
        
        
    }
    
    
    
}
