//
//  CircledButtonView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct CircledButtonView: View {
    // MARK: - Props
    var icon: Icons
    var isDisabled: Bool = false
    var paddingBottom: CGFloat = 6
    var action: Action
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            icon.image
                .resizable()
                .scaledToFit()
                .foregroundColor(Colors.onBackground.color)
                .padding(.horizontal, 6)
                .padding(.top, 6)
                .padding(.bottom, paddingBottom)
                .frame(width: 63, height: 63)
                .background(
                    Colors.onBackground.color.opacity(0.1)
                )
                .clipShape(Circle())
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct CircledButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircledButtonView(
            icon: .player,
            isDisabled: false,
            action: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
        
        CircledButtonView(
            icon: .search,
            paddingBottom: 8,
            action: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
