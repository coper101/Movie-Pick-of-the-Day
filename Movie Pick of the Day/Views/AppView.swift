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
                .statusBarHidden(false)
                .zIndex(0)
                
            }
            
            // MARK: Layer 2 - Detail
            if
                let todaysPick = appViewModel.todaysMoviePick,
                let movie = todaysPick.movie
            {
                
                PickRevealView(movie: movie)
                    .statusBarHidden(true)
                    .zIndex(1)
                
            }
            
            // MARK: Layer 3: Alert
            if appViewModel.isAlertShown {
                Color.black.opacity(0.75)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    .zIndex(2)

                AlertView(
                    title: "NOTE",
                    message: "Some days will not appear due to insufficient movies available",
                    action: closeAlertAction
                )
                .padding(.horizontal, 24)
                .zIndex(2)
                .transition(.opacity.animation(.easeOut(duration: 0.2)))
            }
            
        } //: ZStack
        .ignoresSafeArea(.container, edges: .all)
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
    
    func closeAlertAction() {
        withAnimation {
            appViewModel.closeAlert()
        }
    }
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    
    static var alertModel: AppViewModel {
        let appViewModel = TestData.appViewModel
        appViewModel.isAlertShown = true
        return appViewModel
    }
    
    static var previews: some View {
        AppView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("Movie Picks Available")
        
        AppView()
            .previewLayout(.sizeThatFits)
            .environmentObject(alertModel)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("No Movie Picks Available")
        
    }
}
