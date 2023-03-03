//
//  TMDBService.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Foundation
import Combine
import UIKit

protocol TMDBRequest: Request {
    var apiKey: String { get }
}

protocol TMDBImageRequest: ImageRequest {}

extension TMDBImageRequest {
    var host: String { "image.tmdb.org" }
    var scheme: String { "https" }
}

extension TMDBRequest {
    var apiKey: String { TMDB_API_KEY }
    var host: String { "api.themoviedb.org" }
    var scheme: String { "https" }
    var parameters: [String: String] { .init() }
}

protocol TMDBServiceType {
    
    static func getGenres() -> AnyPublisher<GetGenres.Response, Error>
    
    static func getLanguages() -> AnyPublisher<GetLanguages.Response, Error>
    
    static func getMovie(with id: Int) -> AnyPublisher<Movie?, Never>
    
    static func getSimilarMovies(of id: Int) -> AnyPublisher<GetSimilarMovies.Response, Error>
    
    static func discoverMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String],
        page: Int
    ) -> AnyPublisher<GetDiscoverMovies.Response, Error>
    
    static func searchMovie(with query: String) -> AnyPublisher<GetSearchMovies.Response, Error>
    
    static func getUIImage(
        of path: String,
        with resolution: ImageResolution
    ) -> AnyPublisher<UIImage, Error>
}


// MARK: App Implementation
class TMDBService: TMDBServiceType {
    
    static func getGenres() -> AnyPublisher<GetGenres.Response, Error> {
        Networking.request(request: GetGenres())
    }
    
    static func getLanguages() -> AnyPublisher<GetLanguages.Response, Error> {
        Networking.request(request: GetLanguages())
    }
    
    static func getMovie(with id: Int) -> AnyPublisher<Movie?, Never> {
        Networking.request(request: GetMovie(id: id))
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    static func getSimilarMovies(of id: Int) -> AnyPublisher<GetSimilarMovies.Response, Error> {
        Networking.request(request: GetSimilarMovies(movieId: id))
    }
    
    static func discoverMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String],
        page: Int
    ) -> AnyPublisher<GetDiscoverMovies.Response, Error> {
        Networking.request(
            request: GetDiscoverMovies(
                language: language,
                page: page,
                includeAdult: includeAdult,
                withGenres: genres,
                withOriginalLanguage: originalLanguage
            )
        )
    }
    
    static func searchMovie(with query: String) -> AnyPublisher<GetSearchMovies.Response, Error> {
        Networking.request(request: GetSearchMovies(query: query))
    }
    
    static func getUIImage(
        of path: String,
        with resolution: ImageResolution
    ) -> AnyPublisher<UIImage, Error> {
        Networking.requestImage(
            request: GetImage(
                imageResolution: resolution,
                posterPath: path
            )
        )
    }    
    
}
