//
//  Genre.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

struct Genre: Codable {
    let id: Int?
    let name: String?
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        lhs.name == rhs.name && lhs.id == rhs.id
    }
}

extension Genre: Comparable {
    static func < (lhs: Genre, rhs: Genre) -> Bool {
        guard
            let name1 = lhs.name,
            let name2 = rhs.name
        else {
            return false
        }
        return name1 < name2
    }
}
