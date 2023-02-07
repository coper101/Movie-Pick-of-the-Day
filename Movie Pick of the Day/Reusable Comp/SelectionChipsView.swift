//
//  SelectionChipsView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct SelectionChipsView: View {
    // MARK: - Props
    @Binding var selections: [String]
    var options: [String]
    var title: String
    
    // MARK: - UI
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack {
                
                Text(title)
                    .textStyle(
                        font: .interBold,
                        size: 16
                    )
                
                Spacer()
                
            } //: HStack
            
//            VStack(spacing: 0) {
//                ForEach(
//            }
          
        } //: VStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct SelectionChipsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionChipsView(
            selections: .constant([]),
            options: ["Action", "Adventure", "Animation"],
            title: "Genre"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
