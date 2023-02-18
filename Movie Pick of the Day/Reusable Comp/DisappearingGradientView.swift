//
//  DisappearingGradientView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 16/2/23.
//

import SwiftUI

enum ContentDirection {
    case top
    case bottom
}

struct DisappearingGradientView: View {
    // MARK: - Props
    var contentDirection: ContentDirection
    var color: Colors
    
    var startPoint: UnitPoint {
        contentDirection == .top ? .top : .bottom
    }
    
    var endPoint: UnitPoint {
        contentDirection == .top ? .bottom : .top
    }
    
    // MARK: - UI
    var body: some View {
        LinearGradient(
            colors: [
                color.color,
                color.color.opacity(0)
            ],
            startPoint: startPoint,
            endPoint: endPoint
        )
        .allowsHitTesting(false)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct DisappearingGradientView_Previews: PreviewProvider {
    static var previews: some View {
        DisappearingGradientView(
            contentDirection: .top,
            color: .background
        )
            .previewLayout(.fixed(width: 100, height: 100))
            .previewDisplayName("Top Direction")
            .padding()
            .background(Color.green)
        
        DisappearingGradientView(
            contentDirection: .bottom,
            color: .background
        )
            .previewLayout(.fixed(width: 100, height: 100))
            .previewDisplayName("Bottom Direction")
            .padding()
            .background(Color.green)
    }
}
