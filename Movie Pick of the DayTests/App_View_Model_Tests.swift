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
        
        // (3) Then
        
    }
    
}
