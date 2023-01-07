//
//  Color.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

enum Colors: String {
    case background = "Black"
    case primary = "White"
    var color: Color {
        Color(self.rawValue)
    }
}
