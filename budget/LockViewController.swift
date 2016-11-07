//
//  LockViewController.swift
//  budget
//
//  Created by Azam Rahmat on 11/2/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import LocalAuthentication
import Foundation
import UIKit
import MessageUI


class LockViewController: UIViewController , UITextFieldDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var appName: UILabel!
    
    /*override func viewDidLoad() {
     super.viewDidLoad()
     appName.text = StringFor.name["appName"]
     print(password!)
     // Do any additional setup after loading the view.
     }*/
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    
    
  
    
    
        
        @IBAction func sendEmailButtonTapped(sender: AnyObject) {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        
        func configuredMailComposeViewController() -> MFMailComposeViewController {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            
            mailComposerVC.setToRecipients(["nurdin@gmail.com"])
            mailComposerVC.setSubject("Sending you an in-app e-mail...")
            mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
            
            return mailComposerVC
        }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        if (textField.text! + string) == Helper.password
        {
            Helper.lockActivated = false
            
            
            if Helper.firstStart
            {
                
                
                self.performSegueWithIdentifier("unlocked", sender: nil)
                Helper.firstStart = false
                
            }
            else{
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
        return true
        
    }
    
    
    override func viewDidLoad() {
        
        Helper.lockActivated = true
        password.delegate = self
        appName.text = StringFor.name["appName"]
        
        
        
        
        
        let authContext : LAContext = LAContext()
        var error : NSError?
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error ){
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentication is needed to access \(StringFor.name["appName"]!)", reply: { (wasSuccessful : Bool, error : NSError?) in
                if wasSuccessful
                {
                    
                    Helper.lockActivated = false
                    if Helper.firstStart
                    {
                        Helper.performUIUpdatesOnMain()
                            {
                                
                                self.performSegueWithIdentifier("unlocked", sender: nil)
                        }
                        Helper.firstStart = false
                        
                        
                    }
                    else{
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                else{
                    Helper.performUIUpdatesOnMain()
                        {
                            self.password.becomeFirstResponder()
                    }
                }
            })
        }
        
        
        
        
    }
    
    
    
    
    
    
}
