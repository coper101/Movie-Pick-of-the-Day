//
//  SearchBarView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct SearchBarView: View {
    // MARK: - Props
    @Binding var text: String
    var placeholder: String
    var onCommit: Action
    
    // MARK: - UI
    var body: some View {
        TextField(
            placeholder,
            text: $text,
            onCommit: onCommit
        )
        .textStyle(
            font: .interSemiBold,
            size: 24
        )
        .frame(height: 79)
        .padding(.horizontal, 28)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Colors.onBackground.color)
                .opacity(0.2)
        )
        .clipped()
        .cardShadow()
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(
            text: .constant(""),
            placeholder: "Search Movie",
            onCommit: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
