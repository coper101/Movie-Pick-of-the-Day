//
//  PickOfTheDayView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import SwiftUI

struct PickOfTheDayView: View {
    // MARK: - Props
    @EnvironmentObject var appViewModel: AppViewModel
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 10) {
            
            ForEach(appViewModel.moviePickIDsOfTheWeek, id: \.day) { pick in
                
                VStack(spacing: 0) {
                    Text("day: \(pick.day)")
                    Text("movie title \(pick.movie?.title ?? "none")")
                }
               
            }
            
        }
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PickOfTheDayView()
            .previewLayout(.sizeThatFits)
            .environmentObject(AppViewModel())
    }
}
