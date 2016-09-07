//
//  MenuTableViewController.swift
//  H&H
//
//  Created by Azad on 19/03/2016.
//  Copyright © 2016 Azad. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
       
        if(indexPath.row == 0)
        {
            
            
        }
      
        
        if(indexPath.row == 1)
        {
            
            
        }
        if(indexPath.row == 2)
        {
        
        cell.detailTextLabel?.text = "PKR"
        }
        return cell
    }*/
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
        
         if(indexPath.row == 2)
        {
            Helper.performUIUpdatesOnMain
                {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("currency") as! UINavigationController
            self.presentViewController(nextViewController, animated:true, completion:nil)
           
            }
        }

    }
      
    
    

   
    }

