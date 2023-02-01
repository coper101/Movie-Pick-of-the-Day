//
//  Icon.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

enum Icons: String {
    case player = "player-icon"
    case search = "search-icon"
    case close = "close-icon"
    case tmdbLogo = "tmdb-logo"
    case samplePoster = "sample-poster"
    var image: Image {
        Image(self.rawValue)
    }
}
