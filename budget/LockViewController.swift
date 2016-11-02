//
//  LockViewController.swift
//  budget
//
//  Created by Azam Rahmat on 11/2/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class LockViewController: UIViewController , UITextFieldDelegate{

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
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        if (textField.text! + string) == "1234"
        {
            
           
            textField.text = "1234"
            
            if Helper.firstStart
            {
            
            
            self.performSegueWithIdentifier("unlocked", sender: nil)
                Helper.firstStart = false
                return true
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        return true
       
    }
    
    
    override func viewDidLoad() {
      
        
        password.delegate = self
        appName.text = StringFor.name["appName"]
        
    }
    
    


}
