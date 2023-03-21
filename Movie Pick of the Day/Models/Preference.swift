//
//  Preference.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

struct Preference: Codable {
    var language: String
    var originalLanguage: String
    var includeAdult: Bool
    var genres: [Genre]
    
    var summary: String {
        var summary = "\(originalLanguage.uppercased())"
        summary += ", \(includeAdult ? "Include Adult" : "Exclude Adult")"
        if !genres.isEmpty {
            summary += ", " +  genres.compactMap(\.name).joined(separator: ", ")
        } else {
            summary += ", Any Genre"
        }
        return summary
    }
}

extension Preference: Equatable {
    static func == (lhs: Preference, rhs: Preference) -> Bool {
        lhs.language == rhs.language &&
        lhs.originalLanguage == rhs.originalLanguage &&
        lhs.includeAdult == rhs.includeAdult &&
        lhs.genres == rhs.genres
    }
}

extension Preference: CustomDebugStringConvertible {
    
    var debugDescription: String {
        """
            language: \(language)
            original Language: \(originalLanguage)
            include Adult: \(includeAdult)
            genres: \(genres)
            """
    }
}
