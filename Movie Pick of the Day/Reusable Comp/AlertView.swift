//
//  AlertView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/3/23.
//

import SwiftUI

struct AlertView: View {
    // MARK: - Props
    var title: String
    var message: String
    var action: Action
    
    // MARK: - UI
    var content: some View {
        VStack(spacing: 38) {
            
            Text(title.uppercased())
                .textStyle(
                    foregroundColor: .secondary,
                    size: 24
                )
                .opacity(0.5)
            
            Text(message)
                .textStyle(
                    foregroundColor: .onBackground,
                    size: 18,
                    lineSpacing: 10
                )
                .multilineTextAlignment(.center)
            
        } //: VStack
        .padding(.horizontal, 18)
    }
    
    var body: some View {
        VStack(spacing: 45) {
            
            content
            
            FilledButtonView(
                title: "Ok",
                action: action
            )
            
        } //: VStack
        .padding(.vertical, 24)
        .background(Colors.background.color)
        .cornerRadius(15)
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            title: "NOTE",
            message: "Some days will not appear due to insufficient movies available",
            action: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
