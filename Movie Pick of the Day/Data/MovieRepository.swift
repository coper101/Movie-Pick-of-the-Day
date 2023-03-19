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

enum MovieRepositoryError: Error, Equatable {
    case server
    case request
    
    var description: String {
        switch self {
        case .server:
            return "Something went wrong connecting to the Server"
        case .request:
            return "Something went wrong with your Request"
        }
    }
}


// MARK: Protocol
protocol MovieRepositoryType {
    
    /// Error
    var searchError: MovieRepositoryError? { get set }
    var searchErrorPublisher: Published<MovieRepositoryError?>.Publisher { get }
    
    var genresError: MovieRepositoryError? { get set }
    var genresErrorPublisher: Published<MovieRepositoryError?>.Publisher { get }
    
    var languagesError: MovieRepositoryError? { get set }
    var languagesErrorPublisher: Published<MovieRepositoryError?>.Publisher { get }
    
    var similarMoviesError: MovieRepositoryError? { get set }
    var similarMoviesErrorPublisher: Published<MovieRepositoryError?>.Publisher { get }

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
    
    var preferredMoviesPage: Int { get set }
    var preferredMoviesPagePublisher: Published<Int>.Publisher { get }
    
    func getPreferredMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String],
        currentPage: Int
    ) -> Void
    
    /// Searched Movies
    var searchedMovies: [Movie] { get set }
    var searchedMoviesPublisher: Published<[Movie]>.Publisher { get }
    func searchMovie(with query: String, page: Int) -> Void
    
    var pageNoOfSearchMovies: Int { get set }
    var pageNoOfSearchMoviesPublisher: Published<Int>.Publisher { get }
}


// MARK: App Implementation
class MovieRepository: MovieRepositoryType, ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    /// Error
    @Published var searchError: MovieRepositoryError?
    var searchErrorPublisher: Published<MovieRepositoryError?>.Publisher { $searchError }
    
    @Published var genresError: MovieRepositoryError?
    var genresErrorPublisher: Published<MovieRepositoryError?>.Publisher { $genresError }
    
    @Published var languagesError: MovieRepositoryError?
    var languagesErrorPublisher: Published<MovieRepositoryError?>.Publisher { $languagesError }
    
    @Published var similarMoviesError: MovieRepositoryError?
    var similarMoviesErrorPublisher: Published<MovieRepositoryError?>.Publisher { $similarMoviesError }

    /// Data
    @Published var genres: [Genre] = []
    var genresPublisher: Published<[Genre]>.Publisher { $genres }
    
    @Published var languages: [Language] = []
    var languagesPublisher: Published<[Language]>.Publisher { $languages }
    
    @Published var similarMovies: [Movie] = []
    var similarMoviesPublisher: Published<[Movie]>.Publisher { $similarMovies }
    
    @Published var preferredMovies: [Movie] = []
    var preferredMoviesPublisher: Published<[Movie]>.Publisher { $preferredMovies }
    
    @Published var preferredMoviesPage: Int = 0
    var preferredMoviesPagePublisher: Published<Int>.Publisher { $preferredMoviesPage }
    
    @Published var searchedMovies: [Movie] = []
    var searchedMoviesPublisher: Published<[Movie]>.Publisher { $searchedMovies }
    
    @Published var pageNoOfSearchMovies: Int = 1
    var pageNoOfSearchMoviesPublisher: Published<Int>.Publisher { $pageNoOfSearchMovies }
    
    /// Services
    func getGenres() {
        TMDBService.getGenres()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("getGenres - server error: \(message)")
                            self?.genresError = .server

                        case .request(let message):
                            Logger.movieRepository.debug("getGenres - request error: \(message)")
                            self?.genresError = .request
                            
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
                self.genresError = nil
                Logger.movieRepository.debug("getGenres - success: \(genres.map(\.name))")
            }
            .store(in: &subscriptions)
    }
    
    func getLanguages() {
        TMDBService.getLanguages()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("getLanguages - server error: \(message)")
                            self?.languagesError = .server

                        case .request(let message):
                            Logger.movieRepository.debug("getLanguages - request error: \(message)")
                            self?.languagesError = .request

                        default:
                            break
                        }
                    }
                case .finished:
                    Logger.movieRepository.debug("getLanguages - finished")
                }
            } receiveValue: { [weak self] languages in
                Logger.movieRepository.debug("getLanguages - receive value")
                guard let self else {
                    return
                }
                self.languages = languages
                self.languagesError = nil
                Logger.movieRepository.debug("getLanguages - success: \(languages.map(\.name))")
            }
            .store(in: &subscriptions)
    }
    
    func getMovie(with id: Int) -> AnyPublisher<Movie?, Never> {
        TMDBService.getMovie(with: id)
    }
    
    func getSimilarMovies(of id: Int) {
        TMDBService.getSimilarMovies(of: id)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("getSimilarMovies - server error: \(message)")
                            self?.similarMoviesError = .server

                        case .request(let message):
                            Logger.movieRepository.debug("getSimilarMovies - error: \(message)")
                            self?.similarMoviesError = .request

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
                self.similarMoviesError = nil
                Logger.movieRepository.debug("getSimilarMovies - success: \(results.map(\.title))")
            }
            .store(in: &subscriptions)
    }
    
    func getPreferredMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String],
        currentPage: Int
    ) {
        let nextPage = currentPage + 1
        
        return TMDBService.discoverMovies(
            includeAdult: includeAdult,
            language: language,
            originalLanguage: originalLanguage,
            with: genres,
            page: 1
        ).flatMap { response in
            guard nextPage > 1 else {
                Logger.movieRepository.debug("getPreferredMovies - getting page 1")
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            guard
                let totalPages = response.totalPages,
                nextPage <= totalPages
            else {
                Logger.movieRepository.debug("getPreferredMovies - getting page 1")
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            Logger.movieRepository.debug("getPreferredMovies - getting page \(nextPage)")
            return TMDBService.discoverMovies(
                includeAdult: includeAdult,
                language: language,
                originalLanguage: originalLanguage,
                with: genres,
                page: nextPage
            )
        }
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
            let currentPage = response.page ?? 1
            self.preferredMoviesPage = currentPage
            self.preferredMovies = results
            Logger.movieRepository.debug("getPreferredMovies - success: \(currentPage), \(results.map(\.title))")
        }
        .store(in: &subscriptions)
    }
    
    func searchMovie(with query: String, page: Int) {
        TMDBService.searchMovie(with: query, page: page)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if error is NetworkError {
                        let networkError = error as! NetworkError
                        
                        switch networkError {
                        case .server(let message):
                            Logger.movieRepository.debug("searchMovie - server error: \(message)")
                            self?.searchError = .server

                        case .request(let message):
                            Logger.movieRepository.debug("searchMovie - request error: \(message)")
                            self?.searchError = .request

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
                self.pageNoOfSearchMovies = response.page ?? 1
                
                if self.pageNoOfSearchMovies > 1 {
                    self.searchedMovies.append(contentsOf: results)
                } else {
                    self.searchedMovies = results
                }
                self.searchError = nil
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
    
    /// Error
    @Published var searchError: MovieRepositoryError?
    var searchErrorPublisher: Published<MovieRepositoryError?>.Publisher { $searchError }
    
    @Published var genresError: MovieRepositoryError?
    var genresErrorPublisher: Published<MovieRepositoryError?>.Publisher { $genresError }
    
    @Published var languagesError: MovieRepositoryError?
    var languagesErrorPublisher: Published<MovieRepositoryError?>.Publisher { $languagesError }
    
    @Published var similarMoviesError: MovieRepositoryError?
    var similarMoviesErrorPublisher: Published<MovieRepositoryError?>.Publisher { $similarMoviesError }
    
    @Published var preferredMoviesPage: Int = 0
    var preferredMoviesPagePublisher: Published<Int>.Publisher { $preferredMoviesPage }

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
    
    @Published var pageNoOfSearchMovies: Int = 0
    var pageNoOfSearchMoviesPublisher: Published<Int>.Publisher { $pageNoOfSearchMovies }
    
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
        with genres: [String],
        currentPage: Int
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
    
    func searchMovie(with query: String, page: Int) {
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
