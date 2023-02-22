//
//  ResultNoneView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 22/2/23.
//

import SwiftUI

struct ResultNoneView: View {
    // MARK: - Props
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 22) {
            
            Icons.noResultsIllus.image
                .resizable()
                .scaledToFit()
                .frame(width: 93)
                .foregroundColor(Colors.secondary.color)
            
            Text("No Results")
                .textStyle(
                    foregroundColor: .secondary,
                    size: 16,
                    lineSpacing: 6
                )
                .multilineTextAlignment(.center)
            
        } //: VStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct ResultNoneView_Previews: PreviewProvider {
    static var previews: some View {
        ResultNoneView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
