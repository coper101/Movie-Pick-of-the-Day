//
//  MovieRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Foundation
import Combine
import UIKit
import OSLog

// MARK: Protocol
protocol MovieRepositoryType {
    
    /// Genres
    var genres: [Genre] { get set }
    var genresPublisher: Published<[Genre]>.Publisher { get }
    func getGenres() -> Void
    func clearGenres() -> Void
    
    /// Languages
    var languages: [Language] { get set }
    var languagesPublisher: Published<[Language]>.Publisher { get }
    func getLanguages() -> Void
    func clearLanguages() -> Void
    
    /// Movie Description
    func getMovie(with id: Int) -> AnyPublisher<Movie?, Never>
    
    /// Similar Movies
    var similarMovies: [Movie] { get set }
    var similarMoviesPublisher: Published<[Movie]>.Publisher { get }
    func getSimilarMovies(of id: Int) -> Void
    func clearSimilarMovies() -> Void
    
    /// Preferred Movies
    var preferredMovies: [Movie] { get set }
    var preferredMoviesPublisher: Published<[Movie]>.Publisher { get }
    func getPreferredMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String]
    ) -> Void
    
    /// Searched Movies
    var searchedMovies: [Movie] { get set }
    var searchedMoviesPublisher: Published<[Movie]>.Publisher { get }
    func searchMovie(with query: String) -> Void
    
}


// MARK: App Implementation
class MovieRepository: MovieRepositoryType, ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()

    /// Data
    @Published var genres: [Genre] = []
    var genresPublisher: Published<[Genre]>.Publisher { $genres }
    
    @Published var languages: [Language] = []
    var languagesPublisher: Published<[Language]>.Publisher { $languages }
    
    @Published var similarMovies: [Movie] = []
    var similarMoviesPublisher: Published<[Movie]>.Publisher { $similarMovies }
    
    @Published var preferredMovies: [Movie] = []
    var preferredMoviesPublisher: Published<[Movie]>.Publisher { $preferredMovies }
    
    @Published var searchedMovies: [Movie] = []
    var searchedMoviesPublisher: Published<[Movie]>.Publisher { $searchedMovies }
    
    /// Services
    func getGenres() {
        TMDBService.getGenres()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("getGenres - server error: \(message)")
                            break
                        default:
                            break
                        }
                    }
                case .finished:
                    Logger.movieRepository.debug("getGenres - finished")
                }
            } receiveValue: { [weak self] response in
                guard let self, let genres = response.genres else {
                    return
                }
                self.genres = genres
                Logger.movieRepository.debug("getGenres - success: \(genres.map(\.name))")
            }
            .store(in: &subscriptions)
    }
    
    func getLanguages() {
        TMDBService.getLanguages()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("getLanguages - server error: \(message)")
                            break
                        default:
                            break
                        }
                    }
                case .finished:
                    Logger.movieRepository.debug("getLanguages - finished")
                }
            } receiveValue: { [weak self] languages in
                guard let self else {
                    return
                }
                self.languages = languages
                Logger.movieRepository.debug("getLanguages - success: \(languages.map(\.name))")
            }
            .store(in: &subscriptions)
    }
    
    func getMovie(with id: Int) -> AnyPublisher<Movie?, Never> {
        TMDBService.getMovie(with: id)
    }
    
    func getSimilarMovies(of id: Int) {
        TMDBService.getSimilarMovies(of: id)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("getSimilarMovies - server error: \(message)")
                        case .request(let message):
                            Logger.movieRepository.debug("getSimilarMovies - error: \(message)")
                        default:
                            break
                        }
                    }
                case .finished:
                    Logger.movieRepository.debug("getSimilarMovies - finished")
                }
            } receiveValue: { [weak self] response in
                guard let self, let results = response.results else {
                    return
                }
                self.similarMovies = results
                Logger.movieRepository.debug("getSimilarMovies - success: \(results.map(\.title))")
            }
            .store(in: &subscriptions)
    }
    
    func getPreferredMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String]
    ) {
        TMDBService.discoverMovies(
            includeAdult: includeAdult,
            language: language,
            originalLanguage: originalLanguage,
            with: genres
        )
        .sink { completion in
            switch completion {
            case .failure(let error):
                if error is NetworkError {
                    let networkError = error as! NetworkError
                    switch networkError {
                    case .server(let message):
                        Logger.movieRepository.debug("getPreferredMovies - server error: \(message)")
                    case .request(let message):
                        Logger.movieRepository.debug("getPreferredMovies - request error: \(message)")
                    default:
                        break
                    }
                }
            case .finished:
                Logger.movieRepository.debug("getPreferredMovies - finished")
            }
        } receiveValue: { [weak self] response in
            guard let self, let results = response.results else {
                return
            }
            self.preferredMovies = results
            Logger.movieRepository.debug("getPreferredMovies - success: \(results.map(\.title))")
        }
        .store(in: &subscriptions)
    }
    
    func searchMovie(with query: String) {
        TMDBService.searchMovie(with: query)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("searchMovie - server error: \(message)")
                        case .request(let message):
                            Logger.movieRepository.debug("searchMovie - request error: \(message)")
                        default:
                            break
                        }
                    }
                case .finished:
                    Logger.movieRepository.debug("searchMovie - finished")
                }
            } receiveValue: { [weak self] response in
                guard let self, let results = response.results else {
                    return
                }
                self.searchedMovies = results
                Logger.movieRepository.debug("searchMovie - success: \(results.map(\.title))")
            }
            .store(in: &subscriptions)
    }
    
    func getUIImage(of path: String, with resolution: ImageResolution) -> AnyPublisher<UIImage, Error> {
        Networking.requestImage(
            request: GetImage(
                imageResolution: resolution,
                posterPath: path
            )
        )
    }
    
}

extension MovieRepository {
    
    func clearGenres() {
        genres.removeAll()
    }
    
    func clearLanguages() {
        languages.removeAll()
    }
    
    func clearSimilarMovies() {
        similarMovies.removeAll()
    }
}


// MARK: Test Implementation
class MockMovieRepository: TMDBService, MovieRepositoryType, ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()

    /// Data
    @Published var genres: [Genre] = []
    var genresPublisher: Published<[Genre]>.Publisher { $genres }
    
    @Published var languages: [Language] = []
    var languagesPublisher: Published<[Language]>.Publisher { $languages }
    
    @Published var similarMovies: [Movie] = []
    var similarMoviesPublisher: Published<[Movie]>.Publisher { $similarMovies }
    
    @Published var preferredMovies: [Movie] = []
    var preferredMoviesPublisher: Published<[Movie]>.Publisher { $preferredMovies }
    
    @Published var searchedMovies: [Movie] = []
    var searchedMoviesPublisher: Published<[Movie]>.Publisher { $searchedMovies }
    
    func getGenres() {
        genres = [
            .init(id: 1, name: "Action"),
            .init(id: 2, name: "Adventure")
        ]
    }
    
    func getLanguages() {
        languages = [
            .init(
                iso6391: "en",
                englishName: "English",
                name: ""
            ),
            .init(
                iso6391: "de",
                englishName: "German",
                name: "Deutsch"
            )
        ]
    }
    
    func getMovie(with id: Int) -> AnyPublisher<Movie?, Never> {
        Just(TestData.createMovie(id: id))
            .eraseToAnyPublisher()
    }
    
    func getSimilarMovies(of id: Int) {
        similarMovies = [
            TestData.createMovie(id: 101, title: "Toy Story 1"),
            TestData.createMovie(id: 102, title: "Toy Story 2")
        ]
    }
    
    func getPreferredMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String]
    ) {
        preferredMovies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
    }
    
    func searchMovie(with query: String) {
        searchedMovies = [
            TestData.createMovie(id: 101, title: "Toy Story 1"),
            TestData.createMovie(id: 102, title: "Toy Story 2")
        ]
    }
    
    func getUIImage(
        of path: String,
        with resolution: ImageResolution
    ) -> AnyPublisher<UIImage, Error> {
        Just(TestData.createImage())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

extension MockMovieRepository {
    
    func clearGenres() {
        genres.removeAll()
    }
    
    func clearLanguages() {
        languages.removeAll()
    }
    
    func clearSimilarMovies() {
        similarMovies.removeAll()
    }
}
