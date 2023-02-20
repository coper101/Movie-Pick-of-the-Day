//
//  LoadingImageView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 20/2/23.
//

import SwiftUI

struct LoadingImageView: View {
    // MARK: - Props
    let color: Color = Colors.onBackgroundLight.color
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // Layer 1: BACKGROUND
            Colors.background.color
             
            // Layer 3: LOGO
            Image("app-logo-template")
                .resizable()
                .frame(width: 25, height: 25)
                .opacity(0.25)
                .padding(.trailing, 12)
                .padding(.bottom, 12)
            
        } //: ZStack
        .withSkeletonLoadingAnimation(opacity: 0.01)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct LoadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingImageView()
            .previewLayout(.fixed(width: 127, height: 164))
            .cornerRadius(10)
            .padding()
            .background(Colors.background.color)
    }
}
