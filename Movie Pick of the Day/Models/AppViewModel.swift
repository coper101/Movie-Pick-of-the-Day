//
//  AppViewModel.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Combine
import Foundation

final class AppViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    let appDataRepository: AppDataRepositoryType
    let movieRepository: MovieRepositoryType & TMDBService
    
    // MARK: Data
    /// [A] App Data
    
    /// [B] Movie Data
    @Published var genres: [Genre] = []
    @Published var languages: [Language] = []
    @Published var similarMovies: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    
    // MARK: UI
    @Published var screen: Screen = .pickOfTheDay
    
    @Published var moviePicks: [MovieDay] = []
    @Published var preferenceInput: Preference?
    @Published var todaysMoviePick: MovieDay?

    init(
        _ appDataRepository: AppDataRepositoryType = AppDataRepository(),
        _ movieRepository: MovieRepositoryType & TMDBService = MovieRepository(),
        republishData: Bool = true
    ) {
        self.appDataRepository = appDataRepository
        self.movieRepository = movieRepository
        
        republishAppData()
        republishMovieData()
    }
        
}

// MARK: Republication
extension AppViewModel {
    
    /// [A]
    func republishAppData() {
        
        appDataRepository.moviePickIDsOfTheWeekPublisher
            .sink { [weak self] in self?.loadMoviePicks($0) }
            .store(in: &subscriptions)
        
        appDataRepository.preferencePublisher
            .dropFirst()
            .sink { [weak self] in self?.selectMoviePickIDsOfTheWeek($0) }
            .store(in: &subscriptions)
        
    }
    
    /// [B]
    func republishMovieData() {
        
        movieRepository.genresPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.genres = $0 }
            .store(in: &subscriptions)
        
        movieRepository.languagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.languages = $0 }
            .store(in: &subscriptions)
        
        movieRepository.similarMoviesPublisher
            .sink { [weak self] in self?.similarMovies = $0 }
            .store(in: &subscriptions)
        
        movieRepository.preferredMoviesPublisher
            .sink { [weak self] in
                self?.reSelectMoviePickIDsOfTheWeek($0)
            }
            .store(in: &subscriptions)
        
        movieRepository.searchedMoviesPublisher
            .sink { [weak self] in self?.searchedMovies = $0 }
            .store(in: &subscriptions)
        
    }
    
}

// MARK: Events
extension AppViewModel {
    
    // MARK: Pick of the Day
    /// Picks
    func didTapPickOfTheDayMovieScreen() {
        screen = .pickOfTheDay
    }
    
    func loadMoviePicks(_ movieDays: [MovieDay]) {
        /// for displaying movie picks
        moviePicks = movieDays
        
        /// get the movie description for each pick - async
        for (index, movieDay) in movieDays.enumerated() {
            movieRepository.getMovie(with: movieDay.id)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    /// optional if movie can't be found using id - invalid id -1
                    /// display error image on ui
                    self?.moviePicks[index].movie = $0
                }
                .store(in: &subscriptions)
        }
    }

    /// Preferences
    func didTapPreferences() {
        movieRepository.getGenres()
        movieRepository.getLanguages()
        
        preferenceInput = .init(
            language: "EN",
            includeAdult: false,
            genres: []
        )
    }
    
    func didTapSavePreferences() {
        guard let preferenceInput else {
            return
        }
        
        appDataRepository.setPreference(preferenceInput)
        self.preferenceInput = nil
    }
    
    func didTapClosePreferences() {
        movieRepository.clearGenres()
        movieRepository.clearLanguages()
        
        preferenceInput = nil
    }
    
    func selectMoviePickIDsOfTheWeek(_ preference: Preference?) {
        guard let preference else {
            return
        }
        
        let daysInWeekLeft = Date().getRemainingWeekDaysCount()
        guard daysInWeekLeft > 0 else {
            return
        }
        
        movieRepository.discoverMovies(
            includeAdult: preference.includeAdult,
            language: preference.language,
            with: preference.genres
        )
    }
    
    func reSelectMoviePickIDsOfTheWeek(_ movies: [Movie]) {
        guard !movies.isEmpty else {
            return
        }
        
        let remainingWeekdaysRange = Date().getRemainingWeekDaysRange()
        let remainingWeekdaysCount = Date().getRemainingWeekDaysCount()
        guard remainingWeekdaysCount > 0 else {
            return
        }
                
        guard
            let moviePicksOfTheWeek = movies.shuffle(keep: remainingWeekdaysCount)
        else {
            return
        }
        
        var moviePicks = [MovieDay]()
        for (index, weekday) in remainingWeekdaysRange.enumerated() {
            let day = Day(rawValue: weekday) ?? .sunday
            let movie = moviePicksOfTheWeek[index]
            moviePicks.append(.init(day: day, id: movie.id ?? -1)) /// id: -1 invalid
        }
        
        appDataRepository.setMoviePicksIDsOfTheWeek(moviePicks)
    }

    // MARK: Search
    func didTapSearchScreen() {
        screen = .search
    }
    
    func didTapSearchOnCommitMovie(_ query: String) {
        guard !query.isEmptyField() else {
            return
        }
        movieRepository.searchMovie(with: query)
    }
    
    // MARK: Pick of the Day Detail
    func didPickOfTheDayDetailScreen() {
        screen = .pickOfTheDayDetail
        
        let todaysWeekday = Date().toDateComp().weekday!
        guard let day = Day(rawValue: todaysWeekday) else {
            /// can't load todays movie pick error
            return
        }
                
        guard
            let todaysMoviePick = moviePicks.first(where: { $0.day == day })
        else {
            /// can't load todays movie pick error
            return
        }
        
        self.todaysMoviePick = todaysMoviePick
        movieRepository.getSimilarMovies(of: todaysMoviePick.id)
    }
    
    func didTapClosePickOfTheDayDetail() {
        screen = .pickOfTheDay
        todaysMoviePick = nil
        movieRepository.clearSimilarMovies()
    }
    
}
