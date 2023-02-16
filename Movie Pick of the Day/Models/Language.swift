//
//  Language.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

struct Language: Decodable {
    let iso6391: String?
    let englishName: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case englishName = "english_name"
        case name
    }
}

extension Language: Comparable {
    static func < (lhs: Language, rhs: Language) -> Bool {
        guard
            let name1 = lhs.englishName,
            let name2 = rhs.englishName
        else {
            return false
        }
        return name1 < name2
    }
}
