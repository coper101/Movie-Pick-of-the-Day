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
    
    // MARK: - UI
    var body: some View {
        ScrollView(showsIndicators: false) {
                
            LazyVGrid(
                columns: Array(
                    repeating: .init(.flexible()),
                    count: 2
                ),
                spacing: 30
            ) {
                
                ForEach(movies) { movie in

                    Button(action: {}) {
                        
                        MovieCardView(
                            movieTitle: movie.title,
                            uiImage: nil,
                            posterPath: movie.posterPath,
                            posterResolution: .w500
                        )
                        .transition(.opacity)
                        
                    } //: Button

                } //: ForEach
                
            } //: LazyVGrid
            .padding(.top, 74 + dimensions.insets.top)
            .fillMaxSize(alignment: .top)
            .padding(.horizontal, 24)
            .padding(.bottom, 45)
            
        } //: ScrollView
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
        ResultMoviesView(movies: TestData.sampleMovies)
            .frame(height: 750)
            .previewLayout(.sizeThatFits)
            .environmentObject(ImageCacheRepository())
            .background(Colors.background.color)
    }
}
