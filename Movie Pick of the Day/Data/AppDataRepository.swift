//
//  AppDataRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import Foundation

enum Day: String {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
}

extension Int {
    
    func toDay() -> Day {
        if self == 1 {
            return .sunday
        } else if self == 2 {
            return .monday
        } else if self == 3 {
            return .tuesday
        } else if self == 4 {
            return .wednesday
        } else if self == 5 {
            return .thursday
        } else if self == 6 {
            return .friday
        } else if self == 7 {
            return .saturday
        } else {
            return .sunday
        }
    }
    
}


struct MovieDay: CustomStringConvertible {
    let day: String
    let id: Int
    var movie: Movie? = nil
    
    var theDay: Day {
        Day(rawValue: day) ?? .sunday
    }
    
    var description: String {
        """
            day: \(theDay.rawValue)
            id: \(id)
            movie: \(String(describing: movie))
            """
    }
}

enum Keys: String {
    case moviePickIDsOfTheWeek = "Movie_Pick_IDs_Of_The_Week"
}

protocol AppDataRepositoryType {
    
    var moviePickIDsOfTheWeek: [MovieDay] { get }
    var moviePickIDsOfTheWeekPublisher: Published<[MovieDay]>.Publisher { get }
    
    func getMoviePicksIDsOfTheWeek() -> [MovieDay]
    func setMoviePicksIDsOfTheWeek(_ movieDays: [MovieDay])
}

final class AppDataRepository: ObservableObject, AppDataRepositoryType {
    
    @Published var moviePickIDsOfTheWeek: [MovieDay] = []
    var moviePickIDsOfTheWeekPublisher: Published<[MovieDay]>.Publisher { $moviePickIDsOfTheWeek }
    
    init() {
        moviePickIDsOfTheWeek = getMoviePicksIDsOfTheWeek()
    }
    
    /// getters
    func getMoviePicksIDsOfTheWeek() -> [MovieDay] {
        let dictionary = LocalStorage.getDictionary(forKey: .moviePickIDsOfTheWeek)
        return dictionary.map { MovieDay(day: $0, id: $1) }
    }
    
    /// setters
    func setMoviePicksIDsOfTheWeek(_ movieDays: [MovieDay]) {
        LocalStorage.setItem(
            movieDays.toDictionary(),
            forKey: .moviePickIDsOfTheWeek
        )
        moviePickIDsOfTheWeek = getMoviePicksIDsOfTheWeek()
    }
}

extension Array where Element == MovieDay {
    
    func toDictionary() -> [String: Int] {
        self.reduce(into: [String: Int]()) { dictionary, movieDay in
            dictionary[movieDay.day] = movieDay.id
        }
    }
    
}
