//
//  ResultNoInternetConnectionView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 22/2/23.
//

import SwiftUI

struct ResultNoInternetConnectionView: View {
    // MARK: - Props
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 22) {
            
            Icons.noInternetConnectionIllus.image
                .resizable()
                .scaledToFit()
                .frame(width: 93)
                .foregroundColor(Colors.secondary.color)
            
            Text("Please Check Your\nInternet Connection")
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
struct ResultNoInternetConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ResultNoInternetConnectionView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
