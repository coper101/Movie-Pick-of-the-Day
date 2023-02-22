//
//  SearchingView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 22/2/23.
//

import SwiftUI

struct SearchingView: View {
    // MARK: - Props
    @Environment(\.dimensions) var dimensions
    @State private var isAnimating: Bool = false
    
    // MARK: - UI
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: .init(.flexible()),
                    count: 2
                ),
                spacing: 30
            ) {
                
                ForEach(1..<7, id: \.self) { i in
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            Colors.onBackgroundLight.color
                                .opacity(isAnimating ? 1 : 0.6)
                        )
                        .frame(height: 164)
                        .fillMaxWidth()
                        .padding(.horizontal, 16)
                        .cardShadow(y: 5, opacity: 0.05)
                        .animation(
                            .easeInOut(duration: 0.65).delay(0.1).repeatForever(),
                            value: isAnimating
                        )
                 
                } //: ForEach
                
            } //: LazyVGrid
            .padding(.top, 74 + dimensions.insets.top)
            .fillMaxSize(alignment: .top)
            .padding(.horizontal, 24)
            .padding(.bottom, 45)
            .onAppear(perform: didAppear)
            
        } //: ScrollView
        .disabled(true)
        .dynamicOverlay(alignment: .bottom) {
            DisappearingGradientView(
                contentDirection: .bottom,
                color: .background
            )
            .frame(height: 45)
        }
    }
    
    // MARK: - Actions
    func didAppear() {
        withAnimation {
            isAnimating = true
        }
    }
}

// MARK: - Preview
struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView()
            .previewLayout(.sizeThatFits)
            .frame(height: 750)
            .previewLayout(.sizeThatFits)
            .environmentObject(ImageCacheRepository())
            .background(Colors.background.color)
    }
}
