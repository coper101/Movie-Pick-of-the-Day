//
//  Preference.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

struct Preference: Codable, CustomStringConvertible {
    var language: String
    var originalLanguage: String
    var includeAdult: Bool
    var genres: [String]
    
    var description: String {
            """
            language: \(language)
            originalLanguage: \(originalLanguage)
            includeAdult: \(includeAdult)
            genres: \(genres)
            """
    }
    
    var summary: String {
        var summary = "\(originalLanguage.uppercased())"
        summary += ", \(includeAdult ? "Adult" : "Non-Adult")"
        summary += ", " +  genres.joined(separator: ", ")
        return summary
    }
}
