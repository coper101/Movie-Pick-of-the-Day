//
//  Icon.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

enum Icons: String {
    case icon = "iconName"
    var image: Image {
        Image(self.rawValue)
    }
}
