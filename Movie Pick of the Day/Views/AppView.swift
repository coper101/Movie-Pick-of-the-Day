//
//  AppView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import SwiftUI

enum Screen {
    case pickOfTheDay
    case search
    case pickReveal
}

struct AppView: View {
    // MARK: - Props
    @EnvironmentObject var appViewModel: AppViewModel
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 0) {
            switch appViewModel.screen {
            case .pickOfTheDay:
                PickOfTheDayView()
            case .search:
                SearchView()
            case .pickReveal:
                PickRevealView()
            }
        }
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .previewLayout(.sizeThatFits)
            .environmentObject(AppViewModel())
    }
}
