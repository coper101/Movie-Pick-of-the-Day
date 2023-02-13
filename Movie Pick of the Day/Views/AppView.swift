//
//  AppView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import SwiftUI

enum Screen {
    case pickOfTheDay
    case search
    case pickOfTheDayDetail
}

struct AppView: View {
    // MARK: - Props
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dimensions) var dimensions: Dimensions
    
    var selectedScreen: Screen {
        appViewModel.screen
    }
    
    // MARK: - UI
    var body: some View {
        ZStack {
            
            // MARK: Layer 1 - Picks or Search
            if
                (selectedScreen == .pickOfTheDay) ||
                (selectedScreen == .search)
            {
                
                PagerView(
                    item1Action: toPickOfTheDayAction,
                    item2Action: toSearchAction,
                    bottomPadding: dimensions.insets.bottom,
                    isSelectionShown: !appViewModel.isPreferencesSheetShown,
                    item1Content: {
                        PickOfTheDayView()
                            .transition(.opacity.animation(.easeIn(duration: 0.3)))
                    },
                    item2Content: {
                        SearchView()
                            .transition(.opacity.animation(.easeIn(duration: 0.3)))
                    }
                )
                .background(Colors.background.color)
                
            }
            
            // MARK: Layer 2 - Detail
            if
                let todaysPick = appViewModel.todaysMoviePick,
                let movie = todaysPick.movie
            {
                
                PickRevealView(movie: movie)
                
            }
            
        } //: Group
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Actions
    func toPickOfTheDayAction() {
        withAnimation {
            appViewModel.didTapPickOfTheDayMovieScreen()
        }
    }
    
    func toSearchAction() {
        withAnimation {
            appViewModel.didTapSearchScreen()
        }
    }
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
            .environmentObject(ImageCacheRepository())
    }
}
