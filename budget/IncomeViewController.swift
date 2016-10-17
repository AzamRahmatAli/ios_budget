//
//  IncomeViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/5/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData


class IncomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    var expenseMonthDate = NSDate()
    
    var expenseData : [String:[IncomeTable]]?
    
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var expenseDataForSection : [IncomeTable]?
    
    
    @IBOutlet weak var incomeTotalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleMonth: UILabel!
    
    
    @IBAction func addExpense(sender: AnyObject) {
        self.performSegueWithIdentifier("addincome", sender: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        expenseMonthDate = NSDate()
        updateMonthlyExpenseView(expenseMonthDate)
        
        
        
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
        
        let data = expenseData!.values[index]
        var price : Float = 0.0
        for element in data{
            price += Float(element.amount ?? "0") ?? 0.0
        }
        header.price.text = price.asLocaleCurrency
        
        
        
        
        header.catg.text = expenseData!.keys[index]
        if Helper.expandedAndCollapsedSections[section]
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
        
        //change the value of section to expandable or not expandable
        Helper.expandedAndCollapsedSections[sectionTapped] = !Helper.expandedAndCollapsedSections[sectionTapped]
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Helper.expandedAndCollapsedSections[section])
        if Helper.expandedAndCollapsedSections[section]
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
    
    
    
    
    

    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        
        
        cell.subCatg.text = expenseDataForSection![indexPath.row].category
        
        let date = String(expenseDataForSection![indexPath.row].createdAt!).componentsSeparatedByString(" ").first!
        
        
        let note = expenseDataForSection![indexPath.row].note ?? ""
        
        cell.leftDown.text = date + " " + note
        let amount = Float(expenseDataForSection![indexPath.row].amount ?? "0") ?? 0.0
        
        cell.rightUp.text = amount.asLocaleCurrency
        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "updateIncome") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let dvc = segue.destinationViewController as! AddIncomeViewController
            
            dvc.incomeData = expenseDataForSection![indexPath.row]
            dvc.updateIncome = true
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        performSegueWithIdentifier("updateIncome", sender: self)
        
    }
    
    func updateMonthlyExpenseView(expenseMonthDate : NSDate)
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month , .Year], fromDate: expenseMonthDate)
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM YYYY"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(expenseMonthDate)
        
        self.titleMonth.text =  dateString
        expenseData = [:]
        
        
        
        do{
            let request = NSFetchRequest(entityName: "IncomeTable")
            
            
            let startDate = NSDate().startOfMonth(components)
            let endDate = NSDate().endOfMonth(components)
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate!, endDate!)
            
            print(startDate! ,  endDate!)
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [IncomeTable]
            var totalAmount : Float = 0
            for element in queryResult
            {
                
                if (expenseData![element.category!] == nil)
                {
                    expenseData![element.category!] = [element]
                    totalAmount = Float(element.amount ?? "0" ) ?? 0.0
                    
                }
                else{
                    totalAmount += Float(element.amount ?? "0" ) ?? 0.0
                    expenseData![element.category!]?.append(element)
                    
                    
                    
                }
                
            }
            incomeTotalLabel.text = totalAmount.asLocaleCurrency
        }
        catch let error {
            print("error : ", error)
        }
        
        //append array if section increase
        if Helper.expandedAndCollapsedSections.count < expenseData!.count
        {
            let newSections = expenseData!.count - Helper.expandedAndCollapsedSections.count
            print(newSections)
            if newSections > 0
            {
                //to make first section expanded at launch
            if Helper.expandedAndCollapsedSections.count == 0
            {
                Helper.expandedAndCollapsedSections.append(true)
            }
        
            // expandedAndCollapsedSections array can be greater then sections
            Helper.expandedAndCollapsedSections += [Bool](count: newSections, repeatedValue: false)
            
            }
            
        }
        
        
        
        
        tableView.reloadData()
        
    }
    
    
    
    
    
}
