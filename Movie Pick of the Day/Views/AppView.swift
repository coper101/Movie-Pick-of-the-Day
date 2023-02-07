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
        Group {
            if
                (selectedScreen == .pickOfTheDay) ||
                (selectedScreen == .search)
            {
                
                PagerView(
                    item1Action: appViewModel.didTapPickOfTheDayMovieScreen,
                    item2Action: appViewModel.didTapSearchScreen,
                    bottomPadding: dimensions.insets.bottom,
                    item1Content: { PickOfTheDayView() },
                    item2Content: { SearchView() }
                )
                
            } else {
                
                PickRevealView()
                
            } //: if-else
        } //: Group
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
    }
}
