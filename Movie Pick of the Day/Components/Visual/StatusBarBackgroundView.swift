//
//  StatusBarBackgroundView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct StatusBarBackgroundView: View {
    // MARK: - Props
    @Environment(\.dimensions) var dimensions: Dimensions
    
    // MARK: - UI
    var body: some View {
        Rectangle()
            .fill(Colors.background.color)
            .fillMaxWidth()
            .frame(height: dimensions.insets.top)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct StatusBarBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarBackgroundView()
            .previewLayout(.sizeThatFits)
            // .background(Colors.Background)
    }
}
