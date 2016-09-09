//
//  ViewController.swift
//  budget
//
//  Created by Azam Rahmat on 7/21/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var available: UILabel!
    
    @IBOutlet weak var needle: UIImageView!
    @IBOutlet weak var percentageText: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var currentMonth: UILabel!
    let images : [UIImage] = [UIImage(named : "expenses")!, UIImage(named : "income")!, UIImage(named : "budget")!, UIImage(named : "accounts")!]
    let ctgNames : [String] = ["Expenses","Income", "Budget", "Accounts"]
    
    var expensesInAccountsTotal : Float = 0.0
    var incomeInAccountsTotal : Float = 0.0
    var totalExpenses : Float = 0.0
    var totalIncome : Float = 0.0
    var totalBudget : Float = 0.0
    var ExpenceAsPercentage : CGFloat = 0.0
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if  self.revealViewController() != nil {
            //  menuButton.target = self.revealViewController()
            //  menuButton.action = "rightRevealToggle:"
            
            
            let myBtn: UIButton = UIButton()
            myBtn.setImage(UIImage(named: "menu"), forState: .Normal)
            myBtn.frame = CGRectMake(0, 0, 50, 50)
            myBtn.backgroundColor = UIColor.clearColor()
            // myBtn.addTarget(self, action: "rightRevealToggle:", forControlEvents: .TouchUpInside)
            myBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: myBtn), animated: true)
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            currentMonth.text = dateFormatter.stringFromDate(NSDate())
            
            /*menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
             
             */
        }
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  images.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.img.image = images[indexPath.row]
        cell.name.text = ctgNames[indexPath.row]
        
        
        
        var request = NSFetchRequest(entityName: "ExpenseTable")
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month , .Year], fromDate: NSDate())
        let startDate = NSDate().startOfMonth(components)
        let endDate = NSDate().endOfMonth(components)
        let predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate!, endDate!)
       
        
        
        if indexPath.row == 0
        {
            request = NSFetchRequest(entityName: "ExpenseTable")
            request.predicate = predicate
            do{
               
                
                totalExpenses = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
                
                for element in queryResult
                {
                   
                    
                    totalExpenses += Float(element.amount ?? "0") ?? 0.0
                    
                    expensesInAccountsTotal += totalExpenses
                    

                   
                    
                        
                        
                    }
                               }
                
            
            catch let error {
                print("error : ", error)
            }
            
            cell.price.text = totalExpenses.asLocaleCurrency
            cell.price.textColor = UIColor(red: 254/255, green: 129/255, blue: 0, alpha: 1)

            
        }
        else if indexPath.row == 1
        {
            request = NSFetchRequest(entityName: "IncomeTable")
            request.predicate = predicate
            do{
                
                
                totalIncome = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [IncomeTable]
                
                for element in queryResult
                {
                    
                    totalIncome += Float(element.amount ?? "0") ?? 0.0
                    
                    incomeInAccountsTotal += totalIncome
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = totalIncome.asLocaleCurrency
            cell.price.textColor = UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1)
            
        }else if indexPath.row == 2
        {
            request = NSFetchRequest(entityName: "SubCategoryTable")
            request.predicate = nil
            do{
                
                
                totalBudget = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [SubCategoryTable]
                
                for element in queryResult
                {
                   
                    
                   
                        if let value =  Float(element.amount ?? "0")
                        {
                        totalBudget += value
                        
                    }
                   
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = totalBudget.asLocaleCurrency

            cell.price.textColor = UIColor(red: 50/255, green: 195/255, blue: 0, alpha: 1)
            
        }else if indexPath.row == 3
        {
            var total : Float = 0.0
            request = NSFetchRequest(entityName: "AccountTable")
            request.predicate = nil
            do{
                
                
                
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTable]
                
                for element in queryResult
                {
                    
                   
                    total += Float(element.amount ?? "0") ?? 0.0
                    
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = (total - expensesInAccountsTotal + incomeInAccountsTotal).asLocaleCurrency
            if totalBudget == 0
            {
            available.text = (totalIncome -  totalExpenses).asLocaleCurrency
                percentageText.text = "Expenses as % of Income"
                let pt = Int((totalExpenses / totalIncome * 100))
                percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
                ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
            }
            else{
                available.text = (totalBudget -  totalExpenses).asLocaleCurrency
                percentageText.text = "Expenses as % of Budget"
                let pt = Int((totalExpenses / totalBudget * 100))
                percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
                 ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
                
            }
            cell.price.textColor = UIColor(red: 69/255, green: 68/255, blue: 205/255, alpha: 1)
            
            
        }
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
       
         if indexPath.row == 0
         {
         self.performSegueWithIdentifier("listView", sender: nil)
         }
         else if indexPath.row == 1{
            
         self.performSegueWithIdentifier("incomeList", sender: nil)
        }
        else if indexPath.row == 2
         {
            self.performSegueWithIdentifier("budgetView", sender: nil)
        }
         else if indexPath.row == 3
         {
            self.performSegueWithIdentifier("accountList", sender: nil)
        }
 
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //let path = self.tableView.indexPathForSelectedRow!
        if (segue.identifier == "listView") {
            
            //let dvc = segue.destinationViewController as! ExpenseViewController
            
          
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        incomeInAccountsTotal  = 0
        expensesInAccountsTotal = 0
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableView.reloadData()
        
       

    }
    
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 3 {
            UIView.animateWithDuration(4.0, animations: {
               self.needle.layer.anchorPoint = CGPointMake(0.5, 0.54)
                let ValueToMinus = 24 *  (self.ExpenceAsPercentage / 100)
                let angle = (self.ExpenceAsPercentage  / 100 ) * CGFloat(2 * M_PI) - ( ValueToMinus  / 100 ) * CGFloat(2 * M_PI)
                self.needle.transform = CGAffineTransformMakeRotation(angle)
               print(angle,CGFloat(2 * M_PI))
               
            })
        }
       
    }

    
    
    
}

