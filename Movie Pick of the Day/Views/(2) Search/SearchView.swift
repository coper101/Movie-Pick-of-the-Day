//
//  SearchView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

struct SearchView: View {
    // MARK: - Props
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dimensions) var dimensions: Dimensions
    
    @State private var searchText: String = ""
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Layer 1 - Top Bar
            StatusBarBackgroundView()
                .zIndex(2)
            
            TopBarView(title: "Search")
                .zIndex(1)
                .padding(.top, dimensions.insets.top)
            
            // MARK: Layer 2 - Results
            ResultMoviesView(movies: appViewModel.searchedMovies)
                .padding(.bottom, 79 + dimensions.insets.bottom + 84)
                .zIndex(0)
                
            // MARK: Layer 3 - Search
            VStack {
                Spacer()
                SearchBarView(
                    text: $searchText,
                    placeholder: "Search Movie",
                    onCommit: commitAction
                )
                .padding(.horizontal, 24)
                .padding(.bottom, dimensions.insets.bottom + 84)
            }
            .zIndex(1)
            
        } //: ZStack
        .background(Colors.background.color)
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Actions
    func commitAction() {
        withAnimation {
            appViewModel.didTapSearchOnCommitMovie(searchText)
        }
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
            .environmentObject(ImageCacheRepository())
    }
}
