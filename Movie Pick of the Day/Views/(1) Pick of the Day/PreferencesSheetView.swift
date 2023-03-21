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
    
    var isLoadingGenres: Bool
    var isLoadingLanguages: Bool
    
    var hasFailedLoadingGenres: Bool
    var hasFailedLoadingLanguages: Bool

    var genresOptions: [String]
    var languagesOptions: [String]
    
    var noInternetConnection: Bool
    
    var closeAction: Action
    var doneAction: Action
        
    let topBarHeight: CGFloat = 54
    
    // MARK: - UI
    var topBar: some View {
        VStack(spacing: 0) {
            
            // Row 1: TITLE
            HStack(spacing: 0) {
                
                Text("Preferences")
                    .textStyle(font: .interBold, size: 24)
                    .opacity(0.45)
                
                Spacer()
                
                CloseButtonView(
                    hasBlurEffect: false,
                    action: closeAction
                )
                
            } //: HStack
            .padding(.top, 16)
            .background(Colors.background.color)
            
            // Row 2: BACKGROUND
            DisappearingGradientView(
                contentDirection: .top,
                color: .background
            )
            .frame(height: 24)

        } //: ZStack
    }
    
    var selections: some View {
        ScrollView(showsIndicators: false) {

            LazyVStack(spacing: 34) {
                
                // OPTION 1: ADULT MOVIE
                SelectionChipsView(
                    isYes: $isAdultSelected,
                    selected: .constant(""),
                    selections: .constant([]),
                    title: "Include Adult"
                )
                .padding(.top, 54 + 24)
                
                // SELECTION 2: GENRE
                SelectionChipsView(
                    isYes: .constant(false),
                    selected: .constant(""),
                    selections: $genresSelection,
                    options: genresOptions,
                    isLoadingOptions: isLoadingGenres,
                    hasLoadingFailed: hasFailedLoadingGenres,
                    title: "Genre"
                )
                
                // SELECTION 3: LANGUAGE
                SelectionChipsView(
                    isYes: .constant(false),
                    selected: $languageSelected,
                    selections: .constant([]),
                    options: languagesOptions,
                    isLoadingOptions: isLoadingLanguages,
                    isSingleSelection: true,
                    hasLoadingFailed: hasFailedLoadingLanguages,
                    title: "Language"
                )
                
                Spacer()

            } //: VStack
            .padding(.bottom, 100)
            
        } //: ScrollView
    }
    
    var doneButton: some View {
        VStack(spacing: 0) {
            
            DisappearingGradientView(
                contentDirection: .bottom,
                color: .background
            )
            .frame(height: 42)
            
            HStack {
                
                FilledButtonView(
                    title: noInternetConnection ? "No Internet" : "Done",
                    icon: noInternetConnection ? .warning : nil,
                    isDisabled: noInternetConnection,
                    action: doneAction
                )
                
            } //: HStack
            .padding(.bottom, dimensions.insets.bottom + 12)
            .background(Colors.background.color)
            
        } //: VStack
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // MARK: - L1: Sheet Content
            ZStack(alignment: .top) {
                                
                selections
                
                topBar
                
            } //: VStack
            .padding(.leading, 21)
            .padding(.trailing, 12)
            .fillMaxSize()
                            
            // MARK: - L2: Done Button
            doneButton
                            
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
struct PreferencesSheet_Previews: PreviewProvider {
    static var genres = TestData.sampleGenres.compactMap(\.name)
    static var languages = TestData.sampleLanguages.compactMap(\.englishName)
    
    static var previews: some View {
        PreferencesSheetView(
            genresSelection: .constant([]),
            languageSelected: .constant(""),
            isAdultSelected: .constant(false),
            isLoadingGenres: false,
            isLoadingLanguages: false,
            hasFailedLoadingGenres: false,
            hasFailedLoadingLanguages: false,
            genresOptions: genres,
            languagesOptions: languages,
            noInternetConnection: true,
            closeAction: {},
            doneAction: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Loaded Selections")
        
        PreferencesSheetView(
            genresSelection: .constant([]),
            languageSelected: .constant(""),
            isAdultSelected: .constant(false),
            isLoadingGenres: true,
            isLoadingLanguages: true,
            hasFailedLoadingGenres: false,
            hasFailedLoadingLanguages: false,
            genresOptions: [],
            languagesOptions: [],
            noInternetConnection: false,
            closeAction: {},
            doneAction: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Loading Selections")
        
        PreferencesSheetView(
            genresSelection: .constant([]),
            languageSelected: .constant(""),
            isAdultSelected: .constant(false),
            isLoadingGenres: false,
            isLoadingLanguages: false,
            hasFailedLoadingGenres: true,
            hasFailedLoadingLanguages: true,
            genresOptions: [],
            languagesOptions: [],
            noInternetConnection: false,
            closeAction: {},
            doneAction: {}
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Failed to Load Selections")
    }
}
