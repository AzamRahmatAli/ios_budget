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
    var calculatedAmount = [[Float]]()
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var dataForSection = [AccountTable]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addExpense(sender: AnyObject) {
        self.performSegueWithIdentifier("addAccount", sender: nil)
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
    }
    
    
    

    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ExpenseViewController.myAction(_:)))
        cell!.addGestureRecognizer(headerTapGesture)
        
        let index = section
        
        header.catg.text = accountData[index].name
        
        
        
        let data = calculatedAmount[section]
        var price : Float = 0.0
        for amount in data{
            
            price += amount
            
        }
        header.price.text = price.asLocaleCurrency
        if price < 0
        {
            header.price.textColor = UIColor.redColor()
        }
        
        
        
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
         
            
             dataForSection = accountData[section].account!.allObjects as! [AccountTable]
            
                print(dataForSection.count)
            return dataForSection.count
        
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
    
    
    func calculateCurrentAmount(amount : Float, row : Int) -> Float?
    {
        var total = amount
        if let incomes =  dataForSection[row].income!.allObjects as? [IncomeTable]
        {
            for element in incomes
            {
                total += Float(element.amount ?? "0") ?? 0.0
            }
        }
        if let expenses =  dataForSection[row].expense!.allObjects as? [ExpenseTable]
        {
            for element in expenses
            {
                total -= Float(element.amount ?? "0") ?? 0.0
            }
        }
        return total
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        print(dataForSection.count)
        print("DataForSection[indexPath.row].name = ",dataForSection[0])
        cell.subCatg.text = dataForSection[indexPath.row].name
        cell.leftDown.text = "Reconciled: " + Helper.currency +  dataForSection[indexPath.row].amount!
        let amount = Float(dataForSection[indexPath.row].amount ?? "0") ?? 0.0
        let total = calculateCurrentAmount(amount, row: indexPath.row)
        cell.rightUp.text = total!.asLocaleCurrency
        if total < 0
        {
            cell.rightUp.textColor = UIColor.redColor()
        }
        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "updateAccount"
        {
        let indexPath = self.tableView.indexPathForSelectedRow!
        
        let dvc = segue.destinationViewController as! AddAccountViewController
        
        dvc.accountData = dataForSection[indexPath.row]
        dvc.updateAccount = true
        }
        
    }
    
    func updateMonthlyExpenseView(expenseMonthDate : NSDate)
    {
        var i = 0, j = 0
        
        do{
            let request = NSFetchRequest(entityName: "AccountTypeTable")
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTypeTable]
            
            
            accountData = queryResult
            for element in accountData
            {
                if let accounts = element.account?.allObjects as? [AccountTable]
                    {
                        for account in accounts{
                            if let amount = calculateCurrentAmount(Float(account.amount!)!, row:  j)
                            {
                            calculatedAmount[i].append(amount)
                        }
                            j += 1
                        }
                }
                i += 1
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
            Helper.pickedAccountData = dataForSection[indexPath.row]
            
            
            Helper.accountPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("updateAccount", sender: nil)
            
        }
        
        
    }
    
    
    
}
