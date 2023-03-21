//
//  Shuffle.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

extension Array where Element == Movie {
    
    /// Returns Movies to keep that was shuffled
    /// - Parameter keep: The number of Movies to keep
    func shuffle(keep: Int) -> [Movie]? {
        let validRange = (0...self.count).contains(keep)
        guard validRange else {
            return nil
        }
        let shuffledItems = self.shuffled()
        let slicedItems = shuffledItems.prefix(keep)
        return Array(slicedItems)
    }
    
}

extension Array where Element == MovieDay {
    
    /// Returns today's Movie Day
    /// - Parameter todaysDate: The today's Date
    func getTodaysMovieDay(todaysDate: Date, _ withMovie: Bool = true) -> MovieDay? {
        guard
            let todaysWeekDay = todaysDate.toDateComp().weekday,
            let movieDay = self.first(where: { $0.day.rawValue == todaysWeekDay })
        else {
            return nil
        }
        guard
            withMovie,
            movieDay.movie != nil
        else {
            return nil
        }
        return movieDay
    }
    
    /// Returns the Movie Days tomorrow onwards
    /// - Parameter todaysDate: The today's Date
    func getNextMovieDays(todaysDate: Date, _ withMovie: Bool = true) -> [MovieDay] {
        guard
            let todaysWeekDay = todaysDate.toDateComp().weekday,
            let todaysMovieDay = self.first(where: {
                $0.day.rawValue == todaysWeekDay
            })
        else {
            return []
        }
        let nextMovies = self
            .filter { $0.day.rawValue > todaysMovieDay.day.rawValue }
            .sorted(by: <)
        
        guard withMovie else {
            return nextMovies
        }
        return nextMovies.filter { $0.movie != nil }
    }
    
}
