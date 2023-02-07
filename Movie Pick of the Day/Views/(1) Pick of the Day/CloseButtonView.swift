//
//  CloseButtonView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct CloseButtonView: View {
    // MARK: - Props
    var action: Action
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            Icons.close.image
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundColor(Colors.onBackground.color.opacity(0.5))
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView(action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
