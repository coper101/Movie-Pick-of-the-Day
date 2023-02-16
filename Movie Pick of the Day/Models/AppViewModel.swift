//
//  AppViewModel.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Combine
import Foundation
import OSLog

final class AppViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    let appDataRepository: AppDataRepositoryType
    let movieRepository: MovieRepositoryType
    
    // MARK: Data
    /// [A] App Data
    @Published var preference: Preference?
    
    /// [B] Movie Data
    @Published var genres: [Genre] = []
    @Published var languages: [Language] = []
    @Published var preferredMovies: [Movie] = []
    @Published var similarMovies: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    
    // MARK: UI
    @Published var screen: Screen = .pickOfTheDay
    @Published var isPreferencesSheetShown: Bool = false
    
    @Published var genresSelection: [String] = []
    @Published var languageSelected: String = ""
    @Published var isAdultSelected: Bool = false
    
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
        
        guard republishData else {
            return
        }
        republishAppData()
        republishMovieData()
    }
        
}

// MARK: Republication
extension AppViewModel {
    
    /// [A]
    func republishAppData() {
        
        appDataRepository.moviePicksOfTheWeekPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.moviePicks = $0
                print("new movie pick ids: ", self.moviePicks.map { "\($0.day), \($0.id)" })
            }
            .store(in: &subscriptions)
        
        appDataRepository.preferencePublisher
            .dropFirst()
            .sink { [weak self] in self?.selectMoviePickIDsOfTheWeek($0) }
            .store(in: &subscriptions)
        
        appDataRepository.preferencePublisher
            .sink { [weak self] in self?.preference = $0 }
            .store(in: &subscriptions)
        
    }
    
    /// [B]
    func republishMovieData() {
        
        movieRepository.genresPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.genres = $0.sorted() }
            .store(in: &subscriptions)
        
        movieRepository.languagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.languages = $0.sorted() }
            .store(in: &subscriptions)
        
        movieRepository.similarMoviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.similarMovies = $0 }
            .store(in: &subscriptions)
        
        movieRepository.preferredMoviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.reSelectMoviePickIDsOfTheWeek($0)
            }
            .store(in: &subscriptions)
        
        movieRepository.searchedMoviesPublisher
            .receive(on: DispatchQueue.main)
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
    
    // func loadMoviePicks(_ movieDays: [MovieDay]) {
    //     print(#function)
    //
    //     /// for displaying movie picks
    //     self.moviePicks = movieDays
    //
    //     guard !self.preferredMovies.isEmpty else {
    //         return
    //     }
    //
    //     /// get movie from the discovered movies as get movie description
    //     /// doesn't return a movie as movies are mostly deleted
    //     for (index, movieDay) in movieDays.enumerated() {
    //         guard
    //             let movie = self.preferredMovies.first(where: { $0.id == movieDay.id })
    //         else {
    //             continue
    //         }
    //         self.moviePicks[index].movie = movie
    //     }
    //
    //     print("moviePicks: ", moviePicks.compactMap(\.movie?.title))
    //
    //     /// get the movie description for each pick - async
    //     // for (index, movieDay) in movieDays.enumerated() {
    //     //     movieRepository.getMovie(with: movieDay.id)
    //     //         .receive(on: DispatchQueue.main)
    //     //         .sink { [weak self] movie in
    //     //             /// optional if movie can't be found using id - invalid id -1
    //     //             /// display error image on ui
    //     //             self?.moviePicks[index].movie = movie
    //     //             Logger.appModel.debug("getMovie - success: \(movie?.title ?? "nil")")
    //     //         }
    //     //         .store(in: &subscriptions)
    //     // }
    // }

    /// Preferences
    func didTapPreferences() {
        isPreferencesSheetShown = true

        if genres.isEmpty || languages.isEmpty {
            DispatchQueue.global().async {
                self.movieRepository.getGenres()
                self.movieRepository.getLanguages()
            }
        }
        
        preferenceInput = .init(
            language: "en",
            originalLanguage: "en",
            includeAdult: false,
            genres: []
        )
    }
    
    func didTapSavePreferences() {
        isPreferencesSheetShown = false
        
        let selectedGenres: [Genre] = genres
            .filter { genre in
                genresSelection.reduce(false) { isSelected, genreName in
                    isSelected || genreName == genre.name
                }
            }
            
        var selectedISOLanguage = "en"
        
        if
            let selectedLanguage = languages.first(where: { $0.englishName == languageSelected }),
            let isoLanguage = selectedLanguage.iso6391
        {
            selectedISOLanguage = isoLanguage
        }
                    
        self.preferenceInput?.language = "en"
        self.preferenceInput?.originalLanguage = selectedISOLanguage
        self.preferenceInput?.includeAdult = isAdultSelected
        self.preferenceInput?.genres = selectedGenres
        
        guard let preferenceInput else {
            return
        }
                
        appDataRepository.setPreference(preferenceInput)
        
        self.preferenceInput = nil
    }
    
    func didTapClosePreferences() {
        isPreferencesSheetShown = false
        
        // movieRepository.clearGenres()
        // movieRepository.clearLanguages()
        
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
            originalLanguage: preference.originalLanguage,
            with: preference.genres.compactMap(\.id).map { "\($0)" }
        )
    }
    
    func reSelectMoviePickIDsOfTheWeek(_ prefferedMovies: [Movie], todaysDate: Date = .init()) {
        guard !prefferedMovies.isEmpty else {
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
            prefferedMovies.count >= remainingWeekdaysCount
        else {
            return
        }
                
        guard
            let shufflePreferredMovies = prefferedMovies.shuffle(keep: remainingWeekdaysCount)
        else {
            return
        }
        
        /// existing movie days in week
        var moviePicks = [MovieDay]()
        moviePicks.append(contentsOf: self.moviePicks)
        
        print("existing movie picks: ", moviePicks.map(\.day.rawValue))
                    
        // rest of the week
        for (index, weekday) in remainingWeekdaysRange.enumerated() {
            
            let movieIndex = index
            let newMovie = shufflePreferredMovies[safe: movieIndex]
            let id = newMovie?.id ?? -1
            let day = Day(rawValue: weekday) ?? .sunday

            if
                let todayWeekday = remainingWeekdaysRange.first,
                weekday == todayWeekday
            {
                /// add movie of today
                if moviePicks.first(where: { $0.day.rawValue == todayWeekday }) == nil {
                    moviePicks.append(
                        .init(
                            day: day,
                            id: id,
                            movie: newMovie
                        )
                    )
                }
                /// skip today's movie day if set
                continue
            }
            
            /// re-assign movie day if set
            if let foundDayIndex = moviePicks.firstIndex(where: { $0.day == day }) {
                moviePicks[foundDayIndex].id = id
                moviePicks[foundDayIndex].movie = newMovie
                continue
            }
            
            /// add movie day if not set
            moviePicks.append(
                .init(
                    day: day,
                    id: id,
                    movie: newMovie
                )
            )
        }
        
        print("new movie pick ids: ", moviePicks.map { "\($0.day), \($0.id)" })
        print("new movie pick movie title: ", moviePicks.compactMap { $0.movie?.title })
        
        appDataRepository.setMoviePicksOfTheWeek(moviePicks)
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
