//
//  QuickSummaryViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/25/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class QuickSummaryViewController: UIViewController {


    var timePeriod : [String] = []
    var incomeTotal : [Float] = []
    var expenseTotal : [Float] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...3
            {
                expenseTotal[index] = getExpenses(index)
                incomeTotal[index] = getIncome(index)
                timePeriod[index] = getDateSting(index)
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            
            return timePeriod.count
      
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ParentTableViewCell
        
        cell.leftUp.text = timePeriod[indexPath.row]
        
        cell.rightUp.text = incomeTotal[indexPath.row].asLocaleCurrency
        
        cell.rightDown.text = expenseTotal[indexPath.row].asLocaleCurrency
        
        return cell
        
    }
    
    func getDateSting(index : Int) -> String
    {
        return ""
    }
    func getIncome(index : Int) -> Float
    {
        return 0.0
    }
    
    func getExpenses(index : Int) -> Float
    {
        
        var expenses : Float = 0.0
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month , .Year], fromDate: expenseMonthDate)
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM YYYY"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(expenseMonthDate)
        
       
        
        
        
        
        do{
            let request = NSFetchRequest(entityName: "ExpenseTable")
            
            
            
            let startDate = NSDate().startOfMonth(components)
            let endDate = NSDate().endOfMonth(components)
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate!, endDate!)
            
          
            let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
            
            for element in queryResult
            {
                expenses += Float(element.amount ?? "0") ?? 0.0
                
            }
            
            
            
        }
        catch let error {
            print("error : ", error)
        }
        
    
    return expenses
        
    }

    
        
    
        
}


