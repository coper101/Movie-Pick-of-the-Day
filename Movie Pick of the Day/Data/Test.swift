//
//  Test.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation
import UIKit

/*
 Avatar - The Way of Water (Sample Movie)
{
     "adult": false,
     "backdrop_path": "/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg",
     "genre_ids": [
       878,
       12,
       28
     ],
     "id": 76600,
     "original_language": "en",
     "original_title": "Avatar: The Way of Water",
     "overview": "Set more than a decade after the events of the first film, learn the story of the Sully family (Jake, Neytiri, and their kids), the trouble that follows them, the lengths they go to keep each other safe, the battles they fight to stay alive, and the tragedies they endure.",
     "popularity": 1601.327,
     "poster_path": "/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg",
     "release_date": "2022-12-14",
     "title": "Avatar: The Way of Water",
     "video": false,
     "vote_average": 7.737,
     "vote_count": 5243
}
 */

class TestData {
    
    // MARK: Movie
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
    
    static func createMovieDay(movieID: Int, day: Day, movie: Movie? = nil) -> MovieDay {
        .init(day: day, id: movieID, movie: movie)
    }
    
    static func createImage(
        color: UIColor = .black,
        width: CGFloat = 1080,
        height: CGFloat = 1920
    ) -> UIImage {
        .init(
            color: color,
            size: .init(width: width, height: height)
        )!
    }
    
    static let sampleMovieEmpty = createMovie(id: 7660)
    
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
    
    static let sampleMovies: [Movie] = [
        createMovie(id: 101, title: "Toy Story"),
        createMovie(id: 102, title: "Toy Story 2"),
        createMovie(id: 103, title: "Toy Story 3"),
        createMovie(id: 104, title: "Toy Story 4"),
        createMovie(id: 105, title: "Toy Story Soldiers"),
        createMovie(id: 106, title: "Toy Story That Time Forgot")
    ]
    
    static let sampleMovieDay = MovieDay(
        day: .monday,
        id: sampleMovie.id ?? 1,
        movie: sampleMovie
    )
    
    static var sampleMoviePicks: [MovieDay] = [
        TestData.createMovieDay(
            movieID: 100, day: .sunday,
            movie: TestData.sampleMovie
        ),
        TestData.createMovieDay(
            movieID: 101, day: .monday,
            movie: TestData.sampleMovie
        ),
        TestData.createMovieDay(
            movieID: 102, day: .tuesday,
            movie: TestData.sampleMovie
        ),
        TestData.createMovieDay(
            movieID: 103, day: .wednesday,
            movie: TestData.sampleMovie
        ),
        TestData.createMovieDay(
            movieID: 104, day: .thursday,
            movie: TestData.sampleMovie
        ),
        TestData.createMovieDay(
            movieID: 105, day: .friday,
            movie: TestData.sampleMovie
        ),
        TestData.createMovieDay(
            movieID: 106, day: .saturday,
            movie: TestData.sampleMovie
        )
    ]
    
    // MARK: Preferences
    static func createLanguage(englishName: String) -> Language {
        .init(iso6391: nil, englishName: englishName, name: nil)
    }
    
    static func createGenre(name: String) -> Genre {
        .init(id: 1, name: name)
    }
    
    static var sampleLanguages: [Language] = [
        createLanguage(englishName: "English"),
        createLanguage(englishName: "Chinese"),
        createLanguage(englishName: "German")
    ]
    
    static var sampleGenres: [Genre] = [
        createGenre(name: "Action"),
        createGenre(name: "Adventure"),
        createGenre(name: "Animation"),
        createGenre(name: "Comedy"),
        createGenre(name: "Crime"),
        createGenre(name: "Documentary"),
        createGenre(name: "Drama"),
        createGenre(name: "Family"),
        createGenre(name: "Fantasy"),
        createGenre(name: "History"),
        createGenre(name: "Music"),
        createGenre(name: "Mystery")
    ]
    
    static var samplePreference: Preference = .init(
        language: "EN",
        originalLanguage: "EN",
        includeAdult: true,
        genres: Array(sampleGenres[..<4])
    )
}

extension TestData {

    static var appViewModel: AppViewModel {
        let appViewModel = AppViewModel(republishData: false)
        
        appViewModel.hasInternetConnection = true
        
        appViewModel.moviePicks = sampleMoviePicks
        appViewModel.searchedMovies = sampleMovies
        appViewModel.similarMovies = sampleMovies
        
        appViewModel.languages = sampleLanguages
        appViewModel.genres = sampleGenres
        appViewModel.isAdultSelected = false
        
        appViewModel.preference = samplePreference
        
        return appViewModel
    }
    
}

extension UIImage {
    
  convenience init?(
    color: UIColor,
    size: CGSize
  ) {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    
      guard let cgImage = image?.cgImage else {
          return nil
      }
      self.init(cgImage: cgImage)
  }
    
}


// MARK: Test Implementation
class MockAppDataRepository: AppDataRepositoryType {
    
    /// Data
    @Published var moviePicksOfTheWeek: [MovieDay] = []
    var moviePicksOfTheWeekPublisher: Published<[MovieDay]>.Publisher { $moviePicksOfTheWeek }
    
    @Published var preference: Preference?
    var preferencePublisher: Published<Preference?>.Publisher { $preference }
    
    @Published var weekEndDate: Date?
    var weekEndDatePublisher: Published<Date?>.Publisher { $weekEndDate }
    
    @Published var currentMoviesPreferredPage: Int = 0
    var currentMoviesPreferredPagePublisher: Published<Int>.Publisher { $currentMoviesPreferredPage }
    
    /// Setters and Getters
    /// - Movie Picks
    func getMoviePicksOfTheWeek() -> [MovieDay] {
        TestData.sampleMoviePicks
    }
    
    func setMoviePicksOfTheWeek(_ movieDays: [MovieDay]) {
        moviePicksOfTheWeek = movieDays
        
    }
    
    /// - Preference
    func getPreference() -> Preference? {
        TestData.samplePreference
    }
    
    func setPreference(_ preference: Preference) {
        self.preference = preference
    }
    
    /// - Week Tracker
    func getWeekEndDate() -> Date? {
        "2023-01-01".toDate()
    }
    
    func setWeekEndDate(to endDate: Date) {
        self.weekEndDate = endDate
    }
    
    /// - Current Movies Preferred Page
    func getCurrentMoviesPreferredPage() -> Int {
       0
    }
    
    func setCurretMoviesPreferredPage(_ page: Int) {
        self.currentMoviesPreferredPage = page
    }
}

