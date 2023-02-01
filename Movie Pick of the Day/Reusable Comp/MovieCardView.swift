//
//  MovieCardView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct MovieCardView: View {
    // MARK: - Props
    var movieDay: MovieDay
    var uiImage: UIImage
    
    // MARK: - UI
    var background: some View {
        ZStack {
            
            // Layer 1: BACKGROUND IMAGE
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .blur(radius: 5)
            
        } //: ZStack
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            

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
            
        } //: VStack
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .frame(width: 127, height: 164, alignment: .bottom)
        .background(background)
        .clipped()
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
        .cardShadow()
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct MovieCardView_Previews: PreviewProvider {
    static var movieDay = TestData.sampleMovieDay
    
    static var previews: some View {
        MovieCardView(
            movieDay: movieDay,
            uiImage: .init(named: Icons.samplePoster.rawValue)!
        )
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
