//
//  Dictionary_Coder_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 7/1/23.
//

import XCTest
@testable import Movie_Pick_of_the_Day

final class Dictionary_Coder_Tests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_encode_preference() throws {
        // (1) Given
        let preference = Preference(
            language: "EN",
            includeAdult: false,
            genres: ["Action", "Adventure"]
        )
        
        // (2) When
        let dictionary = DictionaryCoder.getDictionary(of: preference)
        
        // (3) Then
        XCTAssertNotNil(dictionary)
        XCTAssertEqual(dictionary!["language"] as! String, "EN")
        XCTAssertEqual(dictionary!["includeAdult"] as! Bool, false)
        XCTAssertEqual(dictionary!["genres"] as! [String], ["Action", "Adventure"])
    }
    
    func test_decode_preference() throws {
        // (1) Given
        let preferenceDictionary: [String: Any] = [
            "language": "EN",
            "includeAdult": false,
            "genres": ["Action", "Adventure"]
        ]
        
        // (2) When
        let preference: Preference? = DictionaryCoder.getType(of: preferenceDictionary)
        
        // (3) Then
        XCTAssertNotNil(preference)
        XCTAssertEqual(preference!.language, "EN")
        XCTAssertEqual(preference!.includeAdult, false)
        XCTAssertEqual(preference!.genres, ["Action", "Adventure"])
    }

    func test_movie_days_to_dictionary() throws {
        // (1) Given
        let movieDays: [MovieDay] = [
            TestData.createMovieDay(movieID: 101, day: .sunday),
            TestData.createMovieDay(movieID: 102, day: .monday),
            TestData.createMovieDay(movieID: 103, day: .tuesday),
            TestData.createMovieDay(movieID: 104, day: .wednesday),
            TestData.createMovieDay(movieID: 105, day: .thursday),
            TestData.createMovieDay(movieID: 106, day: .friday),
            TestData.createMovieDay(movieID: 107, day: .saturday)
        ]
        
        // (2) When
        let dictionary = movieDays.toDictionary()
        
        // (3) Then
        XCTAssertEqual(dictionary[1], 101)
        XCTAssertEqual(dictionary[2], 102)
        XCTAssertEqual(dictionary[3], 103)
        XCTAssertEqual(dictionary[4], 104)
        XCTAssertEqual(dictionary[5], 105)
        XCTAssertEqual(dictionary[6], 106)
        XCTAssertEqual(dictionary[7], 107)
    }
}
