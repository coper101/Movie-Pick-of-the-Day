//
//  Button.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 19/3/23.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    // MARK: Props
    var minScale: CGFloat
    
    // MARK: UI
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? minScale : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

