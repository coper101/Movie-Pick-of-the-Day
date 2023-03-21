//
//  Date.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

extension String {
    
    /// Coverts Formatted String Date to Date
    /// e.g. 2022-12-14
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
}

extension Date {
    
    /// Formats the Date to `dd mm yy`
    /// e.g. 1 Jan 22
    func toDayMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Returns the Date Components
    func toDateComp() -> DateComponents {
        Calendar.current.dateComponents(
            [.day, .month, .year, .weekday],
            from: self
        )
    }
    
    /// Returns the n weekday starting from todays weekday to last weekday
    /// E.g. Sun (Today) ...Sat  =  1...7
    func getRemainingWeekDaysRange() -> ClosedRange<Int> {
        let lastWeekday = 7
        let todaysWeekday = self.toDateComp().weekday!
        return todaysWeekday...lastWeekday
    }
    
    /// Returns the remaining days till the last weekday
    /// E.g. Sun (Today)  =  6
    func getRemainingWeekDaysCount() -> Int {
        getRemainingWeekDaysRange().count - 1
    }
    
    func getEndOfWeekDate() -> Date {
        let lastWeekday = 7
        let weekday = self.toDateComp().weekday ?? 1
        let daysRemaining = lastWeekday - weekday
        
        guard daysRemaining > 0 else {
            return self
        }
        
        guard let endDate = Calendar.current.date(
            byAdding: .day, value: daysRemaining, to: self)
        else {
            return self
        }
        
        return endDate
    }
}

