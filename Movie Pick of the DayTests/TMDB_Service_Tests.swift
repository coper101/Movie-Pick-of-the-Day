//
//  Movie_Repository_Tests.swift
//  Movie Pick of the DayTests
//
//  Created by Wind Versi on 26/1/23.
//

import XCTest
import Combine
@testable import Movie_Pick_of_the_Day

// MARK: Mock Implementation
class MockTMDBService: TMDBServiceType {
    
    static func getGenres() -> AnyPublisher<GetGenres.Response, Error> {
        Just(
            GetGenresResponse(
                genres: [
                    .init(id: 1, name: "Action"),
                    .init(id: 2, name: "Adventure")
                ],
                success: true,
                statusCode: nil,
                statusMessage: nil
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    static func getLanguages() -> AnyPublisher<GetLanguages.Response, Error> {
        Just(
            [
                .init(
                    iso6391: "en",
                    englishName: "English",
                    name: ""
                ),
                .init(
                    iso6391: "de",
                    englishName: "German",
                    name: "Deutsch"
                )
            ]
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    
    static func getMovie(with id: Int) -> AnyPublisher<Movie?, Never> {
        Just(TestData.createMovie(id: id))
            .eraseToAnyPublisher()
    }
    
    static func getSimilarMovies(of id: Int) -> AnyPublisher<GetSimilarMovies.Response, Error> {
        Just(
            GetSimilarMovies.Response(
                page: 1,
                results: [
                    TestData.createMovie(id: 101, title: "Toy Story 1"),
                    TestData.createMovie(id: 102, title: "Toy Story 2")
                ],
                totalPages: 1,
                totalResults: 2,
                success: true,
                statusCode: nil,
                statusMessage: nil
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    static func discoverMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String],
        page: Int
    ) -> AnyPublisher<GetDiscoverMovies.Response, Error> {
        Just(
            GetDiscoverMovies.Response(
                page: 1,
                results: [
                    TestData.createMovie(id: 101),
                    TestData.createMovie(id: 102),
                ],
                totalPages: 1,
                totalResults: 2,
                success: true,
                statusCode: nil,
                statusMessage: nil
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    static func searchMovie(with query: String) -> AnyPublisher<GetSearchMovies.Response, Error> {
        Just(
            GetDiscoverMovies.Response(
                page: 1,
                results: [
                    TestData.createMovie(id: 101, title: "Toy Story 1"),
                    TestData.createMovie(id: 102, title: "Toy Story 2")
                ],
                totalPages: 1,
                totalResults: 2,
                success: true,
                statusCode: nil,
                statusMessage: nil
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    static func getUIImage(
        of path: String,
        with resolution: ImageResolution
    ) -> AnyPublisher<UIImage, Error> {
        Just(TestData.createImage())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

class MockFailTMDBService: TMDBServiceType {
    
    static func getGenres() -> AnyPublisher<GetGenres.Response, Error> {
        Fail(error: NetworkError.server("Server Error"))
            .eraseToAnyPublisher()
    }
    
    static func getLanguages() -> AnyPublisher<GetLanguages.Response, Error> {
        Fail(error: NetworkError.server("Server Error"))
            .eraseToAnyPublisher()
    }

    
    static func getMovie(with id: Int) -> AnyPublisher<Movie?, Never> {
        Just(nil)
            .eraseToAnyPublisher()
    }
    
    static func getSimilarMovies(of id: Int) -> AnyPublisher<GetSimilarMovies.Response, Error> {
        Fail(error: NetworkError.server("Server Error"))
            .eraseToAnyPublisher()
    }
    
    static func discoverMovies(
        includeAdult: Bool,
        language: String,
        originalLanguage: String,
        with genres: [String],
        page: Int
    ) -> AnyPublisher<GetDiscoverMovies.Response, Error> {
        Fail(error: NetworkError.server("Server Error"))
            .eraseToAnyPublisher()
    }
    
    static func searchMovie(with query: String) -> AnyPublisher<GetSearchMovies.Response, Error> {
        Fail(error: NetworkError.server("Server Error"))
            .eraseToAnyPublisher()
    }
    
    static func getUIImage(
        of path: String,
        with resolution: ImageResolution
    ) -> AnyPublisher<UIImage, Error> {
        Fail(error: NetworkError.server("Server Error"))
            .eraseToAnyPublisher()
    }
    
}


// MARK: Test
final class TMDB_Service_Tests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        subscriptions = .init()
    }

    override func tearDownWithError() throws {
        subscriptions = nil
    }

    /// getGenres()
    func test_get_genres_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Genres")
        
        MockTMDBService.getGenres()
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { response in
                let genres = response.genres
                
                // (3) Then
                XCTAssertNotNil(genres)
                XCTAssertEqual(genres!.count, 2)
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func test_get_genres_server_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Genres")
        
        MockFailTMDBService.getGenres()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    
                    // (3) Then
                    XCTAssertEqual(error as! NetworkError, .server("Server Error"))
                    expectation.fulfill()
                    
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    /// getLanguages()
    func test_get_languages_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Languages")
        
        MockTMDBService.getLanguages()
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { languages in
                
                // (3) Then
                XCTAssertEqual(languages.count, 2)
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }

    func test_get_languages_server_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Languages")
        
        MockFailTMDBService.getLanguages()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    
                    // (3) Then
                    XCTAssertEqual(error as! NetworkError, .server("Server Error"))
                    expectation.fulfill()
                    
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }

    /// getMovie()
    func test_get_movie_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Movie")
        
        MockTMDBService.getMovie(with: 101)
            .sink { movie in
                
                // (3) Then
                XCTAssertNotNil(movie)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }

    func test_get_movie_server_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Movie")

        MockFailTMDBService.getMovie(with: 101)
            .sink { movie in
                
                // (3) Then
                XCTAssertNil(movie)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    /// getSimilarMovies()
    func test_get_similar_movies_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Similar Movies")
        
        MockTMDBService.getSimilarMovies(of: 101)
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { response in
                
                // (3) Then
                let movies = response.results
                XCTAssertNotNil(movies)
                XCTAssertEqual(movies!.count, 2)
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func test_get_similar_movies_server_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get Similar Movies")

        MockFailTMDBService.getSimilarMovies(of: 101)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    
                    // (3) Then
                    XCTAssertEqual(error as! NetworkError, .server("Server Error"))
                    expectation.fulfill()
                    
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }

    /// discoverMovies()
    func test_discover_movies_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Discover Movies")
        
        MockTMDBService.discoverMovies(
            includeAdult: false,
            language: "en",
            originalLanguage: "en",
            with: ["Action", "Adventure"],
            page: 1
        )
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { response in
                
                // (3) Then
                let movies = response.results
                XCTAssertNotNil(movies)
                XCTAssertEqual(movies!.count, 2)
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func test_discover_movies_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Discover Movies")

        MockFailTMDBService.discoverMovies(
            includeAdult: false,
            language: "en",
            originalLanguage: "en",
            with: ["Action", "Adventure"],
            page: 1
        )
            .sink { completion in
                switch completion {
                case .failure(let error):
                    
                    // (3) Then
                    XCTAssertEqual(error as! NetworkError, .server("Server Error"))
                    expectation.fulfill()
                    
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    /// searchMovie()
    func test_search_movie_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Search Movie")
        
        MockTMDBService.searchMovie(with: "Toy")
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { response in
                
                // (3) Then
                let movies = response.results
                XCTAssertNotNil(movies)
                XCTAssertEqual(movies!.count, 2)
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func test_search_movie_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Search Movie")

        MockFailTMDBService.searchMovie(with: "Toy")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    
                    // (3) Then
                    XCTAssertEqual(error as! NetworkError, .server("Server Error"))
                    expectation.fulfill()
                    
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    /// getUIImage()
    func test_get_ui_image_success() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get UI Image")
        
        MockTMDBService.getUIImage(of: "101", with: .original)
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { uiImage in
                
                // (3) Then
                XCTAssertGreaterThan(uiImage.size.width, 0)
                XCTAssertGreaterThan(uiImage.size.height, 0)
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func test_get_ui_image_fails() throws {
        // (1) Given
        
        // (2) When
        let expectation = expectation(description: "Get UI Image")

        MockFailTMDBService.getUIImage(of: "101", with: .original)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    
                    // (3) Then
                    XCTAssertEqual(error as! NetworkError, .server("Server Error"))
                    expectation.fulfill()
                    
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }

}

