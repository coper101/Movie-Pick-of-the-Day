//
//  Request.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Foundation

enum ImageResolution: String {
    case original
    case w500
}

struct GetImage: TMDBImageRequest {
    var path: String {
        "/t/p/\(imageResolution.rawValue)\(posterPath)"
    }
    
    var imageResolution: ImageResolution
    var posterPath: String
}



struct GetGenres: TMDBRequest {
    typealias Response = GetGenresResponse
    var path: String = "/3/genre/movie/list"
    var method: Method = .GET
    var parameters: [String: String] {
        [
            "api_key": apiKey,
            "language": language
        ]
    }
    
    var language: String = "en-US"
}

struct GetLanguages: TMDBRequest {
    typealias Response = [Language]
    var path: String = "/3/configuration/languages"
    var method: Method = .GET
    var parameters: [String: String] {
        [
            "api_key": apiKey
        ]
    }
}

struct GetMovie: TMDBRequest {
    typealias Response = Movie?
    var path: String {
        "/3/movie/\(id)"
    }
    var method: Method = .GET
    var parameters: [String: String] {
        [
            "api_key": apiKey,
            "language": language
        ]
    }
    
    var language: String = "en-US"
    var id: Int
}

struct GetSimilarMovies: TMDBRequest {
    typealias Response = GetMoviesResponse
    var path: String {
        "/3/movie/\(movieId)/similar"
    }
    var method: Method = .GET
    var parameters: [String: String] {
        [
            "api_key": apiKey,
            "language": language,
            "page": "\(page)"
        ]
    }
    
    var language: String = "en-US"
    var movieId: Int
    var page: Int = 1
}

struct GetDiscoverMovies: TMDBRequest {
    typealias Response = GetMoviesResponse
    var path: String {
        "/3/discover/movie"
    }
    var method: Method = .GET
    var parameters: [String: String] {
        [
            "api_key": apiKey,
            "language": language,
            "page": "\(page)",
            "sort_by": sortBy,
            "vote_average.gte": "\(voteAverageRange.lowerBound)",
            "vote_average.lte": "\(voteAverageRange.upperBound)",
            "vote_count.gte": "\(voteCountRange.lowerBound)",
            "vote_count.lte": "\(voteCountRange.upperBound)",
            "include_adult": "\(includeAdult)",
            "include_video": "\(includeVideo)",
            "with_genres": withGenres.joined(separator: "%2C"),
            "with_original_language": withOriginalLanguage
        ]
    }
    
    var language: String = "en"
    var page: Int = 1
    var sortBy: String = "popularity.desc"
    var includeAdult: Bool = true
    var includeVideo: Bool = false
    var voteAverageRange: ClosedRange = 1...10
    var voteCountRange: ClosedRange = 1...10
    var withGenres: [String] = [] // IDs
    var withOriginalLanguage: String = "en"
}

struct GetSearchMovies: TMDBRequest {
    typealias Response = GetMoviesResponse
    var path: String {
        "/3/search/movie"
    }
    var method: Method = .GET
    var parameters: [String: String] {
        [
            "api_key": apiKey,
            "language": language,
            "page": "\(page)",
            "include_adult": "\(includeAdult)",
            "query": query
        ]
    }
    
    var language: String = "en-US"
    var page: Int = 1
    var includeAdult: Bool = false
    var query: String
}
