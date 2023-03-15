//
//  CloseButtonView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: style)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct CloseButtonView: View {
    // MARK: - Props
    var hasBlurEffect: Bool
    var action: Action
    
    // MARK: - UI
    var content: some View {
        Icons.close.image
            .resizable()
            .scaledToFit()
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if hasBlurEffect {
                    VisualEffectView(style: .systemMaterialDark)
                        .dynamicMask { content }
                } else {
                    content
                        .foregroundColor(.white.opacity(0.45))
                }
            }
            .frame(width: 44, height: 44)
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView(
            hasBlurEffect: true,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.white)
        .previewDisplayName("Blur Effect")
        
        CloseButtonView(
            hasBlurEffect: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.white)
        .previewDisplayName("Semi Transparent")
    }
}
