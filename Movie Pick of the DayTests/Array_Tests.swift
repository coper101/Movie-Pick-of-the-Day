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
    
}
