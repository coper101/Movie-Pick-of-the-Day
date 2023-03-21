//
//  Pager_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 21/3/23.
//

import XCTest
@testable import Movie_Pick_of_the_Day

final class Pager_Tests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    /// hasNewItems()
    func test_has_new_items_first_time_searching() throws {
        // (1) Given
        let currentPage = 1
        let totalPage = 1
        
        // (2) When
        let hasNewItems = Pager.hasNewItems(current: currentPage, total: totalPage)
        
        // (3) Given
        XCTAssertTrue(hasNewItems)
    }

    func test_has_new_items_load_more_items_success() throws {
        // (1) Given
        let currentPage = 2
        let totalPage = 2
        
        // (2) When
        let hasNewItems = Pager.hasNewItems(current: currentPage, total: totalPage)
        
        // (3) Given
        XCTAssertTrue(hasNewItems)
    }

    func test_has_new_items_load_more_items_fail() throws {
        // (1) Given
        let currentPage = 2
        let totalPage = 1
        
        // (2) When
        let hasNewItems = Pager.hasNewItems(current: currentPage, total: totalPage)
        
        // (3) Given
        XCTAssertFalse(hasNewItems)
    }
    
    func test_has_new_items_first_time_searching_with_nil_total_pages() throws {
        // (1) Given
        let currentPage = 1
        let totalPage: Int? = nil
        
        // (2) When
        let hasNewItems = Pager.hasNewItems(current: currentPage, total: totalPage)
        
        // (3) Given
        XCTAssertTrue(hasNewItems)
    }
    
    func test_has_new_items_load_more_items_fail_with_nil_total_pages() throws {
        // (1) Given
        let currentPage = 2
        let totalPage: Int? = nil
        
        // (2) When
        let hasNewItems = Pager.hasNewItems(current: currentPage, total: totalPage)
        
        // (3) Given
        XCTAssertFalse(hasNewItems)
    }
}
