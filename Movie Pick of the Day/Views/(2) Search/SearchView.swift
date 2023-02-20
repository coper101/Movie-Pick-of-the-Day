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
    
    let searchBarHeight: CGFloat = 79
    
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
                .padding(.bottom, dimensions.insets.bottom + searchBarHeight + 63 + 28)
                .zIndex(0)
                
            // MARK: Layer 3 - Search
            VStack(spacing: 0) {
                
                Spacer()
                
                SearchBarView(
                    text: $searchText,
                    placeholder: "Search Movie",
                    onCommit: commitAction
                )
                .padding(.horizontal, 24)
                .padding(.bottom, dimensions.insets.bottom + searchBarHeight + 13)
                
            } //: VStack
            .zIndex(1)
            
        } //: ZStack
        .background(Colors.background.color)
        .ignoresSafeArea(.container, edges: .top)
        .onChange(of: searchText) { newValue in
            print("text: ", newValue)
        }
    }
    
    // MARK: - Actions
    func commitAction() {
        withAnimation {
            appViewModel.didTapSearchOnCommitMovie(searchText) { hasError in
                if hasError {
                    self.searchText.removeAll()
                }
            }
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
