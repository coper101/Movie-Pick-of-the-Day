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
    /// User Event - didTapPickOfTheDayMovieScreen()
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
    
    /// Event - loadMoviePicks()
    func test_load_movie_picks() throws {
        // (1) Given
        let newMoviePicks: [MovieDay] = [
            .init(day: .wednesday, id: 104),
            .init(day: .thursday, id: 105),
            .init(day: .friday, id: 106),
            .init(day: .saturday, id: 107)
        ]
        
        // (2) When
        appDataRepository.setMoviePicksIDsOfTheWeek(newMoviePicks)
        appViewModel.republishAppData()
        
        // (3) Then
        let expectation = expectation(description: "Get Movie Description")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let moviePicks = self.appViewModel.moviePicks
            
            XCTAssertEqual(moviePicks.count, 4)

            XCTAssertEqual(moviePicks[0].day, .wednesday)
            XCTAssertEqual(moviePicks[0].id, 104)
            XCTAssertNotNil(moviePicks[0].movie)
            XCTAssertNotNil(moviePicks[0].movie!.id)
            XCTAssertEqual(moviePicks[0].movie!.id!, 104)

            XCTAssertEqual(moviePicks[1].day, .thursday)
            XCTAssertEqual(moviePicks[1].id, 105)
            XCTAssertNotNil(moviePicks[1].movie)
            XCTAssertNotNil(moviePicks[1].movie!.id)
            XCTAssertEqual(moviePicks[1].movie!.id!, 105)

            XCTAssertEqual(moviePicks[2].day, .friday)
            XCTAssertEqual(moviePicks[2].id, 106)
            XCTAssertNotNil(moviePicks[2].movie)
            XCTAssertNotNil(moviePicks[2].movie!.id)
            XCTAssertEqual(moviePicks[2].movie!.id!, 106)

            XCTAssertEqual(moviePicks[3].day, .saturday)
            XCTAssertEqual(moviePicks[3].id, 107)
            XCTAssertNotNil(moviePicks[3].movie)
            XCTAssertNotNil(moviePicks[3].movie!.id)
            XCTAssertEqual(moviePicks[3].movie!.id!, 107)
            
            expectation.fulfill()
        }
    
        waitForExpectations(timeout: 0.5)
    }
    
    /// Event - selectMoviePickIDsOfTheWeek()
    func test_select_movie_pick_ids_of_the_week() throws {
        // (1) Given
        let preference = Preference(
            language: "EN",
            includeAdult: false,
            genres: ["Action", "Adventure"]
        )
        
        // (2) When
        appDataRepository.setPreference(preference)
        appViewModel.republishAppData()
        appDataRepository.setPreference(preference) /// again as it drops the first one
                
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
    
    /// Event - reSelectMoviePickIDsOfTheWeek()
    func test_reselect_movie_pick_ids_of_the_week_first_time() throws {
        // (1) Given
        let existingMoviePicks: [MovieDay] = [
            .init(day: .sunday, id: 100)
        ]
        let movies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
        
        // (2) When
        // Jan 22, Saturday (index: 1)
        appDataRepository.setMoviePicksIDsOfTheWeek(existingMoviePicks)
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
        
        // (3) Then
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek
        
        XCTAssertEqual(moviePickIDs.count, 7)

        XCTAssertEqual(moviePickIDs[0].day, .sunday)
        XCTAssertEqual(moviePickIDs[0].id, 100)
        
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
        let movies = [
            TestData.createMovie(id: 91),
            TestData.createMovie(id: 92),
            TestData.createMovie(id: 93),
            TestData.createMovie(id: 94),
            TestData.createMovie(id: 95),
            TestData.createMovie(id: 96),
            TestData.createMovie(id: 97)
        ]
        
        // (2) When
        // Jan 22, Sunday (index: 1)
        appDataRepository.setMoviePicksIDsOfTheWeek(existingMoviePicks)
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
        
        // (3) Then
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek

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
        let movies = [
            TestData.createMovie(id: 101),
            TestData.createMovie(id: 102),
            TestData.createMovie(id: 103),
            TestData.createMovie(id: 104),
            TestData.createMovie(id: 105),
            TestData.createMovie(id: 106),
            TestData.createMovie(id: 107)
        ]
        
        // (2) When
        // Jan 28, Saturday (index: 7)
        appDataRepository.setMoviePicksIDsOfTheWeek(existingMoviePicks)
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-28T00:00:00+00:00".toDate()
        )
        
        // (3) Then
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek

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
    }
    
    func test_reselect_movie_pick_ids_of_the_week_insufficient_movies() throws {
        // (1) Given
        let existingMoviePicks: [MovieDay] = [
            .init(day: .sunday, id: 100)
        ]
        let movies = [
            TestData.createMovie(id: 101)
        ]
        
        // (2) When
        // Jan 22, Sunday (index: 1)
        appDataRepository.setMoviePicksIDsOfTheWeek(existingMoviePicks)
        appViewModel.reSelectMoviePickIDsOfTheWeek(
            movies,
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
         
        // (3) Then
        let moviePickIDs = appDataRepository.moviePickIDsOfTheWeek

        XCTAssertEqual(moviePickIDs.count, 1)
        
        XCTAssertEqual(moviePickIDs[0].day, .sunday)
        XCTAssertEqual(moviePickIDs[0].id, 100)
    }
    
    /// User Event - didTapPreferences()
    func test_did_tap_preferenes() throws {
        // (1) Given
        /**
            preferenceInput = .init(
                language: "EN",
                includeAdult: false,
                genres: []
            )
            let newGenres = [
                .init(id: 1, name: "Action"),
                .init(id: 2, name: "Adventure")
            ]
            languages = [
                .init(
                    iso6391: "en",
                    englishName: "English",
                    name: ""
                 )
                 .init(
                     iso6391: "de",
                     englishName: "German",
                     name: "Deutsch"
                 )
             ]
         */
        
        // (2) When
        appViewModel.republishMovieData()
        appViewModel.didTapPreferences()
                
        // (3) Then
        let expectation = expectation(description: "Republish Genres and Languages")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let genres = self.appViewModel.genres
            let languages = self.appViewModel.languages

            XCTAssertFalse(genres.isEmpty)
            
            XCTAssertEqual(genres[0].id, 1)
            XCTAssertNotNil(genres[0].name)
            XCTAssertEqual(genres[0].name!, "Action")

            XCTAssertEqual(genres[1].id, 2)
            XCTAssertNotNil(genres[1].name)
            XCTAssertEqual(genres[1].name!, "Adventure")

            XCTAssertFalse(languages.isEmpty)

            XCTAssertNotNil(languages[0].iso6391)
            XCTAssertEqual(languages[0].iso6391!, "en")
            XCTAssertNotNil(languages[0].englishName)
            XCTAssertEqual(languages[0].englishName!, "English")

            XCTAssertNotNil(languages[1].iso6391)
            XCTAssertEqual(languages[1].iso6391!, "de")
            XCTAssertNotNil(languages[1].englishName)
            XCTAssertEqual(languages[1].englishName!, "German")
            
            XCTAssertNotNil(self.appViewModel.preferenceInput)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.2)
    }

    
    /// User Event - didTapSave()
    func test_did_tap_save_preferences() throws {
        // (1) Given
        let newPreference = Preference(
            language: "EN",
            includeAdult: false,
            genres: ["Action", "Adventure"]
        )
        
        // (2) When
        appViewModel.republishAppData()
        appViewModel.preferenceInput = newPreference
        
        XCTAssertNotNil(appViewModel.preferenceInput)
        XCTAssertEqual(appViewModel.preferenceInput!.language, "EN")
        XCTAssertEqual(appViewModel.preferenceInput!.includeAdult, false)
        XCTAssertEqual(appViewModel.preferenceInput!.genres, ["Action", "Adventure"])
        
        appViewModel.didTapSavePreferences()
                
        // (3) Then
        XCTAssertNil(appViewModel.preferenceInput)
    }
    
    /// User Event - didTapClosePreferences()
    func test_did_tap_close_preferenes() throws {
        // (1) Given
        /**
            preferenceInput = .init(
                language: "EN",
                includeAdult: false,
                genres: []
            )
            let newGenres = [
                .init(id: 1, name: "Action"),
                .init(id: 2, name: "Adventure")
            ]
            languages = [
                .init(
                    iso6391: "en",
                    englishName: "English",
                    name: ""
                 )
                 .init(
                     iso6391: "de",
                     englishName: "German",
                     name: "Deutsch"
                 )
             ]
         */
        
        // (2) When
        appViewModel.republishMovieData()
        appViewModel.didTapPreferences()
        appViewModel.didTapClosePreferences()
                
        // (3) Then
        let expectation = expectation(description: "Republish Genres and Languages")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            XCTAssertTrue(self.appViewModel.genres.isEmpty)
            XCTAssertTrue(self.appViewModel.languages.isEmpty)
            XCTAssertNil(self.appViewModel.preferenceInput)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: Search
    /// User Event - didTapSearchScreen()
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
    
    /// User Event - didTapSearchOnCommitMovie()
    func test_did_tap_search_commit_movie() throws {
        // (1) Given
        /**
             searchedMovies = [
                 TestData.createMovie(id: 101, title: "Toy Story 1"),
                 TestData.createMovie(id: 102, title: "Toy Story 2")
             ]
         */
        
        // (2) When
        XCTAssertTrue(appViewModel.searchedMovies.isEmpty)
        
        appViewModel.didTapSearchOnCommitMovie("Toy")
        
        // (3) Then
        let expectation = expectation(description: "Republish Searched Movies")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let searchedMovies = self.appViewModel.searchedMovies
            
            XCTAssertFalse(searchedMovies.isEmpty)
            
            XCTAssertNotNil(searchedMovies[0].title)
            XCTAssertEqual(searchedMovies[0].title, "Toy Story 1")
            
            XCTAssertNotNil(searchedMovies[1].title)
            XCTAssertEqual(searchedMovies[1].title, "Toy Story 2")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.2)
    }
    
    // MARK: Pick of the Day Detail
    /// User Event - didPickOfTheDayDetailScreen()
    func test_did_tap_pick_of_the_day_detail_screen() throws {
        // (1) Given
        let currentScreen = Screen.pickOfTheDay
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
    
        // (2) When
        appViewModel.moviePicks = existingMoviePicks
        
        XCTAssertEqual(appViewModel.moviePicks.count, 7)
        XCTAssertEqual(appViewModel.screen, .pickOfTheDay)
        
        appViewModel.didTapPickOfTheDayDetailScreen(
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
        
        XCTAssertEqual(appViewModel.screen, .pickOfTheDayDetail)
                
        // (3) Then
        let expectation = expectation(description: "Republish Similar Movies")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let similarMovies = self.appViewModel.similarMovies
            let todaysMoviePick = self.appViewModel.todaysMoviePick
            
            XCTAssertFalse(similarMovies.isEmpty)
            
            XCTAssertNotNil(similarMovies[0].title)
            XCTAssertEqual(similarMovies[0].title, "Toy Story 1")
            
            XCTAssertNotNil(similarMovies[1].title)
            XCTAssertEqual(similarMovies[1].title, "Toy Story 2")
            
            XCTAssertNotNil(todaysMoviePick)
            XCTAssertNotNil(todaysMoviePick!.day)
            XCTAssertEqual(todaysMoviePick!.day, .sunday)
            
            XCTAssertNotNil(todaysMoviePick!.id)
            XCTAssertEqual(todaysMoviePick!.id, 100)
            
            XCTAssertNotNil(todaysMoviePick!.movie)
            XCTAssertNotNil(todaysMoviePick!.movie!.id)
            XCTAssertEqual(todaysMoviePick!.movie!.id, 99)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.2)
    }
    
    /// User Event - didTapClosePickOfTheDayDetailScreen()
    func test_did_tap_close_pick_of_the_day_detail_screen() throws {
        // (1) Given
        let currentScreen = Screen.pickOfTheDayDetail
    
        // (2) When
        appViewModel.didTapPickOfTheDayDetailScreen(
            todaysDate: "2023-01-22T00:00:00+00:00".toDate()
        )
        
        XCTAssertEqual(appViewModel.screen, .pickOfTheDayDetail)

        appViewModel.didTapClosePickOfTheDayDetailScreen()
        
        XCTAssertEqual(appViewModel.screen, .pickOfTheDay)
                
        // (3) Then
        let expectation = expectation(description: "Republish Similar Movies")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let similarMovies = self.appViewModel.similarMovies
            let todaysMoviePick = self.appViewModel.todaysMoviePick
            
            XCTAssertTrue(similarMovies.isEmpty)
            XCTAssertNil(todaysMoviePick)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.2)
    }
}
