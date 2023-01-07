//
//  Genre.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

struct Genre: Decodable, CustomDebugStringConvertible {
    let id: Int?
    let name: String?
    
    var debugDescription: String {
        """
            
            id: \(id ?? 0)
            name: \(name ?? "")
            
            """
    }
}
