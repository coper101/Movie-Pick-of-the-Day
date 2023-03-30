//
//  BackdropView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import SwiftUI

struct BackdropView: View {
    // MARK: - Props
    
    // MARK: - UI
    var body: some View {
        LinearGradient(
            colors: [.clear, .black],
            startPoint: .init(x: 0.5, y: 0.3),
            endPoint: .bottom
        )
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct BackdropView_Previews: PreviewProvider {
    static var previews: some View {
        BackdropView()
            .previewLayout(.sizeThatFits)
            .background(Color.white)
            .padding()
    }
}
