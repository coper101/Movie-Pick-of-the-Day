//
//  Type.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import Foundation

enum Types: String {
    case amaranthBold = "Amaranth-Bold"
    case interBold = "Inter-Bold"
    case interExtraBold = "Inter-ExtraBold"
    case interSemiBold = "Inter-SemiBold"
    var value: String {
        self.rawValue
    }
}
