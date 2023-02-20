//
//  Movie.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

struct Movie: Codable, CustomDebugStringConvertible, Identifiable {
    let id: Int?
    let title: String?
    let originalTitle: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    let genreIDs: [Int]?
    let adult: Bool?
    let video: Bool?
    let originalLanguage: String?
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genreIDs = "genre_ids"
        case adult
        case video
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    var debugDescription: String {
        """
            
            id: \(id ?? 0)
            title: \(title ?? "")
            
            """
    }
    
    var displayedTitle: String {
        title ?? "NA"
    }
    
    var displayedOverview: String {
        overview ?? "NA"
    }
    
    var displayedVoteAverage: String {
        guard let voteAverage else {
            return "NA"
        }
        return "\(voteAverage.toDp()) / 10"
    }
    
    var displayedReleasedDate: String {
        guard
            let releaseDate,
            let date = releaseDate.toDate()
        else {
            return "NA"
        }
        return date.toDayMonthYearFormat()
    }
    
    var displayedLanguage: String {
        originalLanguage?.uppercased() ?? "NA"
    }
}
