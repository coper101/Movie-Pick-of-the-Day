//
//  PickOfTheDayView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import SwiftUI

struct PickOfTheDayView: View {
    // MARK: - Props
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dimensions) var dimensions: Dimensions
    @Environment(\.openURL) var openURL
        
    let movie = TestData.sampleMovie
    
    var todaysMovieDay: MovieDay? {
        guard
            let todaysWeekDay = Date().toDateComp().weekday
        else {
            return nil
        }
        let movieDay = appViewModel.moviePicks.first(
            where: { $0.day.rawValue == todaysWeekDay }
        )
        return movieDay
    }

    var nextMovieDays: [MovieDay] {
        guard
            let todaysWeekDay = Date().toDateComp().weekday
        else {
            return []
        }
        guard
            let todaysMovieDayIndex = appViewModel.moviePicks.firstIndex(
                where: { $0.day.rawValue == todaysWeekDay }
            )
        else {
            return []
        }
        return Array(appViewModel.moviePicks[(todaysMovieDayIndex + 1)...])
    }
    
    var preferenceSummary: String {
        guard let preference = appViewModel.preference else {
            return ""
        }
        return preference.summary
    }
    
    // MARK: - UI
    var content: some View {
        ZStack(alignment: .top) {
            
            // MARK: Layer 1 - Top Bar
            StatusBarBackgroundView()
                .zIndex(2)

            TopBarView(title: "Movie Pick of the Day")
                .zIndex(1)
                .padding(.top, dimensions.insets.top)
            
            // MARK: Layer 2 - Content
            ScrollView {
                
                VStack(spacing: 30) {
                    
                    // Row 1: PREFERENCES + CREDIT SOURCE
                    HStack(spacing: 12) {
                    
                        RoundButtonView(
                            title: preferenceSummary,
                            subtitle: "Preferences",
                            action: openPreferenceAction
                        )
                        
                        RoundButtonView(
                            subtitle: "powered by",
                            icon: .tmdbLogo,
                            fillSpace: false,
                            action: sourceAction
                        )
                        
                    } //: HStack
                    .padding(.horizontal, 21)
                    
                    // Row 2: PICK OF THE DAY
                    Button(action: pickOfTheDayAction) {

                        if
                            let todaysMovieDay,
                            let todaysMovie = todaysMovieDay.movie
                        {

                            PickCardView(
                                title: todaysMovie.title ?? "",
                                description: todaysMovie.overview ?? "",
                                uiImage: nil,
                                posterPath: todaysMovie.posterPath,
                                posterResolution: .original
                            )
                            .cardShadow()

                        } else {

                            EmptyView()

                        } //: if-else

                    } //: Button
                    .padding(.horizontal, 21)
                    
                    // Row 3: PICKS
                    ScrollView(.horizontal, showsIndicators: false) {

                        LazyHGrid(
                            rows: [.init(.flexible())],
                            spacing: 22
                        ) {

                            ForEach(nextMovieDays) { movieDay in
                                
                                let movie = movieDay.movie
                                
                                Button(action: {}) {

                                    MovieCardView(
                                        movieDay: movieDay,
                                        uiImage: nil,
                                        posterPath: movie?.posterPath,
                                        posterResolution: .w500
                                    )

                                } //: Button

                            } //: ForEach

                        } //: LazyHGrid
                        .frame(height: 164)
                        .padding(.horizontal, 21)
                        .padding(.bottom, 50)

                    } //: ScrollView
                    
                } //: VStack
                .padding(.top, 74 + dimensions.insets.top)
                .fillMaxSize(alignment: .top)
                
            } //: ScrollView
            .zIndex(0)
            
        } //: ZStack
        .background(Colors.background.color)
        .edgesIgnoringSafeArea(.top)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // MARK: Layer 1 - Movie Picks
            content
                .zIndex(0)
            
            // MARK: Layer 2 - Preference Sheet
            if appViewModel.isPreferencesSheetShown {
                
                Group {

                    // BACKDROP
                    Color.black.opacity(0.5)
                        .transition(.opacity)
                        .animation(
                            .easeOut(duration: 0.5),
                            value: appViewModel.isPreferencesSheetShown
                        )
                        .zIndex(1)

                    // SHEET
                    PreferencesSheetView(
                        genresSelection: $appViewModel.genresSelection,
                        languageSelected: $appViewModel.languageSelected,
                        isAdultSelected: $appViewModel.isAdultSelected,
                        genresOptions: appViewModel.genres.compactMap(\.name),
                        languagesOptions: appViewModel.languages.compactMap(\.englishName),
                        closeAction: closePreferenceAction,
                        doneAction: donePreferenceAction
                    )
                    .transition(.move(edge: .bottom))
                    .animation(
                        .easeOut(duration: 0.5),
                        value: appViewModel.isPreferencesSheetShown
                    )
                    .zIndex(2)
                    
                } //: Group
                
            } //: if
        } //: ZStack
    }
    
    // MARK: - Actions
    func pickOfTheDayAction() {
        withAnimation {
            appViewModel.didTapPickOfTheDayDetailScreen()
        }
    }
    
    func openPreferenceAction() {
        withAnimation {
            appViewModel.didTapPreferences()
        }
    }
    
    func closePreferenceAction() {
        withAnimation {
            appViewModel.didTapClosePreferences()
        }
    }
    
    func donePreferenceAction() {
        withAnimation {
            appViewModel.didTapSavePreferences()
        }
    }
    
    func sourceAction() {
        let tmdbURL = URL(string: "https://www.themoviedb.org")!
        openURL(tmdbURL)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PickOfTheDayView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
            .environmentObject(ImageCacheRepository())
    }
}
