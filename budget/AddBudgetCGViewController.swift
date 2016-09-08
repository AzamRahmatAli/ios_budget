//
//  AddBudgetCGViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/19/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData


class AddBudgetCGViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var addCategory = false
    var addSubCategory = false
    var category = ""
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBudgetCGViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
            }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func save(sender: AnyObject) {
       
        if name.text != "" && selectedImage != ""
        {
        if addSubCategory
        {
            
            
            
                    if let budget = NSEntityDescription.insertNewObjectForEntityForName("SubCategoryTable", inManagedObjectContext: managedObjectContext!) as? SubCategoryTable
                    {
                            
                            budget.name = name.text
                            
                            budget.icon = selectedImage
                            budget.category = CategoryTable.category(category, inManagedObjectContext: managedObjectContext!)
                        
                            do{
                                try self.managedObjectContext?.save()
                                navigationController?.popViewControllerAnimated(true)
                                //receivedMessageFromServer()
                                
                            }
                            catch{
                                
                            }
                       
                    }
            
            }
            
   
        else if addCategory  {
            
            
            if let budget = NSEntityDescription.insertNewObjectForEntityForName("CategoryTable", inManagedObjectContext: managedObjectContext!) as? CategoryTable
            {
                
               
                    
                    budget.name = name.text
                    budget.icon = selectedImage
                    
                
                    
                
                    
                    do{
                        try self.managedObjectContext?.save()
                        navigationController?.popViewControllerAnimated(true)
                        //receivedMessageFromServer()
                        
                    }
                    catch{
                        
                    }
                    
                
                
                
            }
        }
         }
       
        
    }
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
   
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    let images = ["Food","Fuel","Gas","groceries","Restaurant","home","dashboard"]
    var selectedImage = ""
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        selectedImage = images[indexPath.row]
       
        //let cell = collectionView.cellForItemAtIndexPath(indexPath)
       // cell!.layer.borderWidth = 2.0
        //cell!.layer.borderColor = UIColor.grayColor().CGColor
        // cell!.contentView.backgroundColor = UIColor.greenColor()
    }/*
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor()
    }*/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvcell", forIndexPath: indexPath) as! CustomCollectionViewCell
        // cell.myImage.image = imageAry[indexPath.row]//UIImage(named:"myPic")
        
        
        cell.img?.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
}
