//
//  Icon.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

enum Icons: String {
    
    // Icons
    case player = "player-icon"
    case search = "search-icon"
    case close = "close-icon"
    case warning = "warning-icon"
    
    // Logo
    case tmdbLogo = "tmdb-logo"
    
    // Sample Poster (for Testing)
    case samplePoster = "sample-poster"
    
    // Illustrations
    case noInternetConnectionIllus = "no-internet-illustration"
    case noResultsIllus = "no-results-illustration"

    var image: Image {
        Image(self.rawValue)
    }
}
