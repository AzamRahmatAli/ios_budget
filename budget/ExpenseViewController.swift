//
//  ExpenseViewController.swift
//  budget
//
//  Created by Azam Rahmat on 7/27/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData


class ExpenseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    
    var expenseMonthDate = NSDate()
    
    var expenseData : [String:AnyObject]?
    
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var expenseDataForSection : [ExpenseTable]?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addExpense(sender: AnyObject) {
        self.performSegueWithIdentifier("addExpense", sender: nil)
        
        
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
        
        
        
        let data = expenseData!.values[index] as! [ExpenseTable]
        var price = 0.0
        for element in data{
            price += Double(element.amount ?? "0") ?? 0.0
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
            expenseDataForSection = array as? [ExpenseTable]
            print(array.count)
            return array.count
        }
        else
        {
            return 0
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return expenseData!.count
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        expenseMonthDate = NSDate()
        updateMonthlyExpenseView(expenseMonthDate)
        
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        
        
        cell.subCatg.text = expenseDataForSection![indexPath.row].category!.name
        cell.categoryAmount.text = Helper.currency + expenseDataForSection![indexPath.row].amount!
        
        let date = String(expenseDataForSection![indexPath.row].createdAt!).componentsSeparatedByString(" ").first
        
        
        let note = expenseDataForSection![indexPath.row].note ?? ""
        
        cell.leftDown.text = date! + " " + note
        if let img = expenseDataForSection![indexPath.row].category?.icon where img != ""
        {
            cell.img.image = UIImage(named: img)
            
        }
 
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
       if (segue.identifier == "updateExpense") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let dvc = segue.destinationViewController as! AddExpenseViewController
            
            dvc.expenseData = expenseDataForSection![indexPath.row]
            dvc.updateExpens = true
           
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        performSegueWithIdentifier("updateExpense", sender: self)
        
    }
    
    
    func updateMonthlyExpenseView(expenseMonthDate : NSDate)
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month , .Year], fromDate: expenseMonthDate)
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM YYYY"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(expenseMonthDate)
        
        self.title =  dateString
        expenseData = [:]
        
        
        
        do{
            let request = NSFetchRequest(entityName: "ExpenseTable")
            
            
            
            let startDate = NSDate().startOfMonth(components)
            let endDate = NSDate().endOfMonth(components)
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate!, endDate!)
            
            print(startDate! ,  endDate!)
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
            
            for element in queryResult
            {
                print(components.year ,  components.month)
                let category = element.category!.category!.name
                if (expenseData![category!] == nil)
                {
                    expenseData![category!] = [element]
                }
                else{
                    
                    var temp = expenseData![category!]! as! [ExpenseTable]
                    print(temp.count)
                    temp.append(element)
                    expenseData![category!] = temp
                }
                
            }
            
        }
        catch let error {
            print("error : ", error)
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
}
