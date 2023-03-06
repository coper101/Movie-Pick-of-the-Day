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
            originalLanguage: "EN",
            includeAdult: false,
            genres: [
                Genre(id: 1, name: "Action"),
                Genre(id: 2, name: "Adventure"),
            ]
        )
        
        // (2) When
        let dictionary = try XCTUnwrap(DictionaryCoder.getDictionary(of: preference))

        // (3) Then
        XCTAssertEqual(dictionary["language"] as! String, "EN")
        XCTAssertEqual(dictionary["originalLanguage"] as! String, "EN")
        XCTAssertEqual(dictionary["includeAdult"] as! Bool, false)
        
        let genresDic = dictionary["genres"] as! [[String: Any]]
        
        XCTAssertEqual(genresDic[0]["id"] as! Int, 1)
        XCTAssertEqual(genresDic[0]["name"] as! String, "Action")

        XCTAssertEqual(genresDic[1]["id"] as! Int, 2)
        XCTAssertEqual(genresDic[1]["name"] as! String, "Adventure")
    }
    
    func test_decode_preference() throws {
        // (1) Given
        let preferenceDictionary: [String: Any] = [
            "language": "EN",
            "originalLanguage": "EN",
            "includeAdult": false,
            "genres": [
                ["id": 1, "name": "Action"],
                ["id": 2, "name": "Adventure"]
            ]
        ]
        
        // (2) When
        let pref: Preference? = DictionaryCoder.getType(of: preferenceDictionary)
        let preference = try XCTUnwrap(pref)
        
        // (3) Then
        XCTAssertEqual(preference.language, "EN")
        XCTAssertEqual(preference.originalLanguage, "EN")
        XCTAssertEqual(preference.includeAdult, false)
        XCTAssertEqual(
            preference.genres,
            [
                Genre(id: 1, name: "Action"),
                Genre(id: 2, name: "Adventure"),
            ]
        )
    }
}
