//
//  Animation.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

extension Animation {
    
    static func slowPop() -> Self {
        Animation.spring(response: 0.9, dampingFraction: 0.5)
    }
}
