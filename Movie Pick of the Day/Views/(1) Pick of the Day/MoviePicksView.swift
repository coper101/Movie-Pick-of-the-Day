//
//  MoviePicksView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

struct MoviePicksView: View {
    // MARK: - Props
    var movies: [MovieDay]
    
    // MARK: - UI
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHGrid(
                rows: [.init(.flexible())],
                spacing: 22
            ) {
                
                ForEach(movies) { movieDay in
                    
                    let movie = movieDay.movie
                        
                    MovieCardView(
                        movieDay: movieDay,
                        uiImage: nil,
                        posterPath: movie?.posterPath,
                        posterResolution: .w500,
                        showLoading: false
                    )
                    
                } //: ForEach
                
            } //: LazyHGrid
            .padding(.vertical, 12)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 21)
            
        } //: ScrollView
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct MoviePicksView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePicksView(movies: TestData.sampleMoviePicks)
            .environmentObject(ImageCacheRepository())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
