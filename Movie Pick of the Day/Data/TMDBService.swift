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

protocol TMDBService {
    
    func getGenres() -> Void
    
    func getLanguages() -> Void
    
    func getMovie(with id: Int) -> AnyPublisher<Movie?, Never>
    
    func getSimilarMovies(of id: Int) -> Void
    
    func discoverMovies(
        includeAdult: Bool,
        language: String,
        with genres: [String]
    ) -> Void
    
    func searchMovie(with query: String) -> Void
    
    func getUIImage(
        of path: String,
        with resolution: ImageResolution
    ) -> AnyPublisher<UIImage, Error>
}
