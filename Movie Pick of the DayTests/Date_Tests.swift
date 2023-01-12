//
//  Date_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 12/1/23.
//

import XCTest
@testable import Movie_Pick_of_the_Day

final class Date_Tests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    /// getRemainingWeekDaysRange()
    func test_get_remaining_weekdays_range() throws {
        // (1) Given
        let date = "2023-01-12T00:00:00+00:00".toDate()

        // (2) When
        let range = date.getRemainingWeekDaysRange()
        let start = range.first
        let end = range.last
        
        // (3) Then
        XCTAssertNotNil(start)
        XCTAssertEqual(start, 5)
        
        XCTAssertNotNil(end)
        XCTAssertEqual(end, 7)
    }
    
    func test_get_remaining_weekday_range_left_one_weekday() throws {
        // (1) Given
        let date = "2023-01-14T00:00:00+00:00".toDate()

        // (2) When
        let range = date.getRemainingWeekDaysRange()
        let start = range.first
        let end = range.last
        
        // (3) Then
        XCTAssertNotNil(start)
        XCTAssertEqual(start, 7)
        
        XCTAssertNotNil(end)
        XCTAssertEqual(end, 7)
    }
    
    func test_get_remaining_weekday_range_complete_week() throws {
        // (1) Given
        let date = "2023-01-08T00:00:00+00:00".toDate()

        // (2) When
        let range = date.getRemainingWeekDaysRange()
        let start = range.first
        let end = range.last
        
        // (3) Then
        XCTAssertNotNil(start)
        XCTAssertEqual(start, 1)
        
        XCTAssertNotNil(end)
        XCTAssertEqual(end, 7)
    }

    /// getRemainingWeekDaysCount()
    func test_get_remaining_weekday_count() throws {
        // (1) Given
        let date = "2023-01-12T00:00:00+00:00".toDate()
        
        // (2) When
        let count = date.getRemainingWeekDaysCount()
        
        // (3) Then
        XCTAssertNotEqual(count, 3)
    }
    
    func test_get_remaining_weekday_count_left_one_day() throws {
        // (1) Given
        let date = "2023-01-14T00:00:00+00:00".toDate()
        
        // (2) When
        let count = date.getRemainingWeekDaysCount()
        
        // (3) Then
        XCTAssertNotEqual(count, 1)
    }
    
    func test_get_remaining_weekday_count_complete_week() throws {
        // (1) Given
        let date = "2023-01-08T00:00:00+00:00".toDate()
        
        // (2) When
        let count = date.getRemainingWeekDaysCount()
        
        // (3) Then
        XCTAssertNotEqual(count, 7)
    }

}
