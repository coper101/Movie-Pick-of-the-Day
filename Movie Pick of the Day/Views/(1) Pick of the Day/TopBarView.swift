//
//  TopBarView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct TopBarView: View {
    // MARK: - Props
    var title: String
    
    // MARK: - UI
    var body: some View {
        ZStack {
            
            // Layer 1: BACKGROUND
            DisappearingGradientView(
                contentDirection: .top,
                color: .background
            )
            
            // Layer 2: TITLE
            Text(title)
                .textStyle(
                    foregroundColor: .secondary,
                    font: .amaranthBold,
                    size: 28
                )
            
        } //: HStack
        .fillMaxWidth()
        .frame(height: 54)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView(title: "Movie Pick of the Day")
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.green)
    }
}
