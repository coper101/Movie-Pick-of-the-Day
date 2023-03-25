//
//  WidgetKind.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 25/3/23.
//

import Foundation

enum WidgetKind: String {
    case main = "Movie_Pick_Of_the_Day_Widget"
    var name: String {
        self.rawValue
    }
}
