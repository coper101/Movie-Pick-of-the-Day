//
//  ChipView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 8/2/23.
//

import SwiftUI

struct ChipOptionView: View {
    // MARK: - Props
    @State var isSelected: Bool = false
    var title: String
    var isSingleSelected: Bool?
    var toggleAction: (Bool) -> Void
    
    var backgroundColor: Colors {
        isSelected ? .secondary : .onBackground
    }
    
    var color: Colors {
        isSelected ? .background : .onBackground
    }
    
    var isSelectedChip: Bool {
        if let isSingleSelected {
            return isSingleSelected
        }
        return isSelected
    }
    
    // MARK: - UI
    var body: some View {
        ChipButtonView(
            isSelected: isSelectedChip,
            title: title,
            action: toggleSelection
        )
        .transition(.opacity)
    }
    
    // MARK: - Actions
    func toggleSelection() {
        isSelected.toggle()
        toggleAction(isSelected)
    }
}

// MARK: - Preview
struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipOptionView(
            title: "Adventure",
            toggleAction: { _ in }
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
