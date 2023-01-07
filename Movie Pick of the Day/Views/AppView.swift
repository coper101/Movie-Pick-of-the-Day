//
//  AppView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

struct AppView: View {
    // MARK: - Props
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 0) {
            HomeView()
        }
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .previewLayout(.sizeThatFits)
    }
}
