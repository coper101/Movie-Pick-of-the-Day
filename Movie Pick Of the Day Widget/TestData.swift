//
//  TestData.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import Foundation

class TestData {
    
    static let sampleMovieDay = MovieDay(
        day: .monday,
        id: sampleMovie.id ?? 1,
        movie: sampleMovie
    )
    
    static let sampleMovie = createMovie(
        id: 76600,
        title: "Avatar: The Way of Water",
        overview: """
                Set more than a decade after the events of the first film, learn the story of the Sully family (Jake, Neytiri, and their kids), the trouble that follows them, the lengths they go to keep each other safe, the battles they fight to stay alive, and the tragedies they endure. Set more than a decade after the events of the first film, learn the story of the Sully family (Jake, Neytiri, and their kids), the trouble that follows them, the lengths they go to keep each other safe, the battles they fight to stay alive, and the tragedies they endure
                """,
        releasedDate: "2022-12-14",
        originalLanguage: "en",
        adult: false,
        voteAverage: 7.737
    )
    
    static func createMovie(
        id: Int,
        title: String? = nil,
        overview: String? = nil,
        releasedDate: String? = nil,
        originalLanguage: String? = nil,
        adult: Bool? = nil,
        voteAverage: Double? = nil
    ) -> Movie {
        .init(
            id: id,
            title: title,
            originalTitle: nil,
            overview: overview,
            releaseDate: releasedDate,
            voteAverage: voteAverage,
            voteCount: nil,
            popularity: nil,
            genreIDs: nil,
            adult: adult,
            video: nil,
            originalLanguage: originalLanguage,
            posterPath: nil,
            backdropPath: nil
        )
    }
}
