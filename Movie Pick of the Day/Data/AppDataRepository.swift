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
    var moviePickIDsOfTheWeek: [MovieDay] { get set }
    var moviePickIDsOfTheWeekPublisher: Published<[MovieDay]>.Publisher { get }
    
    var preference: Preference? { get set }
    var preferencePublisher: Published<Preference?>.Publisher { get }
    
    /// Setters and Getters
    func getMoviePicksIDsOfTheWeek() -> [MovieDay]
    func setMoviePicksIDsOfTheWeek(_ movieDays: [MovieDay])
    
    func getPreference() -> Preference?
    func setPreference(_ preference: Preference) -> Void
}

enum Keys: String {
    case moviePickIDsOfTheWeek = "Movie_Pick_IDs_Of_The_Week"
    case preference = "Preference"
}


// MARK: App Implementation
final class AppDataRepository: ObservableObject, AppDataRepositoryType {
    
    /// Data
    @Published var moviePickIDsOfTheWeek: [MovieDay] = []
    var moviePickIDsOfTheWeekPublisher: Published<[MovieDay]>.Publisher { $moviePickIDsOfTheWeek }
    
    @Published var preference: Preference?
    var preferencePublisher: Published<Preference?>.Publisher { $preference }
    
    init() {
        moviePickIDsOfTheWeek = getMoviePicksIDsOfTheWeek()
        preference = getPreference()
    }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksIDsOfTheWeek() -> [MovieDay] {
        let dictionary: [Int: Int]? = LocalStorage.getDictionary(forKey: .moviePickIDsOfTheWeek)
        guard let dictionary else {
            print("getMoviePicksIDsOfTheWeek error: movie picks dictionary nil")
            return []
        }
        let movieDays: [MovieDay] = dictionary
            .map { .init(day: .init(rawValue: $0) ?? .sunday, id: $1) }
        return movieDays
    }
    
    func setMoviePicksIDsOfTheWeek(_ movieDays: [MovieDay]) {
        LocalStorage.setItem(
            movieDays.toDictionary(),
            forKey: .moviePickIDsOfTheWeek
        )
        moviePickIDsOfTheWeek = getMoviePicksIDsOfTheWeek()
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
}


// MARK: Test Implementation
class MockAppDataRepository: AppDataRepositoryType {
    
    /// Data
    @Published var moviePickIDsOfTheWeek: [MovieDay] = []
    var moviePickIDsOfTheWeekPublisher: Published<[MovieDay]>.Publisher { $moviePickIDsOfTheWeek }
    
    @Published var preference: Preference?
    var preferencePublisher: Published<Preference?>.Publisher { $preference }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksIDsOfTheWeek() -> [MovieDay] {
        [
            TestData.createMovieDay(movieID: 104, day: .wednesday),
            TestData.createMovieDay(movieID: 105, day: .thursday),
            TestData.createMovieDay(movieID: 106, day: .friday),
            TestData.createMovieDay(movieID: 107, day: .saturday),
        ]
    }
    
    func setMoviePicksIDsOfTheWeek(_ movieDays: [MovieDay]) {
        moviePickIDsOfTheWeek = movieDays
    }
    
    /// - Preference
    func getPreference() -> Preference? {
        .init(
            language: "EN",
            includeAdult: false,
            genres: ["Action", "Adventure"]
        )
    }
    
    func setPreference(_ preference: Preference) {
        self.preference = preference
    }
    
}

