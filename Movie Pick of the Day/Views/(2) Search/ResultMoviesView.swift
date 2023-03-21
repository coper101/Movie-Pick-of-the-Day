//
//  ResultMoviesView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

struct ResultMoviesView: View {
    // MARK: - Props
    @Environment(\.dimensions) var dimensions
    var movies: [Movie]
    var loadMoreMoviesActions: NestedAction
    
    // MARK: - UI
    var body: some View {
        InfiniteLazyVGridView(
            movies: movies,
            loadMoreMoviesAction: loadMoreMoviesActions
        )
        .dynamicOverlay(alignment: .bottom) {
            DisappearingGradientView(
                contentDirection: .bottom,
                color: .background
            )
            .frame(height: 45)
        }
    }
    
    // MARK: - Actions
    
}

// MARK: - Preview
struct ResultMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        ResultMoviesView(
            movies: TestData.sampleMovies,
            loadMoreMoviesActions: { _ in }
        )
        .frame(height: 750)
        .previewLayout(.sizeThatFits)
        .environmentObject(ImageCacheRepository())
        .background(Colors.background.color)
    }
}
