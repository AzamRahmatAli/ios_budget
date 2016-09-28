//
//  EmailBackupViewController.swift
//  budget
//
//  Created by Azam Rahmat on 9/27/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class EmailBackupViewController: UIViewController ,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var hideMeLabel: UILabel!
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    override func viewDidLoad() {
        super.viewDidLoad()
        /*do{
            var fetchRequest = NSFetchRequest(entityName: "AccountTypeTable")
            
            
            
            var fetchedData : [AnyObject]? = try managedObjectContext?.executeFetchRequest(fetchRequest)
            var names : [String] = []
            
            for element in (fetchedData! as! [AccountTypeTable])
                
            {
                names.append(element.name!)
            }
            var dictionary : [String : AnyObject] = ["AccountTypeTable" : names]
            
            
            
            fetchRequest = NSFetchRequest(entityName: "CategoryTable")
            
            
            
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            var sets  = [[String:AnyObject]]()
            sets = []
            for element in (fetchedData! as! [CategoryTable])
                
            {
                sets.append(["name" :element.name!, "icon" :element.icon!])
            }
            dictionary["CategoryTable"] =  sets
            
            
            
            fetchRequest = NSFetchRequest(entityName: "AccountTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [AccountTable])
                
            {
                sets.append(["name" :element.name!, "amount" :element.amount! , "icon" :element.icon! , "createdat" : String(element.createdAt!), "accounttype": element.accountType!.name!])
            }
            dictionary["AccountTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "SubCategoryTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [SubCategoryTable])
                
            {
                sets.append(["name" :element.name!, "amount" :element.amount ?? "" , "icon" :element.icon! , "category": element.category!.name!])
            }
            dictionary["SubCategoryTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "IncomeTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [IncomeTable])
                
            {
                sets.append(["name" :element.category!, "amount" :element.amount! , "note" :element.note! , "createdat" : String(element.createdAt!), "accountname" : element.account?.name ?? "", "accounttype" : element.account?.accountType?.name ?? ""])
            }
            dictionary["IncomeTable"] =  sets
            
            
            fetchRequest = NSFetchRequest(entityName: "ExpenseTable")
            fetchedData = try managedObjectContext?.executeFetchRequest(fetchRequest)
            sets  = []
            for element in (fetchedData! as! [ExpenseTable])
                
            {
                var a : [String : AnyObject] = ["amount" :element.amount! , "note" :element.note!, "reciept" :/*element.reciept ??*/ "", "createdat" : String(element.createdAt!)]
                a["accountname"] = element.account?.name ?? ""
                a["accounttype"] =  element.account?.accountType?.name ?? ""
                a["subcategory"] = element.subCategory!.name!
                a["category"] = element.subCategory!.category!.name!
                sets.append(a)
                
            }
            dictionary["ExpenseTable"] =  sets
            
            
            
            /*let dataInArr:NSArray = ManagedParser.convertToArray(fetchedGuest);
             NSLog("dataInArr \(dataInArr)");*/
            
            
            let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            let cdata = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            // print(cdata)
            if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.json")
                /*if let file = NSFileHandle(forWritingAtPath:"datafile.json") {
                 file.writeData(jsonData)
                 }*/
                //writing
                do {
                    try cdata.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                    print(cdata)
                }
                catch {/* error handling here */}
            }
            // let myEntities : [String] = Array(objectModel!.entitiesByName.keys)
            // print(myEntities)
            
        }
        catch let error {
            print("error : ", error)
        }*/
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var email: UITextField!
    @IBAction func sendMessage()
    {
        if email.text! != ""
        {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                
                
                    
                
                
            } else {
                self.showSendMailErrorAlert()
            }
            
        }
            
            
        else
        {
            
            showAlert("Enter a email Address")
        }
    }
    /*if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
     let filePath = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.json")
     
     
     print("File path loaded.")
     
     if let fileData = NSData(contentsOfFile: filePath)
     {
     print("File data loaded.")
     mailComposerVC.addAttachmentData(fileData, mimeType: "application/json", fileName: "datafile.json")
     
     }
     }
     */
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let date = String(NSDate()).componentsSeparatedByString(" ").first!
        
        mailComposerVC.setSubject("MyBudget Backup \(date)")
        
        mailComposerVC.setToRecipients([email.text!])
        
        mailComposerVC.setMessageBody("Open this email on your iPhone/iPad. \n\n Tap the attachment below to restore.", isHTML: false)
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.json")
            
            print("File path loaded.")
            
            if let data = NSData(contentsOfURL : path)
            {
                print("File data loaded.")
                mailComposerVC.addAttachmentData(data, mimeType: "text/json", fileName: "datafile")
                
            }
        }
        
        return mailComposerVC
        
        
    }
    
    func showSendMailErrorAlert() {
        
        
        _ = UIAlertController(title: "Could Not Send Email", message:  "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        _ = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        hideMeLabel.hidden = true
        controller.dismissViewControllerAnimated(true, completion: nil)
        if result == MFMailComposeResultSent
        {
            
            responseLabel.text = "Email backup: sent"
        }else{
            responseLabel.text = "Email backup: cancelled"
        }
    }
    @IBAction func goBack(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showAlert(ErrMSG : String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: "Alert", message: ErrMSG, preferredStyle: .Alert)
        
        // Initialize Actions
        let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            print("")
        }
        
        
        
        // Add Actions
        alertController.addAction(yesAction)
        
        
        // Present Alert Controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}