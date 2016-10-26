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
         let seconds = Double(NSTimeZone.localTimeZone().secondsFromGMT)
        startOfMonth = startOfMonth!.dateByAddingTimeInterval(seconds)
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
            let seconds = Double(NSTimeZone.localTimeZone().secondsFromGMT)
            endOfMonth = endOfMonth!.dateByAddingTimeInterval(seconds - 1)
            return endOfMonth
        }
        
        return nil
    }
}