//
//  Color.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

enum Colors: String {
    case secondary = "secondary"
    case background = "background"
    case backgroundLight = "background-light"
    case onBackground = "on-background"
    var color: Color {
        Color(self.rawValue)
    }
}
