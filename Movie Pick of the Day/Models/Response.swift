//
//  Response.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Foundation

struct GetGenresResponse: Decodable {
    /// Success
    let genres: [Genre]?
    /// Fail
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case genres
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct GetMoviesResponse: Decodable {
    /// Success
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    /// Fail
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
