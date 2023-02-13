//
//  PreferencesSheetView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct PreferencesSheetView: View {
    // MARK: - Props
    @Environment(\.dimensions) var dimensions: Dimensions
    @Binding var genresSelection: [String]
    @Binding var languageSelected: String
    @Binding var isAdultSelected: Bool
    
    var genresOptions: [String]
    var languagesOptions: [String]
    
    var closeAction: Action
    var doneAction: Action
        
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // MARK: Layer 1 - Sheet Content
            VStack(spacing: 12) {
                
                // TITLE
                HStack(spacing: 0) {
                    
                    Text("Preferences")
                        .textStyle(font: .interBold, size: 24)
                        .opacity(0.45)
                    
                    Spacer()
                    
                    CloseButtonView(action: closeAction)
                    
                } //: HStack
                .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {

                    LazyVStack(spacing: 34) {
                        
                        // SELECTION 1: GENRE
                        SelectionChipsView(
                            isYes: .constant(false),
                            selected: .constant(""),
                            selections: $genresSelection,
                            options: genresOptions,
                            title: "Genre"
                        )
                        
                        // SELECTION 2: LANGUAGE
                        SelectionChipsView(
                            isYes: .constant(false),
                            selected: $languageSelected,
                            selections: .constant([]),
                            options: languagesOptions,
                            isSingleSelection: true,
                            title: "Language"
                        )
                        
                        // OPTION 3: ADULT MOVIE
                        SelectionChipsView(
                            isYes: $isAdultSelected,
                            selected: .constant(""),
                            selections: .constant([]),
                            title: "Adult Movie"
                        )
                        
                        Spacer()

                    } //: VStack
                    .padding(.bottom, 100)
                    
                } //: ScrollView

                                    
            } //: VStack
            .padding(.leading, 21)
            .padding(.trailing, 12)
            .fillMaxSize()
                            
            // MARK: Layer 2 - Save
            HStack {
                FilledButtonView(
                    title: "Done",
                    action: doneAction
                )
            }
            .padding(.bottom, dimensions.insets.bottom)
            .background(Colors.background.color)
            
        } //: ZStack
        .frame(height: dimensions.screen.height * 0.85)
        .fillMaxWidth()
        .background(Colors.background.color)
        .cornerRadius(
            radius: 22,
            corners: [.topLeft, .topRight]
        )
    }
}

// MARK: - Preview
struct PreferenesSheet_Previews: PreviewProvider {
    static var genres = TestData.sampleGenres.compactMap(\.name)
    static var languages = TestData.sampleLanguages.compactMap(\.englishName)
    
    static var previews: some View {
        PreferencesSheetView(
            genresSelection: .constant([]),
            languageSelected: .constant(""),
            isAdultSelected: .constant(false),
            genresOptions: genres,
            languagesOptions: languages,
            closeAction: {},
            doneAction: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
