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
