//
//  ChipToggleView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 8/2/23.
//

import SwiftUI

struct ChipToggleView: View {
    // MARK: - Props
    @Binding var isYes: Bool
    var yesTitle: String = "Yes"
    var noTitle: String = "No"
    
    // MARK: - UI
    var body: some View {
        HStack(spacing: 12) {
            ChipButtonView(
                isSelected: isYes,
                title: yesTitle,
                action: yesAction
            )
            
            ChipButtonView(
                isSelected: !isYes,
                title: noTitle,
                action: noAction
            )
        } //: HStack
    }
    
    // MARK: - Actions
    func yesAction() {
        if !isYes {
            isYes = true
        }
    }
    
    func noAction() {
        if isYes {
            isYes = false
        }
    }
}

// MARK: - Preview
struct ToggleChipsView_Previews: PreviewProvider {
    static var previews: some View {
        ChipToggleView(isYes: .constant(true))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
