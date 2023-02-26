//
//  AppDataRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import Foundation

// MARK: Protocol
protocol AppDataRepositoryType {
    
    /// Data
    var moviePicksOfTheWeek: [MovieDay] { get set }
    var moviePicksOfTheWeekPublisher: Published<[MovieDay]>.Publisher { get }
    
    var preference: Preference? { get set }
    var preferencePublisher: Published<Preference?>.Publisher { get }
    
    var weekEndDate: Date? { get set }
    var weekEndDatePublisher: Published<Date?>.Publisher { get }
    
    /// Setters and Getters
    func getMoviePicksOfTheWeek() -> [MovieDay]
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay])
    
    func getPreference() -> Preference?
    func setPreference(_ preference: Preference) -> Void
    
    func getWeekEndDate() -> Date?
    func setWeekEndDate(to endDate: Date)
}

enum Keys: String {
    case moviePicksOfTheWeek = "Movie_Picks_Of_The_Week"
    case preference = "Preference"
    case weekEndDate = "Week_End_Date"
}


// MARK: App Implementation
final class AppDataRepository: ObservableObject, AppDataRepositoryType {
    
    /// Data
    @Published var moviePicksOfTheWeek: [MovieDay] = []
    var moviePicksOfTheWeekPublisher: Published<[MovieDay]>.Publisher { $moviePicksOfTheWeek }
    
    @Published var preference: Preference?
    var preferencePublisher: Published<Preference?>.Publisher { $preference }
    
    @Published var weekEndDate: Date?
    var weekEndDatePublisher: Published<Date?>.Publisher { $weekEndDate }
    
    init() {
        moviePicksOfTheWeek = getMoviePicksOfTheWeek()
        preference = getPreference()
        weekEndDate = getWeekEndDate()
    }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksOfTheWeek() -> [MovieDay] {
        guard
            let data = LocalStorage.getData(forKey: .moviePicksOfTheWeek)
        else {
            return []
        }
        
        do {
            let moviePicks = try JSONDecoder().decode([MovieDay].self, from: data)
            return moviePicks
        } catch let error {
            print("couldn't decode movie days error: ", error.localizedDescription)
            return []
        }
    }
    
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay]) {
        do {
            // convert to json data
            let data = try JSONEncoder().encode(movieDays)
            // save data
            LocalStorage.setData(data, forKey: .moviePicksOfTheWeek)
            // update
            moviePicksOfTheWeek = getMoviePicksOfTheWeek()
            
        } catch let error {
            print("couldn't encode movie days error: ", error.localizedDescription)
        }
    }
    
    /// - Preference
    func getPreference() -> Preference? {
        let dictionary: [String: Any]? = LocalStorage.getDictionary(forKey: .preference)
        guard let dictionary else {
            print("getPreference error: preference dictionary nil")
            return nil
        }
        let preference: Preference? = DictionaryCoder.getType(of: dictionary)
        guard let preference else {
            print("getPreference error: preference is nil")
            return nil
        }
        return preference
    }
    
    func setPreference(_ preference: Preference) {
        let dictionary = DictionaryCoder.getDictionary(of: preference)
        guard let dictionary else {
            print("setPreference error: preference dictionary nil")
            return
        }
        LocalStorage.setItem(dictionary, forKey: .preference)
        self.preference = getPreference()
    }
    
    /// - Week Tracker
    func getWeekEndDate() -> Date? {
        guard let endDate = LocalStorage.getItem(forKey: .weekEndDate) else {
            return nil
        }
        return endDate as? Date
    }
    
    func setWeekEndDate(to endDate: Date) {
        LocalStorage.setItem(endDate, forKey: .weekEndDate)
        self.weekEndDate = getWeekEndDate()
    }
    
}


// MARK: Test Implementation
class MockAppDataRepository: AppDataRepositoryType {
    
    /// Data
    @Published var moviePicksOfTheWeek: [MovieDay] = []
    var moviePicksOfTheWeekPublisher: Published<[MovieDay]>.Publisher { $moviePicksOfTheWeek }
    
    @Published var preference: Preference?
    var preferencePublisher: Published<Preference?>.Publisher { $preference }
    
    @Published var weekEndDate: Date?
    var weekEndDatePublisher: Published<Date?>.Publisher { $weekEndDate }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksOfTheWeek() -> [MovieDay] {
        [
            TestData.createMovieDay(movieID: 104, day: .wednesday),
            TestData.createMovieDay(movieID: 105, day: .thursday),
            TestData.createMovieDay(movieID: 106, day: .friday),
            TestData.createMovieDay(movieID: 107, day: .saturday),
        ]
    }
    
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay]) {
        moviePicksOfTheWeek = movieDays
    }
    
    /// - Preference
    func getPreference() -> Preference? {
        .init(
            language: "en",
            originalLanguage: "en",
            includeAdult: false,
            genres: [
                .init(id: 1, name: "Action"),
                .init(id: 2, name:  "Adventure")
            ]
        )
    }
    
    func setPreference(_ preference: Preference) {
        self.preference = preference
    }
    
    /// - Week Tracker
    func getWeekEndDate() -> Date? {
        "2023-01-12T00:00:00+00:00".toDate()
    }
    
    func setWeekEndDate(to endDate: Date) {
        self.weekEndDate = endDate
    }
}

