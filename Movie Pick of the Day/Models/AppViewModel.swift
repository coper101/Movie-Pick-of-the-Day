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
    @Published var currentMoviesPreferredPage: Int = 0
    
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
    @Published var pageNoOfSearchedMovies: Int = 1
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
    @Published var isAlertShown: Bool = false
    
    @Published var previousSearchQuery: String = ""
    
    var todaysMovieDay: MovieDay? {
        moviePicks.getTodaysMovieDay(todaysDate: .init())
    }

    var nextMovieDays: [MovieDay] {
        moviePicks.getNextMovieDays(todaysDate: .init())
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
                print("moviepicks republish: \($0)")
                guard let self else {
                    return
                }
                self.moviePicks = $0
                
                /**
                    Display Alert if:
                     - next movie pick days have at least of 1 non-available movie
                 */
                let todaysDate = Date()
                
                let todaysPick = self.moviePicks.getTodaysMovieDay(todaysDate: todaysDate)
                let nextPicks = self.moviePicks.getNextMovieDays(todaysDate: todaysDate, false)
                let numberOfPicksWithNoMovies = nextPicks.filter { $0.movie == nil }.count
                
                // Logger.appModel.debug("republish picks - numberOfPicksWithNoMovies: \(numberOfPicksWithNoMovies)")
                // Logger.appModel.debug("republish picks - todaysPick is nil? \(todaysPick == nil)")
                
                if
                    todaysPick != nil,
                    numberOfPicksWithNoMovies > 0
                {
                    self.showAlert()
                }
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
        
        appDataRepository.currentMoviesPreferredPagePublisher
            .sink { [weak self] in self?.currentMoviesPreferredPage = $0 }
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
            .sink { [weak self] in
                self?.genresError = $0
                self?.isLoadingGenres = false
            }
            .store(in: &subscriptions)
        
        movieRepository.languagesErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.languagesError = $0
                self?.isLoadingLanguages = false
            }
            .store(in: &subscriptions)
        
        movieRepository.similarMoviesErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.similarMoviesError = $0 }
            .store(in: &subscriptions)
            
        /// Data
        movieRepository.genresPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] genres in
                guard let self else {
                    return
                }
                // Loading
                self.isLoadingGenres = false
                // Loaded
                self.genres = genres.sorted()
                self.selectPreferences()
            }
            .store(in: &subscriptions)
        
        movieRepository.languagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] languages in
                guard let self else {
                    return
                }
                // Loading
                self.isLoadingLanguages = false
                // Loaded
                self.languages = languages.sorted()
                self.selectPreferences()
            }
            .store(in: &subscriptions)
        
        movieRepository.similarMoviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.similarMovies = $0 }
            .store(in: &subscriptions)
        
        movieRepository.preferredMoviesPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reSelectMoviePickIDsOfTheWeek($0) }
            .store(in: &subscriptions)
        
        movieRepository.preferredMoviesPagePublisher
            .drop(while: { $0 == 0 })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.appDataRepository.setCurretMoviesPreferredPage($0) }
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
        
        movieRepository.pageNoOfSearchMoviesPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.pageNoOfSearchedMovies = $0 }
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
    
    // MARK: Alert
    func closeAlert() {
        isAlertShown = false
    }
    
    func showAlert() {
        isAlertShown = true
    }
    
    // MARK: Pick of the Day
    // Picks
    func refreshMoviePicksOfTheWeek(
        _ preference: Preference?,
        _ weekEndDate: Date?,
        todaysDate: Date = Date()
    ) {
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
    
    // Preference
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
            with: preference.genres.compactMap(\.id).map { "\($0)" },
            currentPage: currentMoviesPreferredPage
        )
    }
    
    func reSelectMoviePickIDsOfTheWeek(_ prefferedMovies: [Movie], todaysDate: Date = .init()) {
        guard !prefferedMovies.isEmpty else {
            // remove all movies
            var moviePicks = [MovieDay]()
            moviePicks.append(contentsOf: self.moviePicks)
            
            for (index, _) in self.moviePicks.enumerated() {
                moviePicks[index].movie = nil
            }
            appDataRepository.setMoviePicksOfTheWeek(moviePicks)
            appDataRepository.setWeekEndDate(to: todaysDate.getEndOfWeekDate())
            
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
        
        // existing movie days in week
        var moviePicks = [MovieDay]()
        moviePicks.append(contentsOf: self.moviePicks)
        
        Logger.appModel.debug("existing movie picks: \(moviePicks.map(\.day.rawValue))")
        
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
                    // re-assign today's movie (option to skip re-assigning will be implemented in the future)
                    moviePicks[todaysPickIndex].movie = newMovie
                } else {
                    // add movie of today
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
            
            // re-assign movie day if set
            if let foundDayIndex = moviePicks.firstIndex(where: { $0.day == day }) {
                moviePicks[foundDayIndex].id = id
                moviePicks[foundDayIndex].movie = newMovie
                continue
            }
            
            // add movie day if not set
            moviePicks.append(
                .init(
                    day: day,
                    id: id,
                    movie: newMovie
                )
            )
        }
        
        Logger.appModel.debug("new movie pick ids: \(moviePicks.map { "\($0.day), \($0.id)" })")
        Logger.appModel.debug("new movie pick movie titles: \(moviePicks.compactMap { $0.movie?.title })")
        
        appDataRepository.setMoviePicksOfTheWeek(moviePicks)
        appDataRepository.setWeekEndDate(to: todaysDate.getEndOfWeekDate())
    }

    // MARK: Search
    func didTapSearchScreen() {
        screen = .search
    }
    
    func didTapSearchOnCommitMovie(_ query: String, onDone: (Bool) -> Void) {
        guard !query.isEmptyField() && hasInternetConnection else {
            onDone(true)
            return
        }
        isSearching = true
        movieRepository.searchMovie(with: query, page: 1)
        onDone(false)
        previousSearchQuery = query
    }
    
    func loadMoreMovies() {
        guard !previousSearchQuery.isEmpty else {
            return
        }
        movieRepository.searchMovie(with: previousSearchQuery, page: pageNoOfSearchedMovies + 1)
    }
    
    // MARK: Pick of the Day Detail
    func didTapPickOfTheDayDetailScreen(todaysDate: Date = .init()) {
        screen = .pickOfTheDayDetail
        
        let todaysWeekday = todaysDate.toDateComp().weekday!
        guard let day = Day(rawValue: todaysWeekday) else {
            return
        }
                
        guard
            let todaysMoviePick = moviePicks.first(where: { $0.day == day })
        else {
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
