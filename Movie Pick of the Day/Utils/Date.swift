//
//  Date.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

extension String {
    
    /// Converts ISO String Date to Date
    func toDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self) ?? Date()
    }
    
}

extension Date {
    
    /// Returns the Date Components
    func toDateComp() -> DateComponents {
        Calendar.current.dateComponents(
            [.day, .month, .year, .weekday],
            from: self
        )
    }
    
    /// Returns the n weekday starting from todays weekday to last weekday
    /// E.g. Thu (Today) ...Sat == 5...7
    func getRemainingWeekDaysRange() -> ClosedRange<Int> {
        let lastWeekday = 7
        let todaysWeekday = self.toDateComp().weekday!
        return todaysWeekday...lastWeekday
    }
    
    /// Returns the remaining days till the last weekday
    func getRemainingWeekDaysCount() -> Int {
        return getRemainingWeekDaysRange().count + 1
    }
    
}

