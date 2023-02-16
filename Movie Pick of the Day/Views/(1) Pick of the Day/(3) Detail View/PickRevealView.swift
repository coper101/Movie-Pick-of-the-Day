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
    
    let paddingHorizontal: CGFloat = 24
    
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
                        .kerning(1)
                        .textStyle(
                            font: .interExtraBold,
                            size: 24
                        )
                        .padding(.horizontal, paddingHorizontal)
                        .padding(.top, 30)
                    
                    // DESCRIPTION
                    Text(movie.overview  ?? "")
                        .kerning(0.5)
                        .textStyle(
                            font: .interSemiBold,
                            size: 17,
                            lineSpacing: 4
                        )
                        .opacity(0.5)
                        .padding(.top, 24)
                        .padding(.horizontal, paddingHorizontal)
                    
                    // MORE INFO
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 36) {
                            
                            // VOTE AVERAGE
                            MovieInfoBoxView(
                                title: movie.displayedVoteAverage,
                                subtitle: "Vote Average"
                            )
                            
                            DividerView()
                            
                            // RELEASE DATE
                            MovieInfoBoxView(
                                title: movie.displayedReleasedDate,
                                subtitle: "Release Date"
                            )
                            
                            DividerView()
                            
                            // LANGUAGE
                            MovieInfoBoxView(
                                title: movie.displayedLanguage,
                                subtitle: "Language"
                            )
                        }
                        .padding(.top, 28)
                        .padding(.bottom, 6)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, paddingHorizontal)

                    } //: ScrollView
                    
                    // SIMILAR MOVIES
                    SimilarMoviesView(movies: appViewModel.similarMovies)
                        .padding(.top, 44)
                    
                } //: VStack
                .frame(minHeight: dimensions.screen.height * 0.75, alignment: .top)
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
            .dynamicOverlay(alignment: .bottom) {
                DisappearingGradientView(
                    contentDirection: .bottom,
                    color: .background
                )
                .frame(height: 74)
            }
            
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
