//
//  MovieFilmView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/3/23.
//

import SwiftUI

struct MovieFilmView: View {
    // MARK: - Props
    @State private var isAnimating: Bool = false
    
    // MARK: - UI
    var filmBox: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Colors.onBackground.color)
    }
    
    var film: some View {
        VStack(spacing: 10) {
            
            HStack(spacing: 11) {
                
                ForEach(1...10, id: \.self) { _ in
                    filmBox
                        .frame(width: 25, height: 26)
                }
            }
            .offset(x: 5)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { _ in
                    filmBox
                        .frame(width: 60, height: 81)
                }
            }
            
            HStack(spacing: 11) {
                
                ForEach(1...10, id: \.self) { _ in
                    filmBox
                        .frame(width: 25, height: 26)
                }
            }
            .offset(x: 5)

        } //: VStack
    }
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        .white.opacity(0),
                        .white.opacity(0.05),
                        .white.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask(film)
            .onAppear {
                withAnimation {
                    isAnimating.toggle()
                }
            }
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct MovieFilmView_Previews: PreviewProvider {
    static var previews: some View {
        MovieFilmView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
    }
}
