//
//  MovieDay.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

enum Day: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var name: String {
        switch self {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
}


struct MovieDay: CustomStringConvertible, Identifiable {
    let day: Day
    var id: Int
    var movie: Movie? = nil
    
    var description: String {
        """
            day: \(day.rawValue)
            id: \(id)
            movie: \(String(describing: movie))
            """
    }
    
}

extension Array where Element == MovieDay {
    
    func toDictionary() -> [String: Int] {
        self.reduce(into: [String: Int]()) { dictionary, movieDay in
            /// "1" (Sunday) : 101 (Movie ID)
            let weekdayNo = "\(movieDay.day.rawValue)"
            dictionary[weekdayNo] = movieDay.id
        }
    }
    
}
