//
//  BackupRestoreViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/7/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class BackupRestoreViewController: UIViewController {


    
    var nsurl : NSURL?
    
    @IBOutlet weak var backupFile: UILabel!
   
    @IBAction func RestoreBackupFile(sender: UIButton) {
        
        
        
        let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) //?.URLByAppendingPathComponent("Documents")
        
        let fileManager: NSFileManager = NSFileManager()
        do{
            
            let fileList: NSArray = try fileManager.contentsOfDirectoryAtURL(iCloudDocumentsURL!, includingPropertiesForKeys: nil, options:[])
           
            for s in fileList {
                
                print(s)
                if checkAndDownloadBackupFile(s as? NSURL)
                {
                    print("file is uptodate")
                    Helper.clearCoreDataStore(s as! NSURL)
                    //clearTempFolder((s as! NSURL))
                }
                
            }
        }
        catch{
            
        }
        
    }
    @IBAction func sendMessage()
    {
      
        
        let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents")
        
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
            print("iCloud is NOT working!")
            //  return
        }
        
        
        
        //Set up directorys
        let localDocumentsURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask).last
        
        //Add txt file to my local folder
        let myTextString = NSString(string: Helper.doBackup() ?? "")
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
    clearTempFolder()
        backupFile.hidden = true
        let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) //?.URLByAppendingPathComponent("Documents")
        
        let fileManager: NSFileManager = NSFileManager()
        do{
            
            let fileList: NSArray = try fileManager.contentsOfDirectoryAtURL(iCloudDocumentsURL!, includingPropertiesForKeys: nil, options:[])
            
            
            for s in fileList {
                if String(s).rangeOfString("Documents") != nil
                {
                print(s)
                if checkAndDownloadBackupFile(s as? NSURL)
                {
                    print("file is uptodate")
                  backupFile.text = "Backup file exist"
                    backupFile.hidden = false
                    }
                else
                {
                    backupFile.text = "Backup file not exist"
                    backupFile.hidden = false
                    }
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