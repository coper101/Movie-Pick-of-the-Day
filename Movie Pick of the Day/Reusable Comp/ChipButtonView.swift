//
//  ChipsView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 8/2/23.
//

import SwiftUI

struct ChipButtonView: View {
    // MARK: - Props
    var isSelected: Bool
    var title: String
    var action: Action
    
    var backgroundColor: Colors {
        isSelected ? .secondary : .onBackground
    }
    
    var color: Colors {
        isSelected ? .background : .onBackground
    }
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(
                    foregroundColor: color,
                    font: .interBold,
                    size: 12
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    backgroundColor.color
                        .opacity(isSelected ? 1 : 0.1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct ChipsView_Previews: PreviewProvider {
    static var previews: some View {
        ChipButtonView(
            isSelected: true,
            title: "Title",
            action: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Selected")
        
        ChipButtonView(
            isSelected: false,
            title: "Title",
            action: {}
        )            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Not Selected")
    }
}
