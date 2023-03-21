//
//  Page.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 21/3/23.
//

import Foundation

class Pager {
    
    static func hasNewItems(current: Int, total: Int?) -> Bool {
        guard current <= total ?? 1 else {
            return false
        }
        return true
    }
    
}
