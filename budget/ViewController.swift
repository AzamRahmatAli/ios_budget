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
    
    
    
    let images : [UIImage] = [UIImage(named : "expenses")!, UIImage(named : "income")!, UIImage(named : "budget")!, UIImage(named : "accounts")!]
    let ctgNames : [String] = ["Expenses","Income", "Budget", "Accounts"]
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if  self.revealViewController() != nil {
            //  menuButton.target = self.revealViewController()
            //  menuButton.action = "rightRevealToggle:"
            
            
            let myBtn: UIButton = UIButton()
            myBtn.setImage(UIImage(named: "menu"), forState: .Normal)
            myBtn.frame = CGRectMake(0, 0, 30, 30)
            myBtn.backgroundColor = UIColor.clearColor()
            // myBtn.addTarget(self, action: "rightRevealToggle:", forControlEvents: .TouchUpInside)
            myBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: myBtn), animated: true)
            
            
            
            
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
        var total = 0.0
        
        
        if indexPath.row == 0
        {
            request = NSFetchRequest(entityName: "ExpenseTable")
            request.predicate = predicate
            do{
               
                
                total = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
                
                for element in queryResult
                {
                   
                    
                    total += Double(element.amount!)
                    
                   
                    
                        
                        
                    }
                               }
                
            
            catch let error {
                print("error : ", error)
            }
            cell.price.text = "Rs" + "\(total)"
            cell.price.textColor = UIColor.orangeColor()

            
        }
        else if indexPath.row == 1
        {
            request = NSFetchRequest(entityName: "IncomeTable")
            request.predicate = predicate
            do{
                
                
                total = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [IncomeTable]
                
                for element in queryResult
                {
                    
                    
                    total += Double(element.amount!)!
                    
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = "Rs" + "\(total)"
            cell.price.textColor = UIColor.blueColor()
            
        }else if indexPath.row == 2
        {
            request = NSFetchRequest(entityName: "SubCategoryTable")
            request.predicate = nil
            do{
                
                
                total = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [SubCategoryTable]
                
                for element in queryResult
                {
                    print(element.amount)
                    
                   
                        if let value =  Double(element.amount ?? "0")
                        {
                        total += value
                        
                        
                    }
                   
                    
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = "Rs" + "\(total)"
            cell.price.textColor = UIColor.greenColor()
            
        }else if indexPath.row == 3
        {
            request = NSFetchRequest(entityName: "AccountTable")
            request.predicate = nil
            do{
                
                
                total = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTable]
                
                for element in queryResult
                {
                    
                   
                    total += Double(element.amount!)
                    
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = "Rs" + "\(total)"
            cell.price.textColor = UIColor.purpleColor()
            
            
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
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableView.reloadData()
    }
    
    
    
    
    
}

