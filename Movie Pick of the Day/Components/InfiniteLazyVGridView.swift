//
//  InfiniteLazyVGridView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 19/3/23.
//

import SwiftUI

typealias NestedAction = (@escaping () -> Void) -> Void

struct InfiniteLazyVGridView: View {
    // MARK: - Props
    @Environment(\.dimensions) var dimensions
    @State private var hasLastItemAppeared: Bool = false
    var movies: [Movie]
    var lastMovie: Movie? {
        movies.last
    }
    var loadMoreMoviesAction: NestedAction
    
    // MARK: - UI
    var body: some View {
        ScrollView(showsIndicators: false) {
                        
            // MARK: Items
            LazyVGrid(
                columns: Array(
                    repeating: .init(.flexible()),
                    count: 2
                ),
                spacing: 30
            ) {
                
                ForEach(movies) { movie in
                    
                    MovieCardView(
                        movieTitle: movie.title,
                        uiImage: nil,
                        posterPath: movie.posterPath,
                        posterResolution: .w500
                    )
                    .transition(.opacity)
                    .onAppear {
                        if let lastMovie = movies.last, movie.id == lastMovie.id {
                            hasLastItemAppeared = true
                            loadMoreItems()
                        }
                    }
                    
                } //: ForEach
                
            } //: LazyVGrid
            .padding(.top, 74 + dimensions.insets.top)
            .fillMaxSize(alignment: .top)
            .padding(.horizontal, 24)
            .padding(.bottom, 90)
            
            // MARK: Loading Indicator
            if hasLastItemAppeared {
                ProgressView()
                    .progressViewStyle(.circular)
                    .zIndex(1)
                    .padding(.top, 12)
            }
            
        }
    }
    
    // MARK: - Actions
    func loadMoreItems() {
        loadMoreMoviesAction {
            hasLastItemAppeared = false
        }
    }
}

// MARK: - Preview
struct InfiniteLazyVGridView_Previews: PreviewProvider {
    static var movies: [Movie] = TestData.sampleMovies
    
    static var previews: some View {
        InfiniteLazyVGridView(
            movies: movies,
            loadMoreMoviesAction: { onLoaded in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    movies.append(TestData.createMovie(id: 202, title: "Hello"))
                    movies.append(contentsOf: [
                        TestData.createMovie(id: 204),
                        TestData.createMovie(id: 205),
                        TestData.createMovie(id: 206),
                        TestData.createMovie(id: 207),
                        TestData.createMovie(id: 208),
                        TestData.createMovie(id: 209),
                        TestData.createMovie(id: 210)
                    ])
                    onLoaded()
                }
            }
        )
        .previewLayout(.sizeThatFits)
        .environmentObject(ImageCacheRepository())
        .background(Colors.background.color)
    }
}
