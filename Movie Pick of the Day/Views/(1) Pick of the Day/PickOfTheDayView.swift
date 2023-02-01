//
//  PickOfTheDayView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import SwiftUI

struct PickOfTheDayView: View {
    // MARK: - Props
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dimensions) var dimensions: Dimensions
    
    let movie = TestData.sampleMovie
    let picks: [MovieDay] = [
        TestData.sampleMovieDay,
        TestData.createMovieDay(movieID: 102, day: .friday),
        TestData.createMovieDay(movieID: 103, day: .saturday)
    ]
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: Layer 1: Top Bar
            TopBarView(title: "Movie Pick of the Day")
                .padding(.top, dimensions.insets.top)
            
            // MARK: Layer 2 Content
            ScrollView {
                
                VStack(spacing: 30) {
                    
                    // Row 1: PREFERENCES + CREDIT SOURCE
                    HStack(spacing: 12) {
                    
                        RoundButtonView(
                            title: "Action, Adventure, EN, Non-",
                            subtitle: "Preferences",
                            action: {}
                        )
                        
                        RoundButtonView(
                            subtitle: "powered by",
                            icon: .tmdbLogo,
                            fillSpace: false,
                            action: {}
                        )
                        
                    } //: HStack
                    .padding(.horizontal, 21)
                    
                    // Row 2: PICK OF THE DAY
                    Button(action: {}) {
                        
                        PickCardView(
                            title: movie.title ?? "",
                            description: movie.overview ?? "",
                            uiImage: UIImage(named: Icons.samplePoster.rawValue)!
                        )
                        .cardShadow()
                        
                    } //: Button
                    .padding(.horizontal, 21)
                    
                    // Row 3: PICKS
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        LazyHGrid(rows: [.init(.flexible())], spacing: 22) {
                            
                            ForEach(picks) { pick in
                                
                                Button(action: {}) {
                                    
                                    MovieCardView(
                                        movieDay: pick,
                                        uiImage: UIImage(named: Icons.samplePoster.rawValue)!
                                    )
                                    
                                } //: Button
                               
                            } //: ForEach
                            
                        } //: LazyHGrid
                        .frame(height: 164)
                        .padding(.leading, 21)
                        .padding(.bottom, 50)
                        
                    } //: ScrollView
                   
                    
                } //: VStack
                .padding(.top, 54 + dimensions.insets.top)
                .fillMaxSize(alignment: .top)
                
            } //: ScrollView
            
        } //: ZStack
        .background(Colors.background.color)
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
