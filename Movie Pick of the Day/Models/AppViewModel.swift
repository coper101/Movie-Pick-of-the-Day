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
    let movieRepository: MovieRepositoryType
    
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
        _ movieRepository: MovieRepositoryType = MovieRepository(),
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
        
        movieRepository.getPreferredMovies(
            includeAdult: preference.includeAdult,
            language: preference.language,
            with: preference.genres
        )
    }
    
    func reSelectMoviePickIDsOfTheWeek(_ movies: [Movie], todaysDate: Date = .init()) {
        guard !movies.isEmpty else {
            return
        }
        
        let remainingWeekdaysRange = todaysDate.getRemainingWeekDaysRange()
        let remainingWeekdaysCount = todaysDate.getRemainingWeekDaysCount()
        
        /**
            No Change in Movie Pick
            (1) today is last day of week
            (2) insufficient movies to assign all to remaining days in week
         */
        
        guard
            remainingWeekdaysCount > 0,
            movies.count >= remainingWeekdaysCount
        else {
            return
        }
                
        guard
            let moviePicksOfTheWeek = movies.shuffle(keep: remainingWeekdaysCount)
        else {
            return
        }
        
        /// existing movie days in week
        var moviePicks = [MovieDay]()
        moviePicks.append(contentsOf: self.moviePicks)
                
        for (index, weekday) in remainingWeekdaysRange.enumerated() {
            
            /// skip today's movie day
            if
                let todayWeekday = remainingWeekdaysRange.first,
                weekday == todayWeekday
            {
                continue
            }
            
            let movieIndex = index - 1
            let day = Day(rawValue: weekday) ?? .sunday
            let newMovie = moviePicksOfTheWeek[movieIndex]
            let id = newMovie.id ?? -1
            
            print(
                """
                    --------------
                    movieIndex: \(movieIndex)
                    day: \(day)
                    new movie id: \(id)
                    
                    """
            )
            
            /// re-assign movie day if set
            if
                let foundDayIndex = moviePicks.firstIndex(
                    where: { $0.day == day }
                )
            {
                moviePicks[foundDayIndex].id = id
                moviePicks[foundDayIndex].movie = nil
                continue
            }
            /// add movie day if not set
            moviePicks.append(
                .init(day: day, id: id, movie: nil)
            )
        }
        
        print("New Movie Picks")
        moviePicks.forEach {
            print("--------------")
            print($0)
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
    func didTapPickOfTheDayDetailScreen(todaysDate: Date = .init()) {
        screen = .pickOfTheDayDetail
        
        let todaysWeekday = todaysDate.toDateComp().weekday!
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
    
    func didTapClosePickOfTheDayDetailScreen() {
        screen = .pickOfTheDay
        todaysMoviePick = nil
        movieRepository.clearSimilarMovies()
    }
    
}
