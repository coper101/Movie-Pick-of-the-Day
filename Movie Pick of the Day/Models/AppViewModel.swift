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
    @Published var moviePickIDsOfTheWeek: [MovieDay] = []
    
    /// [B] Movie Data
    @Published var genres: [Genre] = []
    @Published var languages: [Language] = []
    @Published var similarMovies: [Movie] = []
    @Published var preferredMovies: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    
    // MARK: UI
    @Published var screen: Screen = .pickOfTheDay
        
    init(
        appDataRepository: AppDataRepositoryType = AppDataRepository(),
        movieRepository: MovieRepositoryType & TMDBService = MovieRepository()
    ) {
        self.appDataRepository = appDataRepository
        self.movieRepository = movieRepository
        
        appDataRepository.setMoviePicksIDsOfTheWeek(
            [
                .init(day: Day.saturday.rawValue, id: 76600)
            ]
        )
        
        republishAppData()
        republishMovieData()
        
    }
    
    func republishAppData() {
        
        appDataRepository.moviePickIDsOfTheWeekPublisher
            .sink { [weak self] in
                self?.moviePickIDsOfTheWeek = $0
                self?.loadMoviePicks()
            }
            .store(in: &subscriptions)
        
    }
    
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
            .sink { [weak self] in self?.preferredMovies = $0 }
            .store(in: &subscriptions)
        
        movieRepository.searchedMoviesPublisher
            .sink { [weak self] in self?.searchedMovies = $0 }
            .store(in: &subscriptions)
        
    }
    
    func loadMoviePicks() {
        let movieDays = moviePickIDsOfTheWeek
        for (index, movieDay) in movieDays.enumerated() {
            movieRepository.getMovie(with: movieDay.id)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.moviePickIDsOfTheWeek[index].movie = $0
                }
                .store(in: &subscriptions)
        }
    }
    
//    func setMoviePickOfTheDay() {
//        let today = Date()
//        let weekday = today.toDateComp().weekday!
//        let day = weekday.toDay()
//        moviePickOfTheDay = moviePickIDsOfTheWeek.first(where: { $0.theDay == day })
//    }

    func didTapPreferences() {
        movieRepository.getGenres()
        movieRepository.getLanguages()
    }
    
    func didTapPickOfTheDayMovie() {
        
    }
    
}

extension Date {
    
    func toDateComp() -> DateComponents {
        Calendar.current.dateComponents(
            [.day, .month, .year, .weekday],
            from: self
        )
    }
    
}
