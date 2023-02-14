//
//  PickRevealView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

struct PickRevealView: View {
    // MARK: - Props
    @EnvironmentObject var imageCache: ImageCacheRepository
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dimensions) var dimensions: Dimensions
    
    var movie: Movie
    var uiImage: UIImage?
    
    // MARK: - UI
    var background: some View {
        ZStack {
            
            // Layer 1: BACKGROUND IMAGE
            AsyncImageView(
                imageCache: imageCache,
                path: movie.posterPath,
                resolution: .original,
                isResizable: true,
                isScaledToFill: true,
                scaleEffect: 1.1
            )
            
            // TESTING
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.1)
            }
            
        } //: ZStack
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Layer 1 - Background Image
            Colors.background.color
            Colors.backgroundLight.color
            
            background
                .padding(.bottom, 300)
            
            // MARK: Layer 2 - Sheet
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // TITLE
                    Text(movie.title ?? "")
                        .textStyle(
                            font: .interExtraBold,
                            size: 24
                        )
                        .padding(.horizontal, 22)
                    
                    // DESCRIPTION
                    Text(movie.overview  ?? "")
                        .textStyle(
                            font: .interSemiBold,
                            size: 17,
                            lineSpacing: 4
                        )
                        .opacity(0.5)
                        .padding(.top, 24)
                        .padding(.horizontal, 22)
                    
                    // MORE INFO
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 36) {
                            
                            // VOTE AVERAGE
                            MovieInfoBoxView(
                                title: movie.displayedVoteAverage,
                                subtitle: "Vote Average"
                            )
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            // RELEASE DATE
                            MovieInfoBoxView(
                                title: movie.displayedReleasedDate,
                                subtitle: "Release Date"
                            )
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            // LANGUAGE
                            MovieInfoBoxView(
                                title: movie.displayedLanguage,
                                subtitle: "Language"
                            )
                        }
                        .padding(.top, 28)
                        .frame(height: 80)
                        .padding(.horizontal, 22)

                    } //: ScrollView
                    
                    // SIMILAR MOVIES
                    ScrollView(.horizontal, showsIndicators: false) {

                        LazyHStack(spacing: 22) {

                            ForEach(appViewModel.similarMovies) { movie in
                                                            
                                Button(action: {}) {

                                    MovieCardView(
                                        movieDay: nil,
                                        movieTitle: movie.title ?? "",
                                        uiImage: nil,
                                        posterPath: movie.posterPath,
                                        posterResolution: .w500
                                    )

                                } //: Button

                            } //: ForEach

                        } //: LazyHGrid
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 26)
                        .padding(.horizontal, 21)
                        .padding(.bottom, 50)
                        
                        Spacer()
                        
                    } //: ScrollView
                    .background(Colors.backgroundLight.color)
                    .padding(.top, 44)
                    
                } //: VStack
                .frame(height: UIScreen.main.bounds.height, alignment: .top)
                .padding(.top, 24)
                .background(Colors.background.color)
                .cornerRadius(radius: 22, corners: [.topLeft, .topRight])
                .padding(.top, 280)
                
            } //: ScrollView
            .overlay(
                HStack {
                    Spacer()
                    CloseButtonView(action: closeAction)
                        .padding(.trailing, 12)
                        .padding(.top, 4 + dimensions.insets.top)
                },
                alignment: .topTrailing
            )
            
        } //: ZStack
    }
    
    // MARK: - Actions
    func closeAction() {
        withAnimation {
            appViewModel.didTapClosePickOfTheDayDetailScreen()
        }
    }
}

// MARK: - Preview
struct PickRevealView_Previews: PreviewProvider {
    static var movie = TestData.sampleMovie
    
    static var previews: some View {
        PickRevealView(
            movie: movie,
            uiImage: UIImage(named: Icons.samplePoster.rawValue)!
        )
            .previewLayout(.sizeThatFits)
            .environmentObject(TestData.appViewModel)
            .environmentObject(ImageCacheRepository())
    }
}

struct MovieInfoBoxView: View {
    // MARK: - Props
    var title: String
    var subtitle: String
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 4) {
                
            // TITLE
            Spacer()
            Text(title)
                .textStyle(
                    font: .interExtraBold,
                    size: 18
                )
            
            // SUBTITLE
            Text(subtitle)
                .textStyle(
                    font: .interBold,
                    size: 12
                )
                .opacity(0.5)
            
        } //: VStack
    }
}
