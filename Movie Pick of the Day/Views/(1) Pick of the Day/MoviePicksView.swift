//
//  MoviePicksView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

struct MoviePicksView: View {
    // MARK: - Props
    @Environment(\.dimensions) var dimensions: Dimensions

    var todaysMovieDay: MovieDay?
    var movies: [MovieDay]
    var preference: Preference?
    var pickOfTheDayAction: Action
    
    let paddingVertical: CGFloat = 30
    
    var noPicksAvailable: Bool {
        todaysMovieDay?.movie == nil && movies.isEmpty
    }
    
    var noPicksMessage: String {
        (preference == nil) ?
            "Select a Preference\nAbove to Generate Movie Picks" :
            "No Movies Available\nSelect a Preference Again"
    }
    
    // MARK: - UI
    var todaysPick: some View {
        Button(action: pickOfTheDayAction) {
            
            if
                let todaysMovieDay = todaysMovieDay,
                let todaysMovie = todaysMovieDay.movie
            {
                
                PickCardView(
                    title: todaysMovie.title ?? "",
                    description: todaysMovie.overview ?? "",
                    uiImage: nil,
                    posterPath: todaysMovie.posterPath,
                    posterResolution: .original
                )
                
            } else {
                
                EmptyView()
                
            } //: if-else
            
        } //: Button
    }
    
    var nextPicks: some View {
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
    
    var emptyPicks: some View {
        VStack(spacing: 38) {
                        
            MovieFilmView()
                .frame(height: 153)
            
            Text(noPicksMessage)
                .textStyle(
                    foregroundColor: .onBackground,
                    size: 16,
                    lineSpacing: 8
                )
                .opacity(0.5)
                .multilineTextAlignment(.center)
                        
        } //: VStack
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !noPicksAvailable {
                
                todaysPick
                    .padding(.horizontal, 21)
                    .padding(.top, paddingVertical)
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
                
                nextPicks
                    .padding(.top, paddingVertical - 12)
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
                
            } else {
                                
                emptyPicks
                    .padding(.top, dimensions.screen.height * 0.15)
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))

            } //: if-else
            
        } //: VStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct MoviePicksView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePicksView(
            todaysMovieDay: TestData.sampleMovieDay,
            movies: TestData.sampleMoviePicks,
            preference: nil,
            pickOfTheDayAction: {}
        )
            .environmentObject(ImageCacheRepository())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Available")
        
        MoviePicksView(
            todaysMovieDay: nil,
            movies: [],
            preference: nil,
            pickOfTheDayAction: {}
        )
            .environmentObject(ImageCacheRepository())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Not Available")
    }
}
