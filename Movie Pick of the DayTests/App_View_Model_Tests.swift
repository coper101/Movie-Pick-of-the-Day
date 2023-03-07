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
    func test_did_tap_pick_of_the_day_movie_screen() throws {
        // (1) Given
        let currentScreen = Screen.search

        // (2) When
        appViewModel.screen = currentScreen

        XCTAssertEqual(appViewModel.screen, .search)

        appViewModel.didTapPickOfTheDayMovieScreen()

        // (3) Then
        XCTAssertEqual(appViewModel.screen, .pickOfTheDay)
    }

    func test_load_movie_picks() throws {
        // (1) Given
        let newMoviePicks: [MovieDay] = [
            .init(day: .wednesday, id: 104, movie: TestData.createMovie(id: 104)),
            .init(day: .thursday, id: 105, movie: TestData.createMovie(id: 105)),
            .init(day: .friday, id: 106, movie: TestData.createMovie(id: 106)),
            .init(day: .saturday, id: 107, movie: TestData.createMovie(id: 107))
        ]

        // (2) When
        appDataRepository.setMoviePicksOfTheWeek(newMoviePicks)
        
        // app data: moviePicksPublishers > app view model: moviePicks
        appViewModel.republishAppData()

        // (3) Then
        let expectation = expectation(description: "Get Picks Movie")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let moviePicks = self.appViewModel.moviePicks

            XCTAssertEqual(moviePicks.count, 4)

            XCTAssertEqual(
                moviePicks[0],
                MovieDay(
                    day: .wednesday,
                    id: 104,
                    movie: TestData.createMovie(id: 104)
                )
            )
            XCTAssertEqual(
                moviePicks[1],
                MovieDay(
                    day: .thursday,
                    id: 105,
                    movie: TestData.createMovie(id: 105)
                )
            )
            XCTAssertEqual(
                moviePicks[2],
                MovieDay(
                    day: .friday,
                    id: 106,
                    movie: TestData.createMovie(id: 106)
                )
            )
            XCTAssertEqual(
                moviePicks[3],
                MovieDay(
                    day: .saturday,
                    id: 107,
                    movie: TestData.createMovie(id: 107)
                )
            )

            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }

    func test_select_movie_picks_of_the_week() throws {
        // (1) Given
        let preference = Preference(
            language: "EN",
            originalLanguage: "EN",
            includeAdult: false,
            genres: [
                .init(id: 1, name: "Action"),
                .init(id: 2, name: "Adventure")
            ]
        )

        // (2) When
        appDataRepository.setPreference(preference)
        
        // app data: preferencePublisher > app view model: selectMoviePickIDsOfTheWeek
        appViewModel.republishAppData()
        appDataRepository.setPreference(preference) // again as it drops the first one

        // (3) Then
        let preferredMovies = movieRepository.preferredMovies

        XCTAssertEqual(preferredMovies[0].id, 101)
        XCTAssertEqual(preferredMovies[1].id, 102)
        XCTAssertEqual(preferredMovies[2].id, 103)
        XCTAssertEqual(preferredMovies[3].id, 104)
        XCTAssertEqual(preferredMovies[4].id, 105)
        XCTAssertEqual(preferredMovies[5].id, 106)
        XCTAssertEqual(preferredMovies[6].id, 107)
    }

    func test_reselect_movie_pick_ids_of_the_week_first_time() throws {
        // (1) Given
        let preferredMovies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
        // Jan 22, Saturday (index: 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())

        // (2) When
        self.appViewModel.reSelectMoviePickIDsOfTheWeek(preferredMovies, todaysDate: todaysDate)

        // (3) Then - Random Movie ID Assigned to Days Without Movies
        //          - Sun to Sat Assigned (Entire Week)
        let moviePickIDs = self.appDataRepository.moviePicksOfTheWeek.sorted(by: <)

        XCTAssertEqual(moviePickIDs.count, 7)
        
        XCTAssertEqual(moviePickIDs[0].day, .sunday)
        XCTAssertGreaterThan(moviePickIDs[0].id, 100)

        XCTAssertEqual(moviePickIDs[1].day, .monday)
        XCTAssertGreaterThan(moviePickIDs[1].id, 100)

        XCTAssertEqual(moviePickIDs[2].day, .tuesday)
        XCTAssertGreaterThan(moviePickIDs[2].id, 100)

        XCTAssertEqual(moviePickIDs[3].day, .wednesday)
        XCTAssertGreaterThan(moviePickIDs[3].id, 100)

        XCTAssertEqual(moviePickIDs[4].day, .thursday)
        XCTAssertGreaterThan(moviePickIDs[4].id, 100)

        XCTAssertEqual(moviePickIDs[5].day, .friday)
        XCTAssertGreaterThan(moviePickIDs[5].id, 100)

        XCTAssertEqual(moviePickIDs[6].day, .saturday)
        XCTAssertGreaterThan(moviePickIDs[6].id, 100)
    }

    func test_reselect_movie_pick_ids_of_the_week_with_existing_selection() throws {
        // (1) Given
        let existingMoviePicks: [MovieDay] = [
            .init(day: .sunday, id: 100),
            .init(day: .monday, id: 101),
            .init(day: .tuesday, id: 102),
            .init(day: .wednesday, id: 103),
            .init(day: .thursday, id: 104),
            .init(day: .friday, id: 105),
            .init(day: .saturday, id: 106)
        ]
        let preferredMovies = [
            TestData.createMovie(id: 91),
            TestData.createMovie(id: 92),
            TestData.createMovie(id: 93),
            TestData.createMovie(id: 94),
            TestData.createMovie(id: 95),
            TestData.createMovie(id: 96),
            TestData.createMovie(id: 97)
        ]
        // Jan 22, Sunday (index: 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())

        // (2) When
        appViewModel.republishAppData()
        appDataRepository.setMoviePicksOfTheWeek(existingMoviePicks)
        
        let expectation = expectation(description: "Get Existing Movie Picks")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.appViewModel.reSelectMoviePickIDsOfTheWeek(preferredMovies, todaysDate: todaysDate)

            // (3) Then - Random Movie ID Assigned to Days Without Movies
            //          - Mon to Sat Assigned
            let moviePickIDs = self.appDataRepository.moviePicksOfTheWeek.sorted(by: <)
            
            XCTAssertEqual(moviePickIDs.count, 7)

            XCTAssertEqual(moviePickIDs[0].day, .sunday)
            XCTAssertEqual(moviePickIDs[0].id, 100)

            XCTAssertEqual(moviePickIDs[1].day, .monday)
            XCTAssertGreaterThanOrEqual(moviePickIDs[1].id, 90)

            XCTAssertEqual(moviePickIDs[2].day, .tuesday)
            XCTAssertGreaterThanOrEqual(moviePickIDs[2].id, 90)

            XCTAssertEqual(moviePickIDs[3].day, .wednesday)
            XCTAssertGreaterThanOrEqual(moviePickIDs[3].id, 90)

            XCTAssertEqual(moviePickIDs[4].day, .thursday)
            XCTAssertGreaterThanOrEqual(moviePickIDs[4].id, 90)

            XCTAssertEqual(moviePickIDs[5].day, .friday)
            XCTAssertGreaterThanOrEqual(moviePickIDs[5].id, 90)

            XCTAssertEqual(moviePickIDs[6].day, .saturday)
            XCTAssertGreaterThanOrEqual(moviePickIDs[6].id, 90)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }

    func test_reselect_movie_pick_ids_of_the_week_last_day_of_week() throws {
        // (1) Given
        let existingMoviePicks: [MovieDay] = [
            .init(day: .sunday, id: 100),
            .init(day: .monday, id: 99),
            .init(day: .tuesday, id: 98),
            .init(day: .wednesday, id: 97),
            .init(day: .thursday, id: 96),
            .init(day: .friday, id: 95),
            .init(day: .saturday, id: 94)
        ]
        let preferredMovies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
        // Jan 28, Saturday (index: 7)
        let todaysDate = try XCTUnwrap("2023-01-28".toDate())

        // (2) When
        appViewModel.republishAppData()
        appDataRepository.setMoviePicksOfTheWeek(existingMoviePicks)
                
        let expectation = expectation(description: "Get Existing Movie Picks")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.appViewModel.reSelectMoviePickIDsOfTheWeek(preferredMovies, todaysDate: todaysDate)

            // (3) Then - Random Movie ID Assigned to Days Without Movies
            //          - No Movies Assigned
            let moviePickIDs = self.appDataRepository.moviePicksOfTheWeek

            XCTAssertEqual(moviePickIDs.count, 7)

            XCTAssertEqual(moviePickIDs[0].day, .sunday)
            XCTAssertEqual(moviePickIDs[0].id, 100)

            XCTAssertEqual(moviePickIDs[1].day, .monday)
            XCTAssertEqual(moviePickIDs[1].id, 99)

            XCTAssertEqual(moviePickIDs[2].day, .tuesday)
            XCTAssertEqual(moviePickIDs[2].id, 98)

            XCTAssertEqual(moviePickIDs[3].day, .wednesday)
            XCTAssertEqual(moviePickIDs[3].id, 97)

            XCTAssertEqual(moviePickIDs[4].day, .thursday)
            XCTAssertEqual(moviePickIDs[4].id, 96)

            XCTAssertEqual(moviePickIDs[5].day, .friday)
            XCTAssertEqual(moviePickIDs[5].id, 95)

            XCTAssertEqual(moviePickIDs[6].day, .saturday)
            XCTAssertEqual(moviePickIDs[6].id, 94)
            
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 0.5)

    }

    func test_reselect_movie_pick_ids_of_the_week_insufficient_movies() throws {
        // (1) Given
        let existingMoviePicks: [MovieDay] = [
            .init(day: .sunday, id: 100)
        ]
        let preferredMovies = [
            TestData.createMovie(id: 101)
        ]
        // Jan 22, Sunday (index: 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())

        // (2) When
        appViewModel.republishAppData()
        appDataRepository.setMoviePicksOfTheWeek(existingMoviePicks)
                
        let expectation = expectation(description: "Get Existing Movie Picks")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.appViewModel.reSelectMoviePickIDsOfTheWeek(preferredMovies, todaysDate: todaysDate)

            // (3) Then - Movie ID Assigned
            //          - Sunday Only (Insufficient for other days: Mon - Sat)
            let moviePickIDs = self.appDataRepository.moviePicksOfTheWeek

            XCTAssertEqual(moviePickIDs.count, 1)

            XCTAssertEqual(moviePickIDs[0].day, .sunday)
            XCTAssertEqual(moviePickIDs[0].id, 100)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }

    // MARK: Preference Sheet
    func test_did_tap_preferences() throws {
        // (1) Given
        // (2) When
        appViewModel.republishMovieData()
        appViewModel.didTapPreferences()

        // (3) Then - Check Populated Languages and Genres
        let expectation = expectation(description: "Republish Genres and Languages")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let genres = self.appViewModel.genres
            let languages = self.appViewModel.languages

            XCTAssertFalse(genres.isEmpty)
            XCTAssertEqual(genres[0], .init(id: 1, name: "Action"))
            XCTAssertEqual(genres[1], .init(id: 2, name: "Adventure"))

            XCTAssertFalse(languages.isEmpty)
            XCTAssertEqual(languages[0], TestData.createLanguage(englishName: "English"))
            XCTAssertEqual(languages[1], TestData.createLanguage(englishName: "German"))

            XCTAssertNotNil(self.appViewModel.preferenceInput)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }

    func test_did_tap_save_preferences() throws {
        // (1) Given
        let newPreference = Preference(
            language: "EN",
            originalLanguage: "EN",
            includeAdult: false,
            genres: [
                .init(id: 1, name: "Action"),
                .init(id: 2, name: "Adventure")
            ]
        )

        // (2) When
        appViewModel.republishAppData()
        appViewModel.preferenceInput = newPreference
        
        let expectation = expectation(description: "Republish Updated Preference")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let updatedPreference = self.appViewModel.preferenceInput
            
            XCTAssertNotNil(updatedPreference)
            XCTAssertEqual(
                updatedPreference!,
                Preference(
                    language: "EN",
                    originalLanguage: "EN",
                    includeAdult: false,
                    genres: [
                        .init(id: 1, name: "Action"),
                        .init(id: 2, name: "Adventure")
                    ]
                )
            )
            self.appViewModel.didTapSavePreferences()

            // (3) Then - Check New Preference
            XCTAssertNil(self.appViewModel.preferenceInput)
            
            expectation.fulfill()
            
        }

        waitForExpectations(timeout: 0.5)
    }

    func test_did_tap_close_preferenes() throws {
        // (1) Given
        // (2) When
        appViewModel.republishMovieData()
        appViewModel.didTapPreferences()
        appViewModel.didTapClosePreferences()

        // (3) Then - Retain Languages and Genres (Quick Access Next Time)
        let expectation = expectation(description: "Republish Genres and Languages")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            XCTAssertFalse(self.appViewModel.genres.isEmpty)
            XCTAssertFalse(self.appViewModel.languages.isEmpty)
            XCTAssertNil(self.appViewModel.preferenceInput)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }

    // MARK: Search
    func test_did_tap_search_screen() throws {
        // (1) Given
        let currentScreen = Screen.pickOfTheDay

        // (2) When
        appViewModel.screen = currentScreen

        XCTAssertEqual(appViewModel.screen, .pickOfTheDay)

        appViewModel.didTapSearchScreen()

        // (3) Then
        XCTAssertEqual(appViewModel.screen, .search)
    }

    func test_did_tap_search_commit_movie() throws {
        // (1) Given
        // (2) When
        appViewModel.republishMovieData()
        XCTAssertTrue(appViewModel.searchedMovies.isEmpty)
        appViewModel.didTapSearchOnCommitMovie("Toy", onDone: { _ in })

        // (3) Then
        let expectation = expectation(description: "Republish Searched Movies")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let searchedMovies = self.appViewModel.searchedMovies

            XCTAssertFalse(searchedMovies.isEmpty)

            XCTAssertNotNil(searchedMovies[0].title)
            XCTAssertEqual(searchedMovies[0].title, "Toy Story 1")

            XCTAssertNotNil(searchedMovies[1].title)
            XCTAssertEqual(searchedMovies[1].title, "Toy Story 2")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }

    // MARK: Pick of the Day
    func test_did_tap_pick_of_the_day_detail_screen() throws {
        // (1) Given
        let existingMoviePicks: [MovieDay] = [
            .init(
                day: .sunday, id: 100,
                movie: TestData.createMovie(id: 99)
            ),
            .init(day: .monday, id: 101),
            .init(day: .tuesday, id: 102),
            .init(day: .wednesday, id: 103),
            .init(day: .thursday, id: 104),
            .init(day: .friday, id: 105),
            .init(day: .saturday, id: 106)
        ]
        // Jan 22, Sunday (index 1)
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())

        // (2) When
        XCTAssertEqual(appViewModel.screen, .pickOfTheDay)
        
        appViewModel.republishAppData()
        appViewModel.republishMovieData()
        appDataRepository.setMoviePicksOfTheWeek(existingMoviePicks)
        
        let expectation = expectation(description: "Republish Movie Picks & Similar Movies")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            // (3) Then - Navigate to Detail Screen, Load Similar Movies
            self.appViewModel.didTapPickOfTheDayDetailScreen(todaysDate: todaysDate)
            XCTAssertEqual(self.appViewModel.screen, .pickOfTheDayDetail)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                let similarMovies = self.appViewModel.similarMovies
                
                XCTAssertFalse(similarMovies.isEmpty)
                
                XCTAssertNotNil(similarMovies[0].title)
                XCTAssertEqual(similarMovies[0].title, "Toy Story 1")
                
                XCTAssertNotNil(similarMovies[1].title)
                XCTAssertEqual(similarMovies[1].title, "Toy Story 2")
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.5)
    }

    func test_did_tap_close_pick_of_the_day_detail_screen() throws {
        // (1) Given
        let todaysDate = try XCTUnwrap("2023-01-22".toDate())

        // (2) When
        appViewModel.didTapPickOfTheDayDetailScreen(todaysDate: todaysDate)
        XCTAssertEqual(appViewModel.screen, .pickOfTheDayDetail)

        appViewModel.didTapClosePickOfTheDayDetailScreen()
        XCTAssertEqual(appViewModel.screen, .pickOfTheDay)

        // (3) Then
        let expectation = expectation(description: "Republish Similar Movies")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let similarMovies = self.appViewModel.similarMovies
            let todaysMoviePick = self.appViewModel.todaysMoviePick

            XCTAssertTrue(similarMovies.isEmpty)
            XCTAssertNil(todaysMoviePick)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }
}
