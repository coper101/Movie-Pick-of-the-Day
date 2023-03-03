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

// MARK: Alignment Modifier
struct CenterAlignmentModifier: ViewModifier {
    // MARK: - Props
    
    // MARK: - UI
    func body(content: Content) -> some View {
        content
            .fillMaxSize(alignment: .center)
            .opacity(0.5)
            .padding(.top, 50)
    }
}

extension View {
    
    func alignToCenter() -> some View {
        modifier(CenterAlignmentModifier())
    }
}

// MARK: Custom Corner Modifier
struct CornerRadiusStyle: ViewModifier {
    // MARK: - Props
    var radius: CGFloat
    var corners: UIRectCorner

    // MARK: - UI
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

// MARK: Dynamic Overlay Modifier
struct DynamicOverlayModifier<TheContent>: ViewModifier where TheContent: View {
    // MARK: - Props
    var alignment: Alignment
    var theContent: () -> TheContent
    
    // MARK: - UI
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 15.0, *) {
                content.overlay(alignment: alignment, content: theContent)
            } else {
                content.overlay(theContent(), alignment: alignment)
            }
        }
    }
}

extension View {
    
    func dynamicOverlay(alignment: Alignment, _ theContent: @escaping () -> some View) -> some View {
        modifier(
            DynamicOverlayModifier(
                alignment: alignment,
                theContent: theContent
            )
        )
    }
}

// MARK: Slow Pop Animation
struct SlowPopAnimationModifier: ViewModifier {
    // MARK: - Props
    @State private var isAnimating: Bool = false
    
    // MARK: - UI
    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? 1 : 0)
            .scaleEffect(isAnimating ? 1 : 0.8)
            .onAppear {
                withAnimation(.slowPop()) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    
    func withSlowPopAnimation() -> some View {
        modifier(SlowPopAnimationModifier())
    }
}

// MARK: Skeleton Loading Loading Animation
struct SkeletonLoadingAnimationModifier: ViewModifier {
    // MARK: - Props
    @State private var isAnimating: Bool = false
    var opacity: Double
    
    // MARK: - UI
    func body(content: Content) -> some View {
        content
            .dynamicOverlay(alignment: .center) {
                GeometryReader { geometry in
                    
                    let width = geometry.size.width
                    
                    LinearGradient(
                        colors: [
                            .clear,
                            Colors.onBackground.color.opacity(opacity),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: isAnimating ? width : -width)
                    .transition(.opacity.animation(.easeInOut))
                    
                } //: GeometryReader
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: false)
                        
                    ) {
                        isAnimating = true
                    }
                } //: onAppear
            } //: dynamicOverlay
    }
}

extension View {
    
    func withSkeletonLoadingAnimation(opacity: Double = 0.05) -> some View {
        modifier(SkeletonLoadingAnimationModifier(opacity: opacity))
    }
}

// MARK: Moving Animation
struct MovingUpAndDownAnimation: ViewModifier {
    // MARK: - Props
    @State private var isAnimating: Bool = false
    
    // MARK: - UI
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? 130 : -130)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 40.0)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    
    func withMovingUpAndDownAnimation() -> some View {
        modifier(MovingUpAndDownAnimation())
    }
}

// MARK: - Snap Pop Animation
struct SnapPopAnimation: ViewModifier {
    // MARK: - Props
    @State private var isAnimating: Bool = false
    
    // MARK: - UI
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1 : 0.65)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    
    func withSnapPopAnimation() -> some View {
        modifier(SnapPopAnimation())
    }
}


