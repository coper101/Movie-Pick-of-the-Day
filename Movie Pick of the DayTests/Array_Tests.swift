//
//  Array_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 12/1/23.
//

import XCTest
@testable import Movie_Pick_of_the_Day

final class Array_Tests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws { }
    
    // MARK: Shuffle
    func test_shuffle_with_valid_keep() throws {
        // (1) Given
        let movies = [
            TestData.createMovie(id: 1),
            TestData.createMovie(id: 2),
            TestData.createMovie(id: 3),
            TestData.createMovie(id: 4),
            TestData.createMovie(id: 5)
        ]
        let keep = 2
        
        // (2) When
        let moviePicks = movies.shuffle(keep: keep)
        
        // (3) Then
        XCTAssertNotNil(moviePicks)
        XCTAssertEqual(moviePicks!.count, 2)
    }
    
    func test_shuffle_with_invvalid_keep() throws {
        // (1) Given
        let movies = [
            TestData.createMovie(id: 1)
        ]
        let keep = 2
        
        // (2) When
        let moviePicks = movies.shuffle(keep: keep)
        
        // (3) Then
        XCTAssertNil(moviePicks)
    }
    
    // MARK: Picks
    func test_get_todays_movie_day() throws {
        // (1) Given
        let moviePicks: [MovieDay] = [
            .init(day: .sunday, id: 101),
            .init(day: .monday, id: 102),
            .init(day: .tuesday, id: 103),
            .init(day: .wednesday, id: 104),
            .init(day: .thursday, id: 105),
            .init(day: .friday, id: 106),
            .init(day: .saturday, id: 107)
        ]
        // Jan 22, Sunday (index 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())
        
        // (2) When
        let todaysMovieDay = moviePicks.getTodaysMovieDay(todaysDate: todaysDate)
        
        // (3) Then
        XCTAssertEqual(todaysMovieDay, .init(day: .sunday, id: 101))
    }
    
    func test_get_todays_movie_day_is_nil() throws {
        // (1) Given
        let moviePicks: [MovieDay] = []
        // Jan 22, Sunday (index 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())
        
        // (2) When
        let todaysMovieDay = moviePicks.getTodaysMovieDay(todaysDate: todaysDate)
        
        // (3) Then
        XCTAssertNil(todaysMovieDay)
    }
    
    func test_get_next_movie_days() throws {
        // (1) Given
        let moviePicks: [MovieDay] = [
            .init(day: .sunday, id: 101),
            .init(day: .monday, id: 102),
            .init(day: .tuesday, id: 103),
            .init(day: .wednesday, id: 104),
            .init(day: .thursday, id: 105),
            .init(day: .friday, id: 106),
            .init(day: .saturday, id: 107)
        ]
        // Jan 22, Sunday (index 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())
        
        // (2) When
        let nextMovieDays = moviePicks.getNextMovieDays(todaysDate: todaysDate)
        
        // (3) Then
        XCTAssertEqual(nextMovieDays.count, 6)
        XCTAssertEqual(nextMovieDays[0], .init(day: .monday, id: 102))
        XCTAssertEqual(nextMovieDays[1], .init(day: .tuesday, id: 103))
        XCTAssertEqual(nextMovieDays[2], .init(day: .wednesday, id: 104))
        XCTAssertEqual(nextMovieDays[3], .init(day: .thursday, id: 105))
        XCTAssertEqual(nextMovieDays[4], .init(day: .friday, id: 106))
        XCTAssertEqual(nextMovieDays[5], .init(day: .saturday, id: 107))
    }
    
    func test_get_next_movie_days_is_empty() throws {
        // (1) Given
        let moviePicks: [MovieDay] = []
        // Jan 22, Sunday (index 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())
        
        // (2) When
        let nextMovieDays = moviePicks.getNextMovieDays(todaysDate: todaysDate)
        
        // (3) Then
        XCTAssertTrue(nextMovieDays.isEmpty)
    }
}

