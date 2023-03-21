//
//  App_Data_Repository_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 12/1/23.
//

import XCTest
@testable import Movie_Pick_of_the_Day

final class App_Data_Repository_Tests: XCTestCase {
    
    var repository: AppDataRepositoryType!

    override func setUpWithError() throws {
        repository =  MockAppDataRepository()
    }

    override func tearDownWithError() throws {
        repository = nil
    }
    
    // MARK: Movie Picks
    func test_get_movie_pick_ids() throws {
        // (1) Given
        // Sun - Sat
        // (2) When
        // (3) Then
        let moviePicks = repository.getMoviePicksOfTheWeek()

        XCTAssertEqual(moviePicks[0].day, .sunday)
        XCTAssertEqual(moviePicks[1].day, .monday)
        XCTAssertEqual(moviePicks[2].day, .tuesday)
        XCTAssertEqual(moviePicks[3].day, .wednesday)
        XCTAssertEqual(moviePicks[4].day, .thursday)
        XCTAssertEqual(moviePicks[5].day, .friday)
        XCTAssertEqual(moviePicks[6].day, .saturday)
    }
    
    func test_set_movie_pick_ids() throws {
        // (1) Given
        let moviePicks =  [
            TestData.createMovieDay(movieID: 106, day: .friday),
            TestData.createMovieDay(movieID: 107, day: .saturday)
        ]
        
        // (2) When
        repository.setMoviePicksOfTheWeek(moviePicks)
        
        // (3) Then
        let updatedMoviePickIDs = repository.moviePicksOfTheWeek

        XCTAssertEqual(updatedMoviePickIDs[0].day, .friday)
        XCTAssertEqual(updatedMoviePickIDs[1].day, .saturday)
    }
    
    // MARK: Preference
    func test_get_preference() throws {
        // (1) Given
        // (2) When
        // (3) Then
        let preference = try XCTUnwrap(repository.getPreference())

        XCTAssertEqual(preference.language, "EN")
        XCTAssertEqual(preference.originalLanguage, "EN")
        XCTAssertEqual(preference.includeAdult, true)
        XCTAssertEqual(preference.genres[0], TestData.createGenre(name: "Action"))
        XCTAssertEqual(preference.genres[1], TestData.createGenre(name: "Adventure"))
    }
    
    func test_set_preference() throws {
        // (1) Given
        let preference = Preference(
            language: "EN",
            originalLanguage: "DE",
            includeAdult: false,
            genres: [TestData.createGenre(name: "Action")]
        )
        // (2) When
        repository.setPreference(preference)
        
        // (3) Then
        let updatePreference = try XCTUnwrap(repository.preference)

        XCTAssertEqual(updatePreference.language, "EN")
        XCTAssertEqual(updatePreference.originalLanguage, "DE")
        XCTAssertEqual(updatePreference.includeAdult, false)
        XCTAssertEqual(updatePreference.genres[0], TestData.createGenre(name: "Action"))
    }
    
    // MARK: Week Tracker
    func test_get_week_end_date() throws {
        // (1) Given
        // (2) When
        // (3) Then
        let weekendEndDate = try XCTUnwrap(repository.getWeekEndDate())

        XCTAssertEqual(weekendEndDate, "2023-01-01".toDate())
    }
    
    func test_set_week_end_date() throws {
        // (1) Given
        let weekendEndDate = try XCTUnwrap("2023-01-02".toDate())
        
        // (2) When
        repository.setWeekEndDate(to: weekendEndDate)
        
        // (3) Then
        let updatedWeekendEndDate = try XCTUnwrap(repository.weekEndDate)

        XCTAssertEqual(updatedWeekendEndDate, "2023-01-02".toDate())
    }
    
    // MARK: Current Movies Preferred Page
    func test_current_movies_preferred_page() throws {
        // (1) Given
        // (2) When
        // (3) Then
        let page = repository.getCurrentMoviesPreferredPage()

        XCTAssertEqual(page, 0)
    }
    
    func test_set_current_movies_preferred_page() throws {
        // (1) Given
        let nextPage = 1
        
        // (2) When
        repository.setCurretMoviesPreferredPage(nextPage)
        
        // (3) Then
        let updatedPage = repository.currentMoviesPreferredPage

        XCTAssertEqual(updatedPage, 1)
    }
}


