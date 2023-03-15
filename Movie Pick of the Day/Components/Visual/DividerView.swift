//
//  DividerView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

struct DividerView: View {
    // MARK: - Props
    var paddingVertical: CGFloat = 12
    
    // MARK: - UI
    var body: some View {
        Rectangle()
            .fill(Colors.onBackground.color)
            .frame(width: 1)
            .fillMaxHeight()
            .opacity(0.1)
            .padding(.vertical, paddingVertical)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView()
            .frame(height: 100)
            .padding()
            .previewLayout(.sizeThatFits)
            .background(Colors.background.color)
    }
}
