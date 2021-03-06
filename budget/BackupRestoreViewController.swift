//
//  BackupRestoreViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/7/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class BackupRestoreViewController: UIViewController {
    @IBOutlet weak var restore: UIButton!
    @IBOutlet weak var backup: UIButton!
    /*  let cloudDataManager : CloudDataManager = CloudDataManager()
     @IBAction func dl(sender: UIButton) {
     cloudDataManager.deleteFilesInDirectory(cloudDataManager.getDocumentDiretoryURL())
     
     }
     
     @IBAction func gfi(sender: UIButton) {
     cloudDataManager.moveFileToLocal()
     }
     
     @IBAction func fr(sender: UIButton) {
     let url: NSURL? = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
     let fileManager = NSFileManager.defaultManager()
     let enumerator = fileManager.enumeratorAtPath(url!.path!)
     while let file = enumerator?.nextObject() as? String {
     print("fileexist = ", file)
     }
     
     }*/
    var nsurl : NSURL?
    
    @IBOutlet weak var backupFile: UILabel!
    
    @IBAction func RestoreBackupFile(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Restore from \(StringFor.name["appName"]!) Backup", message:  "You are about to restore a previous backup into \(StringFor.name["appName"]!). This will overwrite all existing data in \(StringFor.name["appName"]!). Would you like to continue", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) //?.URLByAppendingPathComponent("Documents")
            
            let fileManager: NSFileManager = NSFileManager()
            do{
                
                let fileList: NSArray = try fileManager.contentsOfDirectoryAtURL(iCloudDocumentsURL!, includingPropertiesForKeys: nil, options:[])
                
                for s in fileList {
                    
                    print(s)
                    if String(s).rangeOfString("MBBackup") != nil
                    {
                        if self.checkAndDownloadBackupFile(s as? NSURL)
                        {
                            
                            Restore.clearCoreDataStore(s as! NSURL)
                            
                            self.backupFile.text = "Backup data has been restored"
                            
                        }
                    }
                    
                }
            }
            catch{
                
            }
            
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("no")
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    @IBAction func sendMessage()
    {
        
        
        let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
        
        //is iCloud working?
        if  iCloudDocumentsURL != nil {
            
            //Create the Directory if it doesn't exist
            if (!NSFileManager.defaultManager().fileExistsAtPath(iCloudDocumentsURL!.path!, isDirectory: nil)) {
                //This gets skipped after initial run saying directory exists, but still don't see it on iCloud
                do
                {
                    
                    try NSFileManager.defaultManager().createDirectoryAtURL(iCloudDocumentsURL!, withIntermediateDirectories: true, attributes: nil)
                }
                catch let error as NSError {
                    error.description
                }
            }
        } else {
            backupFile.hidden = false
            backupFile.text = "iCloud is NOT working!"
            return
        }
        
        
        
        //Set up directorys
        let localDocumentsURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask).last
        
        //Add txt file to my local folder
        let myTextString = NSString(string: Backup.doBackup() ?? "")
        let myLocalFile = localDocumentsURL!.URLByAppendingPathComponent("datafile.txt")
        do
        {
            
            
            try myTextString.writeToURL(myLocalFile, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch
        {
            
            
            print("Error saving to local DIR")
            
        }
        
        
        //If file exists on iCloud remove it
        var isDir:ObjCBool = false
        if (NSFileManager.defaultManager().fileExistsAtPath(iCloudDocumentsURL!.path!, isDirectory: &isDir)) {
            do
            {
                
                
                try NSFileManager.defaultManager().removeItemAtURL(iCloudDocumentsURL!)
            }
            catch let error as NSError
            {
                print(error.localizedDescription);
            }
        }
        do{
            
            
            //copy from my local to iCloud
            try NSFileManager.defaultManager().copyItemAtURL(localDocumentsURL!, toURL: iCloudDocumentsURL!)
            
            
        }
        catch let error as NSError
        {
            print(error.localizedDescription);
        }
        
        
        
        backupFile.text = "New Backup Done"
        backupFile.hidden = false
        
        
        
        
    }
    func clearTempFolder() {
        
        
        // Create a FileManager instance
        
        let fileManager = NSFileManager.defaultManager()
        
        // Delete 'hello.swift' file
        
        do {
            try fileManager.removeItemAtPath("datafile.txt")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backup.layer.borderColor = UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1).CGColor
        restore.layer.borderColor = UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1).CGColor
        restore.hidden = true
        backupFile.hidden = true
        //let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) //?.URLByAppendingPathComponent("Documents")
        let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
        
        //is iCloud working?
        if  iCloudDocumentsURL != nil {
            
            
            let fileManager: NSFileManager = NSFileManager()
            do{
                
                let fileList: NSArray = try fileManager.contentsOfDirectoryAtURL(iCloudDocumentsURL!, includingPropertiesForKeys: nil, options:[])
                
                
                for s in fileList {
                    print(s)
                    if String(s).rangeOfString("datafile.txt") != nil
                    {
                        
                        backupFile.text = "Backup file exist"
                        backupFile.hidden = false
                        restore.hidden = false
                    }
                        
                        
                    else if backupFile.hidden
                    {
                        backupFile.text = "Backup file not exist"
                        backupFile.hidden = false
                    }
                    
                    
                    
                }
            }
            catch{
                
            }
        } else {
            backupFile.hidden = false
            backupFile.text = "iCloud is NOT working!"
            
        }
    }
    
    func checkAndDownloadBackupFile(iCloudDocumentsURL : NSURL?) -> Bool{
        if(iCloudDocumentsURL != nil){
            let file = iCloudDocumentsURL!.URLByAppendingPathComponent("datafile.txt")
            let filemanager = NSFileManager.defaultManager();
            
            if !filemanager.fileExistsAtPath(file.path!){
                
                if filemanager.isUbiquitousItemAtURL(file) {
                    
                    _ = UIAlertController(title: "Warning", message:  "iCloud is currently busy syncing the backup files. Please try again in a few minutes.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
                    _ = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    
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
    
    
    
    
    
    
    // MARK: MFMailComposeViewControllerDelegate
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
}