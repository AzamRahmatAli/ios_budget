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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var email: UITextField!
    @IBAction func sendMessage()
    {
       /* if email.text! != ""
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
        }*/
        
        saveDocument()
    }
    
    
    
    class MyDocument: UIDocument {
        
        var userText: String? = "Some Sample Text"
    }
    
    
    func  saveDocument() {
        
        document!.userText = email.text
        
        document?.saveToURL(ubiquityURL!,
                            forSaveOperation: .ForOverwriting,
                            completionHandler: {(success: Bool) -> Void in
                                if success {
                                    print("Save overwrite OK")
                                } else {
                                    print("Save overwrite failed")
                                }
        })
    }

    
    var document: MyDocument?
    var documentURL: NSURL?
    var ubiquityURL: NSURL?
    var metaDataQuery: NSMetadataQuery?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filemgr = NSFileManager.defaultManager()
        
        ubiquityURL =
            filemgr.URLForUbiquityContainerIdentifier(
                nil)!.URLByAppendingPathComponent("Documents")
        
        ubiquityURL =
            ubiquityURL?.URLByAppendingPathComponent("savefile.txt")
        
        metaDataQuery = NSMetadataQuery()
        
        metaDataQuery?.predicate =
            NSPredicate(format: "%K like 'savefile.txt'",
                        NSMetadataItemFSNameKey)
        metaDataQuery?.searchScopes =
            [NSMetadataQueryUbiquitousDocumentsScope]
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(EmailBackupViewController.metadataQueryDidFinishGathering(_:)),
                                                         name: NSMetadataQueryDidFinishGatheringNotification,
                                                         object: metaDataQuery!)
        
        metaDataQuery!.startQuery()
        
        
        
        
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
    
    
    
    
    
    
    func metadataQueryDidFinishGathering(notification: NSNotification) -> Void
    {
        let query: NSMetadataQuery = notification.object as! NSMetadataQuery
        
        query.disableUpdates()
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: NSMetadataQueryDidFinishGatheringNotification,
                                                            object: query)
        
        query.stopQuery()
        
        let results = query.results
        
        if query.resultCount == 1 {
            let resultURL =
                results[0].valueForAttribute(NSMetadataItemURLKey) as! NSURL
        
            document = MyDocument(fileURL: resultURL)
            
            document?.openWithCompletionHandler({(success: Bool) -> Void in
                if success {
                    print("iCloud file open OK")
                    self.email.text = self.document?.userText
                    self.ubiquityURL = resultURL
                } else {
                    print("iCloud file open failed")
                }
            })
        } else {
            document = MyDocument(fileURL: ubiquityURL!)
            
            document?.saveToURL(ubiquityURL!,
                                forSaveOperation: .ForCreating,
                                completionHandler: {(success: Bool) -> Void in
                                    if success {
                                        print("iCloud create OK")
                                    } else {
                                        print("iCloud create failed")
                                    }
            })
        }
    }
    
    
    
    
    
}