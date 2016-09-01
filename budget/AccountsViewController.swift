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
    
    var accountData = [AccountTypeTable]()
    
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var DataForSection = [AccountTable]()
    
    
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
        
        let index = section
        
        header.catg.text = accountData[index].name
        
        
        
        let data = accountData
        var price = 0.0
        for type in data{
            for element in type.account! {
            price += Double((element as! AccountTable).amount!)!
            }
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
         
            
             DataForSection = accountData[section].account!.allObjects as! [AccountTable]
            
                print(DataForSection.count)
            return DataForSection.count
        
        }
        else
        {
            return 0
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print("accountData.count= ", accountData.count)
        return accountData.count
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        expenseMonthDate = NSDate()
        updateMonthlyExpenseView(expenseMonthDate)
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        print(DataForSection.count)
        print("DataForSection[indexPath.row].name = ",DataForSection[0])
        cell.subCatg.text = DataForSection[indexPath.row].name
        cell.leftDown.text = "Reconciled: " + Helper.currency +  DataForSection[indexPath.row].amount!
        /*if (DataForSection[indexPath.row].fundsOut != nil), let fo =  Double(DataForSection![indexPath.row].fundsOut!)
        {
            if (DataForSection[indexPath.row].fundsIn != nil), let fi =  Double(DataForSection[indexPath.row].fundsIn!)
            {
                cell.rightUp.text = String(Double(expenseDataForSection[indexPath.row].balance!)! + fi - fo)
            }
            else {
                cell.rightUp.text = String(Double(expenseDataForSection[indexPath.row].balance!)! - fo)
            }
        }else if (DataForSection[indexPath.row].fundsIn != nil), let fi =  Double(DataForSection[indexPath.row].fundsIn!){
            cell.rightUp.text = String(Double(expenseDataForSection[indexPath.row].balance!)! + fi)
        }
        else{
            cell.rightUp.text = DataForSection[indexPath.row].balance
        }*/
        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "updateAccount"
        {
        let indexPath = self.tableView.indexPathForSelectedRow!
        
        let dvc = segue.destinationViewController as! AddAccountViewController
        
        dvc.accountData = DataForSection[indexPath.row]
        dvc.updateAccount = true
        }
        
    }
    
    func updateMonthlyExpenseView(expenseMonthDate : NSDate)
    {
        
        
        do{
            let request = NSFetchRequest(entityName: "AccountTypeTable")
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTypeTable]
            
            
            accountData = queryResult
           
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
            Helper.pickedAccountData = DataForSection[indexPath.row]
            
            
            Helper.accountPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("addAccount", sender: nil)
            
        }
        
        
    }
    
    
    
}
