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
            
    var preferenceSummary: String {
        guard let preference = appViewModel.preference else {
            return ""
        }
        return preference.summary
    }
    
    let paddingVertical: CGFloat = 30
    let topBarHeight: CGFloat = 54
    
    // MARK: - UI
    var preferenceAndSource: some View {
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
    }
    
    var pickOfTheDay: some View {
        Button(action: pickOfTheDayAction) {

            if
                let todaysMovieDay = appViewModel.todaysMovieDay,
                let todaysMovie = todaysMovieDay.movie
            {

                PickCardView(
                    title: todaysMovie.title ?? "",
                    description: todaysMovie.overview ?? "",
                    uiImage: nil,
                    posterPath: todaysMovie.posterPath,
                    posterResolution: .original
                )

            } else {

                EmptyView()

            } //: if-else

        } //: Button
    }
    
    var content: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Layer 1: Status Bar Background
            StatusBarBackgroundView()
                .zIndex(2)

            // MARK: - Layer 2: Top Bar
            TopBarView(title: "Movie Pick of the Day")
                .zIndex(1)
                .padding(.top, dimensions.insets.top)
            
            // MARK: - Layer 3: Content
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 0) {
                    
                    // PREFERENCE + SOURCE
                    preferenceAndSource
                        .padding(.horizontal, 21)
                        .padding(.top, 16)
                    
                    // PICK OF THE DAY
                    pickOfTheDay
                        .padding(.horizontal, 21)
                        .padding(.top, paddingVertical)
                    
                    // PICKS FOR THE REST OF THE WEEK
                    MoviePicksView(movies: appViewModel.nextMovieDays)
                        .padding(.top, paddingVertical - 12)
                        .padding(.bottom, 63 + 28)
                    
                } //: VStack
                .padding(.top, topBarHeight + dimensions.insets.top)
                .fillMaxSize(alignment: .top)
                
            } //: ScrollView
            .zIndex(0)
            
        } //: ZStack
        .background(Colors.background.color)
        .edgesIgnoringSafeArea(.top)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // MARK: - Layer 1: Pick of The Day Screen
            content
                .zIndex(0)
            
            // MARK: - Layer 2: Preference Sheet
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
                        isLoadingGenres: appViewModel.isLoadingGenres,
                        isLoadingLanguages: appViewModel.isLoadingLanguages,
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
