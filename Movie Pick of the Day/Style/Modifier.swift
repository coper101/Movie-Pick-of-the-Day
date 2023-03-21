//
//  Modifier.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

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
    
    func alignToCenter() -> some View {
        modifier(CenterAlignmentModifier())
    }
    
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    
    // MARK: Animations
    func withSlowPopAnimation() -> some View {
        modifier(SlowPopAnimationModifier())
    }

    func withSkeletonLoadingAnimation(opacity: Double = 0.05) -> some View {
        modifier(SkeletonLoadingAnimationModifier(opacity: opacity))
    }

    func withMovingUpAndDownAnimation() -> some View {
        modifier(MovingUpAndDownAnimation())
    }

    func withSnapPopAnimation() -> some View {
        modifier(SnapPopAnimation())
    }
    
    func withSlideUpAnimation(yOffset: CGFloat) -> some View {
        modifier(SlideUpAnimation(yOffset: yOffset))
    }
    
    func withScaleAndPopAnimation(originalScale: CGFloat) -> some View {
        modifier(ScaleAndPopAnimation(originalScale: originalScale))
    }
    
    // MARK: Styles
    func withScaleButtonStyle(minScale: CGFloat) -> some View {
        self.buttonStyle(ScaleButtonStyle(minScale: minScale))
    }
    
    // MARK: Dynamic iOS Support
    func dynamicOverlay(
        alignment: Alignment,
        _ theContent: @escaping () -> some View
    ) -> some View {
        modifier(
            DynamicOverlayModifier(
                alignment: alignment,
                theContent: theContent
            )
        )
    }
    
    func dynamicMask(
        alignment: Alignment = .center,
        _ theContent: @escaping () -> some View
    ) -> some View {
        modifier(
            DynamicMask(alignment: alignment, theContent: theContent)
        )
    }
}



struct CenterAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fillMaxSize(alignment: .center)
            .opacity(0.5)
            .padding(.top, 50)
    }
}



struct CornerRadiusStyle: ViewModifier {
    // MARK: Props
    var radius: CGFloat
    var corners: UIRectCorner

    // MARK: UI
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



struct SlowPopAnimationModifier: ViewModifier {
    // MARK: Props
    @State private var isAnimating: Bool = false
    
    // MARK: UI
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



struct SkeletonLoadingAnimationModifier: ViewModifier {
    // MARK: Props
    @State private var isAnimating: Bool = false
    var opacity: Double
    
    // MARK: UI
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



struct MovingUpAndDownAnimation: ViewModifier {
    // MARK: Props
    @State private var isAnimating: Bool = false
    
    // MARK: UI
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



struct SnapPopAnimation: ViewModifier {
    // MARK: Props
    @State private var isAnimating: Bool = false
    
    // MARK: UI
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



struct SlideUpAnimation: ViewModifier {
    // MARK: Props
    @State private var isAnimating: Bool = false
    var yOffset: CGFloat
    
    // MARK: UI
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? 0 : yOffset)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                    isAnimating = true
                }
            }
    }
}



struct ScaleAndPopAnimation: ViewModifier {
    // MARK: Props
    @State private var isAnimating: Bool = false
    var originalScale: CGFloat
    
    // MARK: UI
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? originalScale : 0.65)
            .onAppear {
                withAnimation(
                    .spring(response: 0.8, dampingFraction: 0.7)
                    .delay(0.1)
                ) {
                    isAnimating = true
                }
            }
    }
}


struct DynamicOverlayModifier<TheContent>: ViewModifier where TheContent: View {
    // MARK: Props
    var alignment: Alignment
    var theContent: () -> TheContent
    
    // MARK: UI
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



struct DynamicMask<TheContent>: ViewModifier where TheContent: View {
    // MARK: Props
    var alignment: Alignment
    @ViewBuilder var theContent: TheContent
    
    // MARK: UI
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 15.0, *) {
                content.mask(alignment: alignment) { theContent }
            } else {
                content.mask(theContent)
            }
        }
    }
}

