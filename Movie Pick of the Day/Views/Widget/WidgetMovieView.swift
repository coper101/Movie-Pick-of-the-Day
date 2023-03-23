//
//  WidgetMovieView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import SwiftUI

struct MediumWidgetSize {
    static let xxs = CGSize(width: 292, height: 141)
    static let xs = CGSize(width: 321, height: 148)
    static let s = CGSize(width: 329, height: 155)
    static let m = CGSize(width: 338, height: 158)
    static let r = CGSize(width: 348, height: 157)
    static let l = CGSize(width: 360, height: 169)
    static let xl = CGSize(width: 364, height: 170)
    
    static let sizes = [xxs, xs, s, m, r, l, xl]
}

struct SmallWidgetSize {
    static let xxs = CGSize(width: 141, height: 141)
    static let xs = CGSize(width: 148, height: 148)
    static let s = CGSize(width: 151, height: 151)
    static let m = CGSize(width: 155, height: 155)
    static let r = CGSize(width: 158, height: 158)
    static let l = CGSize(width: 159, height: 159)
    static let xl = CGSize(width: 169, height: 169)
    static let xxl = CGSize(width: 170, height: 170)
    
    static let sizes = [xxs, xs, s, m, r, l, xl, xxl]
}

struct WidgetMovieView: View {
    // MARK: - Props
    var dayPick: MovieDay?
    var hasTitle: Bool
    var hasSummary: Bool
    var uiImage: UIImage?
    
    // MARK: - UI
    var background: some View {
        ZStack {

            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(1.1)
            }
            
            BackdropView()
            
        } //: ZStack
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if let dayPick {
                
                // Row 1: TITLE
                if hasTitle {
                    
                    Text(dayPick.movie?.displayedTitle ?? "")
                        .textStyle(
                            font: .interExtraBold,
                            size: 16,
                            lineLimit: 2,
                            lineSpacing: 4
                        )
                }
                
                // Row 2: DESCRIPTION
                if hasSummary {
                    
                    Text(dayPick.movie?.displayedOverview ?? "")
                        .textStyle(
                            font: .interBold,
                            size: 12,
                            lineLimit: 2,
                            lineSpacing: 3
                        )
                }
                
            } //: if-day-pick


        } //: VStack
        .fillMaxSize(alignment: .bottom)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        .background(background)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct WidgetMovieView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(MediumWidgetSize.sizes, id: \.width) { size in

            WidgetMovieView(
                dayPick: TestData.sampleMovieDay,
                hasTitle: true,
                hasSummary: true,
                uiImage: UIImage(named: "sample-poster")
            )
            .previewLayout(
                .fixed(width: size.width, height: size.height)
            )
            .previewDisplayName("Medium / \(size)")

        }
        
        ForEach(SmallWidgetSize.sizes, id: \.width) { size in

            WidgetMovieView(
                dayPick: TestData.sampleMovieDay,
                hasTitle: true,
                hasSummary: false,
                uiImage: UIImage(named: "sample-poster")
            )
            .previewLayout(
                .fixed(width: size.width, height: size.height)
            )
            .previewDisplayName("Small / \(size)")

        }
    }
}
