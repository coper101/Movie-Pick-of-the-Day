//
//  Language.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

struct Language: Decodable, CustomDebugStringConvertible {
    let iso6391: String?
    let englishName: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case englishName = "english_name"
        case name
    }
    
    var debugDescription: String {
        """
            
            iso6391: \(iso6391 ?? "")
            english name: \(englishName ?? "")
            name: \(name ?? "")
            
            """
    }
}
