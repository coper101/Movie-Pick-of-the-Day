//
//  Modifier.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

// MARK: Conditional Modifier
extension View {
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        _ transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies a light shadow to a view
    /// Mainly used for a `Item Card View`
    /// - Returns: The `View` with applied shadow
    func cardShadow(
        radius: CGFloat = 10,
        y: CGFloat = 2,
        opacity: Double = 0.1,
        scheme: ColorScheme
    ) -> some View {
        let color: Color = (scheme == .light) ? .black : .white
        return self
            .shadow(
                color: color.opacity(opacity),
                radius: radius,
                y: y
            )
    }
    
}

// MARK: Custom Corner Modifier
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
