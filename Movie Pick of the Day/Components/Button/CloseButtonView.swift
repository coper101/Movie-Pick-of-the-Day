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
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct CloseButtonView: View {
    // MARK: - Props
    var action: Action
    
    // MARK: - UI
    var body: some View {
        Button(action: action) {
            VisualEffectView(style: .systemMaterialDark)
                .dynamicMask {
                    Icons.close.image
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 44, height: 44)
        } //: Button
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView(action: {})
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white)
    }
}
