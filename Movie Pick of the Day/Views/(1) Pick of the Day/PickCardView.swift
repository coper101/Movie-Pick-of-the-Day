//
//  PickCardView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct PickCardView: View {
    // MARK: - Props
    @EnvironmentObject var imageCache: ImageCacheRepository
    @State var isAnimating: Bool = false

    var title: String
    var description: String
    
    var uiImage: UIImage?
    var posterPath: String?
    var posterResolution: ImageResolution
    
    // MARK: - UI
    var background: some View {
        ZStack(alignment: .bottom) {
            
            // Layer 1: BACKGROUND IMAGE
            Group {

                // POSTER
                AsyncImageView(
                    imageCache: imageCache,
                    path: posterPath,
                    resolution: posterResolution,
                    showLoading: false,
                    placeholderTitle: title,
                    isResizable: true,
                    isScaledToFill: true,
                    scaleEffect: 1.1,
                    hasMovingUpAndDownAnimation: true
                )
                
                // TESTING
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .withMovingUpAndDownAnimation()
                }
                
            } //: Group
            .scaleEffect(1.05)
            
            // Layer 2: BACKDROP
            BackdropView()
            
        } //: ZStack
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Row 1: TITLE
            Text(title)
                .textStyle(
                    font: .interExtraBold,
                    size: 20,
                    lineLimit: 2
                )

            // Row 2: DESCRIPTION
            Text(description)
                .textStyle(
                    font: .interBold,
                    size: 14,
                    lineLimit: 2,
                    lineSpacing: 3
                )

        } //: VStack
        .fillMaxWidth(alignment: .leading)
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 22)
        .padding(.bottom, 20)
        .frame(height: 304, alignment: .bottom)
        .background(background)
        .clipped()
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
        .cardShadow()
        .withSlowPopAnimation()
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct PickCardView_Previews: PreviewProvider {
    static var movie = TestData.sampleMovie
    
    static var previews: some View {
        PickCardView(
            title: movie.title ?? "",
            description: movie.overview ?? "",
            uiImage: UIImage(named: Icons.samplePoster.rawValue)!,
            posterResolution: .original
        )
        .previewLayout(.fixed(width: 355, height: 350))
        .padding()
        .background(Colors.background.color)
        .environmentObject(ImageCacheRepository())
    }
}

