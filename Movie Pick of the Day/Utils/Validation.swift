//
//  Validation.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

extension String {
    
    /// Returns true if text is empty without empty spaces
    func isEmptyField() -> Bool {
        self.trimmingCharacters(in: .whitespaces) == ""
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
    
}
