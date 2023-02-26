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
    let networkConnectionRepository: NetworkConnectivity
    
    // MARK: Data
    /// [A] App Data
    @Published var preference: Preference?
    @Published var weekEndDate: Date?
    
    /// [B] Movie Data
    @Published var genres: [Genre] = []
    @Published var isLoadingGenres: Bool = false
    @Published var genresError: MovieRepositoryError?
    
    @Published var languages: [Language] = []
    @Published var isLoadingLanguages: Bool = false
    @Published var languagesError: MovieRepositoryError?
    
    @Published var preferredMovies: [Movie] = []
    @Published var similarMovies: [Movie] = []
    @Published var similarMoviesError: MovieRepositoryError?
    
    @Published var searchedMovies: [Movie] = []
    @Published var isSearching: Bool = false
    @Published var hasSearched: Bool = false
    @Published var searchError: MovieRepositoryError?
    
    /// [C] Network Connection
    @Published var hasInternetConnection: Bool = false
    
    // MARK: UI
    @Published var screen: Screen = .pickOfTheDay
    @Published var isPreferencesSheetShown: Bool = false
    
    @Published var genresSelection: [String] = []
    @Published var languageSelected: String = ""
    @Published var isAdultSelected: Bool = false
    
    @Published var moviePicks: [MovieDay] = []
    @Published var preferenceInput: Preference?
    @Published var todaysMoviePick: MovieDay?
    
    var todaysMovieDay: MovieDay? {
        guard
            let todaysWeekDay = Date().toDateComp().weekday,
            let movieDay = moviePicks.first(where: { $0.day.rawValue == todaysWeekDay })
        else {
            return nil
        }
        return movieDay
    }

    var nextMovieDays: [MovieDay] {
        guard
            let todaysWeekDay = Date().toDateComp().weekday,
            let todaysMovieDay = moviePicks.first(where: { $0.day.rawValue == todaysWeekDay })
        else {
            return []
        }
        let nextMovies = moviePicks
            .filter { $0.day.rawValue > todaysMovieDay.day.rawValue }
        
        return nextMovies
    }
    
    init(
        _ appDataRepository: AppDataRepositoryType = AppDataRepository(),
        _ movieRepository: MovieRepositoryType = MovieRepository(),
        _ networkConnectionRepository: NetworkConnectivity = NetworkConnectionRepository(),
        republishData: Bool = true
    ) {
        self.appDataRepository = appDataRepository
        self.movieRepository = movieRepository
        self.networkConnectionRepository = networkConnectionRepository
        
        guard republishData else {
            return
        }
        republishAppData()
        republishMovieData()
        republishNetworkData()
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
                Logger.appModel.debug("Movie Pick IDs: \(self.moviePicks.map { "\($0.day), \($0.id)" } )")
            }
            .store(in: &subscriptions)
        
        appDataRepository.preferencePublisher
            .dropFirst()
            .sink { [weak self] in self?.selectMoviePickIDsOfTheWeek($0) }
            .store(in: &subscriptions)

        appDataRepository.preferencePublisher
            .sink { [weak self] in self?.preference = $0 }
            .store(in: &subscriptions)
        
        appDataRepository.preferencePublisher
            .zip(appDataRepository.weekEndDatePublisher)
            .sink { [weak self] preference, weekEndDate in
                self?.refreshMoviePicksOfTheWeek(preference, weekEndDate)
            }
            .store(in: &subscriptions)
    }
    
    /// [B]
    func republishMovieData() {
        
        /// Errors
        movieRepository.searchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.searchError = $0 }
            .store(in: &subscriptions)
        
        movieRepository.genresErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.genresError = $0 }
            .store(in: &subscriptions)
        
        movieRepository.languagesErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.languagesError = $0 }
            .store(in: &subscriptions)
        
        movieRepository.similarMoviesErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.similarMoviesError = $0 }
            .store(in: &subscriptions)
            
        /// Data
        movieRepository.genresPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.genres = $0.sorted()
                if self.isLoadingGenres {
                    self.isLoadingGenres = false
                }
                self.selectPreferences()
            }
            .store(in: &subscriptions)
        
        movieRepository.languagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.languages = $0.sorted()
                if self.isLoadingLanguages {
                    self.isLoadingLanguages = false
                }
                self.selectPreferences()
            }
            .store(in: &subscriptions)
        
        movieRepository.similarMoviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.similarMovies = $0 }
            .store(in: &subscriptions)
        
        movieRepository.preferredMoviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reSelectMoviePickIDsOfTheWeek($0) }
            .store(in: &subscriptions)
        
        movieRepository.searchedMoviesPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.searchedMovies = $0
                if self.isSearching {
                    self.isSearching = false
                }
                if !self.hasSearched {
                    self.hasSearched = true
                }
            }
            .store(in: &subscriptions)
        
    }
    
    /// [C] Network Data
    func republishNetworkData() {
        
        networkConnectionRepository
            .hasInternetConnectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.hasInternetConnection = $0 }
            .store(in: &subscriptions)
    }
    
}

// MARK: Events
extension AppViewModel {
    
    // MARK: Pick of the Day
    /// Picks
    func refreshMoviePicksOfTheWeek(_ preference: Preference?, _ weekEndDate: Date?) {
        let todaysDate = Date()
        
        guard
            let preference,
            let weekEndDate,
            weekEndDate < todaysDate
        else {
            return
        }
        
        selectMoviePickIDsOfTheWeek(preference)
    }
    
    func didTapPickOfTheDayMovieScreen() {
        screen = .pickOfTheDay
    }
    
    /// Preferences
    func selectPreferences() {
        guard let preference else {
            return
        }
        
        if preference.includeAdult != isAdultSelected {
            isAdultSelected = preference.includeAdult
        }
        
        if genresSelection.isEmpty && !genres.isEmpty {
            genresSelection = preference.genres.compactMap(\.name)
        }
        
        if languageSelected.isEmpty && !languages.isEmpty {
            let foundLanguage = languages.first(where: { ($0.iso6391 ?? "") == preference.language })
            languageSelected = foundLanguage?.englishName ?? ""
        }
    }
    
    func didTapPreferences() {
        isPreferencesSheetShown = true

        if genres.isEmpty {
            isLoadingGenres = true
            self.movieRepository.getGenres()
        }
        
        if languages.isEmpty {
            isLoadingLanguages = true
            self.movieRepository.getLanguages()
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
        preferenceInput = nil
    }
    
    func selectMoviePickIDsOfTheWeek(_ preference: Preference?) {
        guard let preference else {
            return
        }
        
        let daysInWeekLeft = Date().getRemainingWeekDaysCount()
        guard daysInWeekLeft >= 0 else {
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
            No. Change in Movie Pick
            (1) today is last day of week
            (2) insufficient movies to assign all to remaining days in week
         */
        
        guard
            remainingWeekdaysCount >= 0,
            prefferedMovies.count >= remainingWeekdaysCount
        else {
            return
        }
                
        guard
            let shufflePreferredMovies = prefferedMovies.shuffle(keep: remainingWeekdaysCount + 1)
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
                if let todaysPickIndex = moviePicks.firstIndex(where: { $0.day.rawValue == todayWeekday }) {
                    /// set today's movie if not set
                    if moviePicks[todaysPickIndex].movie == nil {
                        moviePicks[todaysPickIndex].movie = newMovie
                    }
                } else {
                    /// add movie of today
                    moviePicks.append(
                        .init(
                            day: day,
                            id: id,
                            movie: newMovie
                        )
                    )
                }
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
        appDataRepository.setWeekEndDate(to: todaysDate.getEndOfWeekDate())
    }


    // MARK: Search
    func didTapSearchScreen() {
        screen = .search
    }
    
    func didTapSearchOnCommitMovie(_ query: String, onDone: (Bool) -> Void) {
        guard !query.isEmptyField() else {
            onDone(true)
            return
        }
        isSearching = true
        movieRepository.searchMovie(with: query)
        onDone(false)
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
