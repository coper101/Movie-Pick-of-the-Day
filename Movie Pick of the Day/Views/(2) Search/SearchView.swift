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
            TopBarView(title: "Search")
                .padding(.top, dimensions.insets.top)
            
            // MARK: Layer 2 - Search
            VStack(spacing: 0) {
                
                // RESULTS
                ScrollView {
                        
                    LazyVGrid(
                        columns: [.init(.flexible()), .init(.flexible())],
                        spacing: 30
                    ) {
                        
                        ForEach(appViewModel.searchedMovies) { movie in

                            MovieCardView(
                                movieTitle: movie.title,
                                uiImage: UIImage(named: Icons.samplePoster.rawValue)!
                            )

                        } //: ForEach
                        
                    } //: LazyVGrid
                    .padding(.top, 74 + dimensions.insets.top)
                    .fillMaxSize(alignment: .top)
                    .padding(.horizontal, 24)
                    
                } //: ScrollView
                
                // SEARCH
                SearchBarView(
                    text: $searchText,
                    placeholder: "Search Movie",
                    onCommit: commitAction
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 84)
                
            } //: ScrollView
            
        } //: ZStack
        .background(Colors.background.color)
    }
    
    // MARK: - Actions
    func commitAction() {
        appViewModel.didTapSearchOnCommitMovie(searchText)
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
    }
}
