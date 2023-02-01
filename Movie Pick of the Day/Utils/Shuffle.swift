//
//  Shuffle.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

extension Array where Element == Movie {
    
    /// Returns Movies to keep that was shuffled
    /// - Parameter keep: The number of Movies to keep
    func shuffle(keep: Int) -> [Movie]? {
        let validRange = (0...self.count).contains(keep)
        guard validRange else {
            return nil
        }
        let shuffledItems = self.shuffled()
        let slicedItems = shuffledItems.prefix(keep)
        return Array(slicedItems)
    }
    
}
