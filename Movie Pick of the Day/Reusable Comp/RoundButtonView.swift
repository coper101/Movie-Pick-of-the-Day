//
//  RoundButtonView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

typealias Action = () -> Void

struct RoundButtonView: View {
    // MARK: - Props
    var title: String?
    var subtitle: String
    var icon: Icons?
    var fillSpace: Bool = true
    var action: Action
    
    // MARK: - UI
    
    var content: some View {
        HStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(subtitle)
                    .textStyle(lineLimit: 1)
                    .opacity(0.45)
                
                if let title {
                    
                    Text(title)
                        .textStyle(lineLimit: 1)
                    
                }
                
                if let icon {
                    
                    icon.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                        .padding(.top, 2)
                    
                }
                
            } //: VStack
            
            if fillSpace {
                Spacer(minLength: 0)
            }
            
        } //: HStack
        .frame(height: 51)
        .padding(.horizontal, 14)
        .padding(.vertical, 2)
        .background(
            Colors.onBackground.color.opacity(0.1)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
    }
    
    var body: some View {
        Button(action: action) {
            content
        }
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct RoundButtonView_Previews: PreviewProvider {
    static var previews: some View {
        
        RoundButtonView(
            title: "Action, Adventure, EN, Non-",
            subtitle: "Preferences",
            action: {}
        )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Title")
            .padding()
        
        RoundButtonView(
            subtitle: "powered by",
            icon: .tmdbLogo,
            action: {}
        )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Logo")
            .padding()
        
    }
}
