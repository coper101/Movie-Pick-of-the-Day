//
//  MovieInfoBoxView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

struct MovieInfoBoxView: View {
    // MARK: - Props
    var title: String
    var subtitle: String
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 8) {
                
            // TITLE
            Spacer()
            Text(title)
                .kerning(1)
                .textStyle(
                    font: .interExtraBold,
                    size: 18
                )
            
            // SUBTITLE
            Text(subtitle)
                .kerning(0.5)
                .textStyle(
                    font: .interBold,
                    size: 14
                )
                .opacity(0.4)
            
        } //: VStack
    }
}

// MARK: - Preview
struct MovieBoxInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MovieInfoBoxView(
            title: "Title",
            subtitle: "Subtitle"
        )
        .frame(height: 50)
        .padding()
        .background(Colors.background.color)
        .previewLayout(.sizeThatFits)

    }
}
