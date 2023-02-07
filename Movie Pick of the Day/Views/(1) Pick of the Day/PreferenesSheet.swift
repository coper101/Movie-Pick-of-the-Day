//
//  PreferenesSheet.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct PreferenesSheet: View {
    // MARK: - Props
    
    // MARK: - UI
    var body: some View {
        GeometryReader { geometry in
            
            Color.black.opacity(0.4)
            
            let height = geometry.size.height
            
            ZStack {
                
                VStack(spacing: 0) {
                    
                    // TITLE
                    HStack(spacing: 0) {
                        
                        Text("Preferences")
                            .textStyle(font: .interBold, size: 24)
                            .opacity(0.45)
                        
                        Spacer()
                        
                        CloseButtonView(action: closeAction)
                        
                    } //: HStack
                    
                    // SELECTION 1: GENRE
                    
                    
                    // SELECTION 2: LANGUAGE
                    
                    // OPTION 3: ADULT MOVIE

                    
                } //: VStack
                .padding(.horizontal, 21)
                .fillMaxSize()
                .overlay(
                    
                    // ACTION
                    FilledButtonView(
                        title: "Done",
                        action: doneAction
                    )
                    .padding(.bottom, 24),
                    
                    alignment: .bottom
                )
                
            } //: ZStack
            .frame(height: height * 0.7)
            .fillMaxWidth()
            .background(Colors.background.color)
        }
    }
    
    // MARK: - Actions
    func doneAction() {
        
    }
    
    func closeAction() {
        
    }
}

// MARK: - Preview
struct PreferenesSheet_Previews: PreviewProvider {
    static var previews: some View {
        PreferenesSheet()
            .previewLayout(.sizeThatFits)
            // .background(Colors.Background)
    }
}
