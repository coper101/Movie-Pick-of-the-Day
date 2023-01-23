//
//  App_View_Model_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 12/1/23.
//

import XCTest
@testable import Movie_Pick_of_the_Day

final class App_View_Model_Tests: XCTestCase {

    var appDataRepository: AppDataRepositoryType!
    var movieRepository: (MovieRepositoryType & TMDBService)!
    var appViewModel: AppViewModel!

    override func setUpWithError() throws {
        appDataRepository = MockAppDataRepository()
        movieRepository =  MockMovieRepository()
        appViewModel = .init(
            appDataRepository,
            movieRepository,
            republishData: false
        )
    }

    override func tearDownWithError() throws {
        appDataRepository = nil
        movieRepository = nil
        appViewModel = nil
    }
    
    // MARK: Pick of the Day
    func test_load_movie_picks() throws {
        // (1) Given
        let movieDays = [
            TestData.createMovieDay(movieID: 104, day: .wednesday),
            TestData.createMovieDay(movieID: 105, day: .thursday),
            TestData.createMovieDay(movieID: 106, day: .friday),
            TestData.createMovieDay(movieID: 107, day: .saturday),
        ]
        
        // (2) When
        appDataRepository.setMoviePicksIDsOfTheWeek(movieDays)
        appViewModel.republishAppData()
        let moviePicks = appViewModel.moviePicks
        
        // (3) Then
        XCTAssertEqual(moviePicks[0].day, .wednesday)
        XCTAssertEqual(moviePicks[0].id, 104)

        XCTAssertEqual(moviePicks[1].day, .thursday)
        XCTAssertEqual(moviePicks[1].id, 105)

        XCTAssertEqual(moviePicks[2].day, .friday)
        XCTAssertEqual(moviePicks[2].id, 106)

        XCTAssertEqual(moviePicks[3].day, .saturday)
        XCTAssertEqual(moviePicks[3].id, 107)
    }
    
    func test_select_movie_pick_ids_of_the_week() throws {
        // (1) Given
        let preference = Preference(
            language: "EN",
            includeAdult: false,
            genres: ["Action", "Adventure"]
        )
        
        // (2) When
        appDataRepository.setPreference(preference)
        appViewModel.republishAppData()
        appDataRepository.setPreference(preference) /// again as it drops the first one
        
        let preferredMovies = appViewModel.moviePicks
        
        // (3) Then
        XCTAssertEqual(preferredMovies[0].id, 101)
        XCTAssertEqual(preferredMovies[1].id, 102)
        XCTAssertEqual(preferredMovies[2].id, 103)
        XCTAssertEqual(preferredMovies[3].id, 104)
        XCTAssertEqual(preferredMovies[4].id, 105)
        XCTAssertEqual(preferredMovies[5].id, 106)
        XCTAssertEqual(preferredMovies[6].id, 107)
    }
    
    func test_reSelect_movie_pick_ids_of_the_week() throws {
        // (1) Given
        let movies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
        
        // (2) When
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
        
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek

        // (3) Then
        XCTAssertEqual(moviePickIDs[0].day, .monday)
        XCTAssertGreaterThan(moviePickIDs[0].id, 100)

        XCTAssertEqual(moviePickIDs[1].day, .tuesday)
        XCTAssertGreaterThan(moviePickIDs[1].id, 100)

        XCTAssertEqual(moviePickIDs[2].day, .wednesday)
        XCTAssertGreaterThan(moviePickIDs[2].id, 100)

        XCTAssertEqual(moviePickIDs[3].day, .thursday)
        XCTAssertGreaterThan(moviePickIDs[3].id, 100)

        XCTAssertEqual(moviePickIDs[4].day, .friday)
        XCTAssertGreaterThan(moviePickIDs[4].id, 100)

        XCTAssertEqual(moviePickIDs[5].day, .saturday)
        XCTAssertGreaterThan(moviePickIDs[5].id, 100)

    }
    
    func test_reSelect_movie_pick_ids_of_the_week_last_day_of_week() throws {
        // (1) Given
        let movies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
        
        // (2) When
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-28T00:00:00+00:00".toDate()
        )
        
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek

        // (3) Then
        XCTAssertTrue(moviePickIDs.isEmpty)
    }
    
    func test_reSelect_movie_pick_ids_of_the_week_insufficient_movies() throws {
        // (1) Given
        let movies = [
            TestData.createMovie(id: 101)
        ]
        
        // (2) When
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
        
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek

        // (3) Then
        XCTAssertTrue(moviePickIDs.isEmpty)
    }
    
}
