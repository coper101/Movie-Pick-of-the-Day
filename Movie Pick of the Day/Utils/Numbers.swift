//
//  Numbers.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 14/2/23.
//

import Foundation

extension Double {
    
    /// Retains n number of decimal places of a decimal number without rounding up or down.
    /// Default is 1 decimal place
    /// - Parameter n: A value to specify the number of decimal places
    func toDp(n: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = n
        formatter.roundingMode = .down
        let number = NSNumber(value: self)
        let formatedNumber = formatter.string(from: number) ?? "0"
        return (self < 0) ? "0" : formatedNumber
    }
    
}
