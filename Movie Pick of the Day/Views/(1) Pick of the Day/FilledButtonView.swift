//
//  FilledButtonView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct FilledButtonView: View {
    // MARK: - Props
    var title: String
    var icon: Icons?
    var isDisabled: Bool
    var action: Action
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(Colors.secondary.color)
                    .fillMaxWidth()
                    .padding(.horizontal, 21)
                    .opacity(isDisabled ? 0.7 : 1)
                
                HStack(spacing: 12) {
                    
                    if let icon {
                        icon.image
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Colors.background.color)
                            .frame(width: 32, height: 32)
                    }
                    
                    Text(title)
                        .textStyle(
                            foregroundColor: .background,
                            font: .interBold,
                            size: 20
                        )
                    
                } //: HStack
                
            } //: ZStack
            .fillMaxWidth()
            .frame(height: 61)
            
        } //: Button
        .disabled(isDisabled)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct FilledButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilledButtonView(
            title: "Done",
            isDisabled: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        .padding(.vertical, 22)
        .background(Colors.background.color)
        .previewDisplayName("Title")

        FilledButtonView(
            title: "No Internet",
            icon: .warning,
            isDisabled: true,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        .padding(.vertical, 22)
        .background(Colors.background.color)
        .previewDisplayName("Icon + Title + Disabled")
    }
}
