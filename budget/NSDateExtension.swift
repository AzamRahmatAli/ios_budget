//
//  NSDateExtension.swift
//  budget
//
//  Created by Azam Rahmat on 8/5/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation


extension NSDate {
    
    func startOfMonth(dateComponents: NSDateComponents) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        
        var startOfMonth = calendar.dateFromComponents(dateComponents)
        
        startOfMonth = startOfMonth!.dateByAddingTimeInterval(5 * 60 * 60)
        return startOfMonth
    }
    
    func dateByAddingMonths(dateComponents: NSDateComponents) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        
        
        let date = calendar.dateFromComponents(dateComponents)
        
        return calendar.dateByAddingUnit(.Month, value: 1, toDate: date!, options: [])!
        
    }
    
    func endOfMonth(dateComponents: NSDateComponents) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        if let plusOneMonthDate = dateByAddingMonths(dateComponents) {
            
            let plusOneMonthDateComponents = calendar.components([.Year, .Month], fromDate: plusOneMonthDate)
            
            var endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
            endOfMonth = endOfMonth!.dateByAddingTimeInterval(5 * 60 * 60)
            return endOfMonth
        }
        
        return nil
    }
}