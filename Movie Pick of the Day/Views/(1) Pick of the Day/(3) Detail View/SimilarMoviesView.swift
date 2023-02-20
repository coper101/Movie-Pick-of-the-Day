//
//  SimilarMoviesView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

struct SimilarMoviesView: View {
    // MARK: - Props
    var movies: [Movie]
    var paddingHorizontal: CGFloat = 24
    
    // MARK: - UI
    var movieList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(alignment: .top, spacing: 28) {
                
                ForEach(movies) { movie in
                                            
                    MovieCardView(
                        movieDay: nil,
                        movieTitle: movie.title ?? "",
                        uiImage: nil,
                        posterPath: movie.posterPath,
                        posterResolution: .w500
                    )
                    
                } //: ForEach
                
            } //: LazyHGrid
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, paddingHorizontal)
            .padding(.bottom, 50)
            
        } //: ScrollView
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            
            // TITLE
            Text("Similar Movies")
                .kerning(1)
                .textStyle(
                    font: .interExtraBold,
                    size: 20
                )
                .padding(.horizontal, paddingHorizontal)
                .padding(.top, 28)
            
            // MOVIES
            if !movies.isEmpty {
                movieList
            } else {
                Text("No Similar Movies")
                    .textStyle(foregroundColor: .onBackground, size: 18)
                    .opacity(0.15)
                    .padding(.horizontal, paddingHorizontal)
                    .fillMaxWidth(alignment: .leading)
            }
            
            Spacer()
                           
        }  //: VStack
        .background(Colors.backgroundLight.color)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct SimilarMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        SimilarMoviesView(movies: TestData.sampleMovies)
            .frame(height: 310)
            .previewLayout(.sizeThatFits)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("Available")
        
        SimilarMoviesView(movies: [])
            .frame(height: 310)
            .previewLayout(.sizeThatFits)
            .environmentObject(ImageCacheRepository())
            .previewDisplayName("NA")
    }
}
