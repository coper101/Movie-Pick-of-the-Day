//
//  Shadow.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    var y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .black.opacity(0.25),
                radius: 8,
                x: 0,
                y: y
            )
    }
}

extension View {
    
    func cardShadow(y: CGFloat = 10) -> some View {
        modifier(ShadowModifier(y: y))
    }
    
}
