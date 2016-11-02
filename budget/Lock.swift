//
//  Lock.swift
//  budget
//
//  Created by Azam Rahmat on 11/1/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class Lock: UIView  , UITextFieldDelegate{

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var appName: UILabel!
    var unlocked = false
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
                self.hidden = true
                unlocked = true
                textField.text = ""
                return false
            }
            return true
        
    
        
    }
    override func awakeFromNib() {
        self.hidden = false
        unlocked = false
        password.delegate = self
        appName.text = StringFor.name["appName"]
        
    }
    
    class func instanceFromNib() -> Lock {
        return UINib(nibName: "Lock", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! Lock
    }

}
