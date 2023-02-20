//
//  NoImageView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 19/2/23.
//

import SwiftUI

struct NoImageView: View {
    // MARK: - Props
    var title: String
    
    let color = Colors.secondary.color
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Layer 1: BACKGROUND
            Color.black
            
            // Layer 2: TITLE
            LinearGradient(
                colors: [color, color.opacity(0.2)],
                startPoint: .init(x: 0, y: 1),
                endPoint: .init(x: 0.1, y: 0.4)
            )
            .mask(
                Text(title)
                    .textStyle(
                        font: .amaranthBold,
                        size: 20,
                        lineLimit: 2
                    )
                    .multilineTextAlignment(.center)
                    .fillMaxSize(alignment: .bottom)
                    .frame(maxWidth: 82)
                    .padding(.bottom, 20)
            )
            
        } //: ZStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct NoImageView_Previews: PreviewProvider {
    static var previews: some View {
        NoImageView(title: "Glass Onion")
            .previewLayout(.fixed(width: 127, height: 164))
            .cornerRadius(10)
            .padding()
            .background(Colors.background.color)
    }
}
