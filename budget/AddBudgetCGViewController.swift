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
    var category : CategoryTable?
    let images = (1...100).map{ i in
        "image" + String(i)
    }
    var selectedImage = ""
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    @IBOutlet weak var name: UITextField!

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
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
                            budget.category = CategoryTable.category(category!.name!, image: category!.icon!, inManagedObjectContext: managedObjectContext!)
                        
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
   
    
   
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        dismissKeyboard()
        
        selectedImage = images[indexPath.row]
       
    
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvcel", forIndexPath: indexPath) as! CustomCollectionViewCell
      
        
        
        cell.img?.image = UIImage(named: images[indexPath.row])
        cell.img?.tintColor = Helper.colors[indexPath.row % 5]
        
        return cell
    }
    
}
