//
//  PagerTabView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

enum PagerItem {
    case item1
    case item2
    
    var icon: Icons {
        switch self {
        case .item1:
            return .player
        case .item2:
            return .search
        }
    }
}

struct PagerItemView: View {
    // MARK: - Props
    var icon: Icons
    var isSelected: Bool
    var action: Action
    
    // MARK: - UI
    var body: some View {
        CircledButtonView(
            icon: icon,
            isDisabled: false,
            action: action
        )
        .scaleEffect(isSelected ? 1 : 0.8)
        .cardShadow(
            y: isSelected ? 10 : 5,
            opacity: 0.2
        )
        .animation(
            .spring(response: 0.9).speed(2.2),
            value: isSelected
        )
    }
    
    // MARK: - Actions
}


struct PagerTabView: View {
    // MARK: - Props
    @Binding var selectedItem: PagerItem

    // MARK: - UI
    var body: some View {
        HStack(spacing: 32) {
            
            PagerItemView(
                icon: PagerItem.item1.icon,
                isSelected: selectedItem == .item1,
                action: { selectedItem = .item1 }
            )
            
            PagerItemView(
                icon: PagerItem.item2.icon,
                isSelected: selectedItem == .item2,
                action: { selectedItem = .item2 }
            )
            
        } //: HStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct PagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        PagerTabView(selectedItem: .constant(.item1))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
