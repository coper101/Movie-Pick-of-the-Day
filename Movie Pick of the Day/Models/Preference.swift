//
//  Preference.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

struct Preference: Codable, CustomStringConvertible {
    let language: String
    let includeAdult: Bool
    let genres: [String]
    
    var description: String {
        """
            language: \(language)
            includeAdult: \(includeAdult)
            genres: \(genres)
            """
    }
}
