//
//  Shadow.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    var y: CGFloat
    var opacity: CGFloat
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .black.opacity(opacity),
                radius: radius,
                x: 0,
                y: y
            )
    }
}

extension View {
    
    func cardShadow(
        y: CGFloat = 5,
        opacity: CGFloat = 0.5,
        radius: CGFloat = 5
    ) -> some View {
        modifier(
            ShadowModifier(
                y: y,
                opacity: opacity,
                radius: radius
            )
        )
    }
    
}
