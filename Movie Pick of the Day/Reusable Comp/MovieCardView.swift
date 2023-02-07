//
//  MovieCardView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct MovieCardView: View {
    // MARK: - Props
    var movieDay: MovieDay?
    var movieTitle: String?
    
    var uiImage: UIImage
    
    var isBlurred: Bool {
        movieDay != nil
    }
    
    // MARK: - UI
    var background: some View {
        ZStack {
            
            // Layer 1: BACKGROUND IMAGE
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .blur(radius: isBlurred ? 5 : 0)
            
        } //: ZStack
    }
    
    var poster: some View {
        ZStack(alignment: .top) {
            
            if let movieDay {
                // Layer 1: DAY
                Text(movieDay.day.name)
                    .textStyle(
                        font: .amaranthBold,
                        size: 24
                    )
                    .offset(y: 80)
                    .zIndex(0)
                
                // Layer 2: GUESS ICON
                Text("?")
                    .textStyle(
                        font: .amaranthBold,
                        size: 93,
                        lineLimit: 1
                    )
                    .offset(y: -30)
                    .zIndex(1)
            }
            
        } //: VStack
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .frame(height: 164, alignment: .bottom)
        .fillMaxWidth()
        .background(background)
        .clipped()
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
        .cardShadow()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // POSTER
            poster
            
            // TITLE
            if let movieTitle {
                Text(movieTitle)
                    .textStyle(
                        font: .interBold,
                        size: 16,
                        lineLimit: 1
                    )
            }
            
        } //: VStack
        .frame(width: 127)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct MovieCardView_Previews: PreviewProvider {
    static var movieDay = TestData.sampleMovieDay
    static var movie = TestData.sampleMovie
    
    static var previews: some View {
        MovieCardView(
            movieDay: movieDay,
            uiImage: .init(named: Icons.samplePoster.rawValue)!
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Movie Day")
        
        MovieCardView(
            movieTitle: movie.title,
            uiImage: .init(named: Icons.samplePoster.rawValue)!
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Movie")
    }
}