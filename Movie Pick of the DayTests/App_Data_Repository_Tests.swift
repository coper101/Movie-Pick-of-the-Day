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
    
    // MARK: Movie Pick IDs
    func test_get_movie_pick_ids() throws {
        // (1) Given
        /**
             TestData.createMovieDay(movieID: 104, day: .wednesday),
             TestData.createMovieDay(movieID: 105, day: .thursday),
             TestData.createMovieDay(movieID: 106, day: .friday),
             TestData.createMovieDay(movieID: 107, day: .saturday),
         */
        
        // (2) When
        let theMoviePickIDs = repository.getMoviePicksIDsOfTheWeek()
        
        // (3) Then
        XCTAssertEqual(theMoviePickIDs[0].day, .wednesday)
        XCTAssertEqual(theMoviePickIDs[1].day, .thursday)
        XCTAssertEqual(theMoviePickIDs[2].day, .friday)
        XCTAssertEqual(theMoviePickIDs[3].day, .saturday)
    }
    
    func test_set_movie_pick_ids() throws {
        // (1) Given
        let moviePickIDs =  [
            TestData.createMovieDay(movieID: 106, day: .friday),
            TestData.createMovieDay(movieID: 107, day: .saturday)
        ]
        
        // (2) When
        repository.setMoviePicksIDsOfTheWeek(moviePickIDs)
        let updatedMoviePickIDs = repository.moviePickIDsOfTheWeek
        
        // (3) Then
        XCTAssertEqual(updatedMoviePickIDs[0].day, .friday)
        XCTAssertEqual(updatedMoviePickIDs[1].day, .saturday)
    }
    
    // MARK: Preference
    func test_get_preference() throws {
        // (1) Given
        /**
            Preference(
                 language: "EN",
                 includeAdult: false,
                 genres: ["Action", "Adventure"]
            )
         */
        
        // (2) When
        let preference = repository.getPreference()
        
        // (3) Then
        XCTAssertNotNil(preference)
        XCTAssertEqual(preference!.language, "EN")
        XCTAssertEqual(preference!.includeAdult, false)
        XCTAssertEqual(preference!.genres, ["Action", "Adventure"])
    }
    
    func test_set_preference() throws {
        // (1) Given
        let preference = Preference(
            language: "EN",
            includeAdult: true,
            genres: ["Action"]
        )
        
        // (2) When
        repository.setPreference(preference)
        let updatedPreference = repository.preference
        
        // (3) Then
        XCTAssertNotNil(updatedPreference)
        XCTAssertEqual(updatedPreference!.language, "EN")
        XCTAssertEqual(updatedPreference!.includeAdult, true)
        XCTAssertEqual(updatedPreference!.genres, ["Action"])
    }
    
}


