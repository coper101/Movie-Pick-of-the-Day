//
//  ResultNetworkErrorView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 26/2/23.
//

import SwiftUI

struct ResultNetworkErrorView: View {
    // MARK: - Props
    var error: MovieRepositoryError
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 22) {
            
            Icons.warning.image
                .resizable()
                .scaledToFit()
                .frame(width: 93)
                .foregroundColor(Colors.secondary.color)
            
            Text(error.description)
                .textStyle(
                    foregroundColor: .secondary,
                    size: 16,
                    lineSpacing: 6
                )
                .multilineTextAlignment(.center)
                .frame(width: 198)
            
        } //: VStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct ResultNetworkErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ResultNetworkErrorView(error: .server)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Server Error")
        
        ResultNetworkErrorView(error: .request)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Request Error")
    }
}
