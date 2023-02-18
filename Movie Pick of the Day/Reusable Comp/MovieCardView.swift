//
//  MovieCardView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct MovieCardView: View {
    // MARK: - Props
    @EnvironmentObject var imageCache: ImageCacheRepository

    var movieDay: MovieDay?
    var movieTitle: String?
    
    var uiImage: UIImage?
    var posterPath: String?
    var posterResolution: ImageResolution
    
    var isBlurred: Bool {
        movieDay != nil
    }
    
    // MARK: - UI
    var background: some View {
        ZStack {
            
            // Layer 1: BACKGROUND IMAGE
            AsyncImageView(
                imageCache: imageCache,
                path: posterPath,
                resolution: posterResolution,
                isResizable: true,
                isScaledToFill: true,
                scaleEffect: 1.1
            )
            
            // TESTING
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(1.1)
            }
            
        } //: ZStack
        .blur(radius: isBlurred ? 5 : 0)
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
                
            } //: if
            
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
        .cardShadow(y: 5, opacity: 0.5)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // MARK: - Poster
            poster
            
            // MARK: - Title
            if let movieTitle {
                
                Text(movieTitle)
                    .textStyle(
                        font: .interBold,
                        size: 16,
                        lineLimit: 2,
                        lineSpacing: 5
                    )
                    .multilineTextAlignment(.center)
                
            } //: if
            
        } //: VStack
        .frame(width: 127)
        .withSlowPopAnimation()
    }

}

// MARK: - Preview
struct MovieCardView_Previews: PreviewProvider {
    static var movieDay = TestData.sampleMovieDay
    static var movie = TestData.sampleMovie
    
    static var previews: some View {
        MovieCardView(
            movieDay: movieDay,
            uiImage: .init(named: Icons.samplePoster.rawValue)!,
            posterResolution: .original
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Movie Day")
            .environmentObject(ImageCacheRepository())
        
        MovieCardView(
            movieTitle: movie.title,
            uiImage: .init(named: Icons.samplePoster.rawValue)!,
            posterResolution: .original
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Movie")
            .environmentObject(ImageCacheRepository())
    }
}
