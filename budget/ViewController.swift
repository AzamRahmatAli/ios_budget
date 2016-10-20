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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
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
    
    
    
    func checkAndDownloadBackupFile() -> Bool{
        let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
        if(iCloudDocumentsURL != nil){
            let file = iCloudDocumentsURL!.URLByAppendingPathComponent("datafile.txt")
            let filemanager = NSFileManager.defaultManager();
            
            if !filemanager.fileExistsAtPath(file.path!){
                
                if filemanager.isUbiquitousItemAtURL(file) {
                    
                    do {
                        try filemanager.startDownloadingUbiquitousItemAtURL(file)
                    } catch{
                        print("Error while loading Backup File \(error)")
                    }
                }
                return false
            } else{
                return true
            }
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = UIColor.greenColor()
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
      
            formatter.locale = NSLocale.currentLocale()
        print(formatter.currencyCode, formatter.currencySymbol)
        
        
        self.title = StringFor.name["appName"]!
        
        let _ =  checkAndDownloadBackupFile()
        // print(((self.view.frame.height  - 480 ) + 24 ) / 2)
        //bottomConstraint.constant = ((self.view.frame.height  - 480 ) + 24 ) / 2
        
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
     /*override func viewDidLayoutSubviews(){
     tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, self.view.frame.size.height /  3.5)
     // tableView.reloadData()
     }
     -override func viewDidAppear(animated: Bool) {
     tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 50)
     }
    */
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
                  
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            
            cell.price.text = totalExpenses.asLocaleCurrency
            let color = UIColor(red: 254/255, green: 129/255, blue: 0, alpha: 1)
            cell.price.textColor = color
            cell.img.image = UIImage(named: "wallet")
            cell.img.tintColor = UIColor.whiteColor()
            cell.viewInCell.backgroundColor = color
            
            
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
                    
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = totalIncome.asLocaleCurrency
            
            let color = UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1)
            cell.price.textColor = color
            cell.img.image = UIImage(named: "money")
            cell.img.tintColor = UIColor.whiteColor()
            cell.viewInCell.backgroundColor = color
            
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
                if totalBudget == 0.0
                {
                    do{
                        
                        request = NSFetchRequest(entityName: "Other")
                        let queryResult = try managedObjectContext?.executeFetchRequest(request).first
                        if let result = queryResult as? Other{
                            totalBudget = Float(result.oneBudget ?? "0") ?? 0.0
                        }
                    }
                    catch let error {
                        print("error : ", error)
                    }
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = totalBudget.asLocaleCurrency
            
            
            let color = UIColor(red: 50/255, green: 195/255, blue: 0, alpha: 1)
            cell.price.textColor = color
            cell.img.image = UIImage(named: "folder")
            cell.img.tintColor = UIColor.whiteColor()
            cell.viewInCell.backgroundColor = color
            
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
                   if  let data = element.expense!.allObjects as? [ExpenseTable]
                   {
                    var expenses : Float = 0.0
                   
                    for expense in data
                    {
                        expenses += Float(expense.amount ?? "0") ?? 0.0
                    }
                        expensesInAccountsTotal += expenses
                    
                    
                    }
                    if  let data = element.income!.allObjects as? [IncomeTable]
                    {
                         var incomes : Float = 0.0
                        for income in data
                        {
                            incomes += Float(income.amount ?? "0") ?? 0.0
                        }
                        incomeInAccountsTotal += incomes
                    }
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
                var pt = 0
                if totalIncome != 0 // to solve infinity problem
                {
                    pt = Int((totalExpenses / totalIncome) * 100)
                }else if totalExpenses > 0
                {
                    pt = 101 // to solve 100+ problem
                }
                percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
                ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
            }
            else{
                
                available.text = (totalBudget -  totalExpenses).asLocaleCurrency
                percentageText.text = "Expenses as % of Budget"
                var pt = 0
                if totalBudget != 0
                {
                    pt = Int((totalExpenses / totalBudget) * 100)
                }else if totalExpenses > 0
                {
                    pt = 100
                }
                percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
                ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
                
            }
            
            let color = UIColor(red: 69/255, green: 68/255, blue: 205/255, alpha: 1)
            cell.price.textColor = color
            cell.img.image = UIImage(named: "account")
            cell.img.tintColor = UIColor.whiteColor()
            cell.viewInCell.backgroundColor = color
            
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
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //print(self.view.frame.size.height)
        //return self.tableView.frame.size.height /  13.7
        return self.tableView.frame.size.height /  4.2
    }
    
    
    
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 3 {
            UIView.animateWithDuration(1.0, animations: {
                self.needle.layer.anchorPoint = CGPointMake(0.5, 0.54)
                let ValueToMinus = (self.ExpenceAsPercentage < 30 ) ? ((self.ExpenceAsPercentage + 9)/100) * 24 : (self.ExpenceAsPercentage/100) * 24
                
                let angle = ((self.ExpenceAsPercentage - ValueToMinus)  / 100 ) * CGFloat(2 * M_PI)
                self.needle.transform = CGAffineTransformMakeRotation(angle)
                //print(angle,CGFloat(2 * M_PI))
                
            })
        }
        
    }
    
    
    
    
}

