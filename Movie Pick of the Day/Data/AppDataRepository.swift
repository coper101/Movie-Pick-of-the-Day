//
//  AppDataRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import Foundation
import OSLog

// MARK: Protocol
protocol AppDataRepositoryType {
    
    /// Data
    var moviePicksOfTheWeek: [MovieDay] { get set }
    var moviePicksOfTheWeekPublisher: Published<[MovieDay]>.Publisher { get }
    
    var preference: Preference? { get set }
    var preferencePublisher: Published<Preference?>.Publisher { get }
    
    var weekEndDate: Date? { get set }
    var weekEndDatePublisher: Published<Date?>.Publisher { get }
    
    var currentMoviesPreferredPage: Int { get set }
    var currentMoviesPreferredPagePublisher: Published<Int>.Publisher { get }
    
    /// Setters and Getters
    func getMoviePicksOfTheWeek() -> [MovieDay]
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay])
    
    func getPreference() -> Preference?
    func setPreference(_ preference: Preference) -> Void
    
    func getWeekEndDate() -> Date?
    func setWeekEndDate(to endDate: Date)
    
    func getCurrentMoviesPreferredPage() -> Int
    func setCurretMoviesPreferredPage(_ page: Int) -> Void
}

enum Keys: String {
    case moviePicksOfTheWeek = "Movie_Picks_Of_The_Week"
    case preference = "Preference"
    case weekEndDate = "Week_End_Date"
    case currentMoviesPreferredPage = "Current_Movies_Preferred_Page"
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
    
    @Published var currentMoviesPreferredPage: Int = 0
    var currentMoviesPreferredPagePublisher: Published<Int>.Publisher { $currentMoviesPreferredPage }
    
    init() {
        moviePicksOfTheWeek = getMoviePicksOfTheWeek()
        preference = getPreference()
        weekEndDate = getWeekEndDate()
        currentMoviesPreferredPage = getCurrentMoviesPreferredPage()
    }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksOfTheWeek() -> [MovieDay] {
        guard
            let data = LocalStorage.getData(forKey: .moviePicksOfTheWeek)
        else {
            Logger.appModel.debug("getMoviePicksOfTheWeek - empty")
            return []
        }
        do {
            let moviePicks = try JSONDecoder().decode([MovieDay].self, from: data)
            Logger.appModel.debug("getMoviePicksOfTheWeek - \( moviePicks.map { "\($0.day), \($0.id)" } )")
            return moviePicks
        } catch let error {
            Logger.appDataRepository.debug("getMoviePicksOfTheWeek - error decoding: \(error.localizedDescription)")
            return []
        }
    }
    
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay]) {
        do {
            let data = try JSONEncoder().encode(movieDays)
            LocalStorage.setData(data, forKey: .moviePicksOfTheWeek)
            moviePicksOfTheWeek = getMoviePicksOfTheWeek()
        } catch let error {
            Logger.appDataRepository.debug("setMoviePicksOfTheWeek - error encoding: \(error.localizedDescription)")
        }
    }
    
    /// - Preference
    func getPreference() -> Preference? {
        let dictionary: [String: Any]? = LocalStorage.getDictionary(forKey: .preference)
        guard let dictionary else {
            Logger.appDataRepository.debug("getPreference - nil")
            return nil
        }
        let preference: Preference? = DictionaryCoder.getType(of: dictionary)
        guard let preference else {
            Logger.appDataRepository.debug("getPreference - nil")
            return nil
        }
        Logger.appDataRepository.debug("getPreference - \(preference.debugDescription)")
        return preference
    }
    
    func setPreference(_ preference: Preference) {
        let dictionary = DictionaryCoder.getDictionary(of: preference)
        guard let dictionary else {
            Logger.appDataRepository.debug("setPreference - dictionary is nil")
            return
        }
        LocalStorage.setItem(dictionary, forKey: .preference)
        self.preference = getPreference()
    }
    
    /// - Week Tracker
    func getWeekEndDate() -> Date? {
        guard let endDate = LocalStorage.getItem(forKey: .weekEndDate) else {
            Logger.appDataRepository.debug("getWeekEndDate - nil")
            return nil
        }
        let weekEndDate = endDate as? Date
        Logger.appDataRepository.debug("getWeekEndDate - \(String(describing: weekEndDate))")
        return weekEndDate
    }
    
    func setWeekEndDate(to endDate: Date) {
        LocalStorage.setItem(endDate, forKey: .weekEndDate)
        self.weekEndDate = getWeekEndDate()
    }
    
    /// - Current Movies Preferred Page
    func getCurrentMoviesPreferredPage() -> Int {
        let page = LocalStorage.getInt(forKey: .currentMoviesPreferredPage)
        Logger.appDataRepository.debug("getCurrentMoviesPreferredPage - \(page)")
        return page
    }
    
    func setCurretMoviesPreferredPage(_ page: Int) {
        LocalStorage.setItem(page, forKey: .currentMoviesPreferredPage)
        self.currentMoviesPreferredPage = getCurrentMoviesPreferredPage()
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
    
    @Published var currentMoviesPreferredPage: Int = 0
    var currentMoviesPreferredPagePublisher: Published<Int>.Publisher { $currentMoviesPreferredPage }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksOfTheWeek() -> [MovieDay] {
        TestData.sampleMoviePicks
    }
    
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay]) {
        moviePicksOfTheWeek = movieDays
    }
    
    /// - Preference
    func getPreference() -> Preference? {
        TestData.samplePreference
    }
    
    func setPreference(_ preference: Preference) {
        self.preference = preference
    }
    
    /// - Week Tracker
    func getWeekEndDate() -> Date? {
        "2023-01-01".toDate()
    }
    
    func setWeekEndDate(to endDate: Date) {
        self.weekEndDate = endDate
    }
    
    /// - Current Movies Preferred Page
    func getCurrentMoviesPreferredPage() -> Int {
       0
    }
    
    func setCurretMoviesPreferredPage(_ page: Int) {
        self.currentMoviesPreferredPage = page
    }
}

