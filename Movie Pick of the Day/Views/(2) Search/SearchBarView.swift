//
//  SearchBarView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct DynamicTextField: View {
    // MARK: - Props
    var placeholder: String
    @Binding var text: String
    var onCommit: Action
    
    // MARK: - UI
    var body: some View {
        Group {
            if #available(iOS 15.0, *) {
                TextField(
                    placeholder,
                    text: $text
                )
                .onSubmit(onCommit)
                .submitLabel(.done)
            } else {
                TextField(
                    placeholder,
                    text: $text,
                    onCommit: onCommit
                )
            }
        } //: Group
    }
    
    // MARK: - Actions
}


struct SearchBarView: View {
    // MARK: - Props
    @Binding var text: String
    var placeholder: String
    var isDisabled: Bool
    var onCommit: Action
    
    // MARK: - UI
    var body: some View {
        DynamicTextField(
            placeholder: placeholder,
            text: $text,
            onCommit: onCommit
        )
        .textStyle(
            font: .interSemiBold,
            size: 24
        )
        .opacity(isDisabled ? 0.3 : 1)
        .disabled(isDisabled)
        .frame(height: 79)
        .padding(.horizontal, 28)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Colors.onBackground.color)
                .opacity(isDisabled ? 0.05 : 0.2)
        )
        .clipped()
        .cardShadow()
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(
            text: .constant(""),
            placeholder: "Search Movie",
            isDisabled: false,
            onCommit: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Colors.background.color)
        .previewDisplayName("Enabled")
        
        SearchBarView(
            text: .constant(""),
            placeholder: "Search Movie",
            isDisabled: true,
            onCommit: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Colors.background.color)
        .previewDisplayName("Disabled")
    }
}
