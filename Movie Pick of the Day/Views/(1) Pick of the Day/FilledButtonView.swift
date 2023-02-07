//
//  FilledButtonView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct FilledButtonView: View {
    // MARK: - Props
    var title: String
    var action: Action
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(Colors.secondary.color)
                    .fillMaxWidth()
                    .padding(.horizontal, 21)
                
                Text(title)
                    .textStyle(
                        foregroundColor: .background,
                        font: .interBold,
                        size: 20
                    )
                
            } //: ZStack
            .fillMaxWidth()
            .frame(height: 61)
            
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct FilledButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilledButtonView(title: "Done", action: {})
            .previewLayout(.sizeThatFits)
            // .background(Colors.Background)
    }
}
