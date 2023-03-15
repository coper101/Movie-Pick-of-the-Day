//
//  ChipsView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 8/2/23.
//

import SwiftUI


struct ChipButtonView: View {
    // MARK: - Props
    var isSelected: Bool
    var isLoading: Bool 
    var title: String
    var action: Action
    
    var backgroundColor: Colors {
        isSelected ? .secondary : .onBackground
    }
    
    var color: Colors {
        isSelected ? .background : .onBackground
    }
    
    var shape: some Shape {
        RoundedRectangle(cornerRadius: 12)
    }
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            
            Group {
                if !isLoading {
                    Text(title)
                        .textStyle(
                            foregroundColor: color,
                            font: .interBold,
                            size: 12
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            backgroundColor.color
                                .opacity(isSelected ? 1 : 0.1)
                        )
                        .clipShape(shape)
                } else {
                    shape
                        .fill(Colors.onBackground.color.opacity(0.1))
                        .frame(width: 68, height: 33)
                        .withSkeletonLoadingAnimation()
                        .clipShape(shape)
                    
                }
            } //: Group
       
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct ChipsView_Previews: PreviewProvider {
    static var previews: some View {
        ChipButtonView(
            isSelected: true,
            isLoading: false,
            title: "Title",
            action: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Selected")
        
        ChipButtonView(
            isSelected: false,
            isLoading: false,
            title: "Title",
            action: {}
        )            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Not Selected")
        
        ChipButtonView(
            isSelected: false,
            isLoading: true,
            title: "Title",
            action: {}
        )            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Loading")
    }
}
