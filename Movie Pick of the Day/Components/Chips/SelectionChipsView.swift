//
//  SelectionChipsView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/2/23.
//

import SwiftUI

struct SelectionChipsView: View {
    // MARK: - Props
    @Binding var isYes: Bool
    @Binding var selected: String
    @Binding var selections: [String]
    
    var options: [String] = []
    var isLoadingOptions = false
    var isSingleSelection: Bool = false
    var hasLoadingFailed: Bool = false
    
    var title: String
    
    // MARK: - UI
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Row 1: TITLE
            HStack {
                
                Text(title)
                    .textStyle(
                        font: .interBold,
                        size: 16
                    )
                    .opacity(0.45)
                
                Spacer()
                
            } //: HStack
            
            // MARK: State - A. Loading
            if isLoadingOptions {
                HStack(spacing: 12) {
                    ForEach(1..<3, id: \.self) { _ in
                        ChipOptionView(
                            isSelected: false,
                            isLoading: true,
                            title: "",
                            isSingleSelected: false,
                            toggleAction: { _ in }
                        )
                    } //: ForEach
                } //: HStack
            }
            
            // MARK: State - B1. Loaded (Single Selection / Multi-Selection)
            if !options.isEmpty {
                
                LazyVStack(alignment: .leading, spacing: 12) {
                    
                    let maxOptionsPerRow = 3
                    let optionRowsCount = (Double(options.count) / Double(maxOptionsPerRow)).rounded(.up)
                    let optionsCount = options.count
                    
                    ForEach(1...Int(optionRowsCount), id: \.self) { rowIndex in
                        
                        let maxRowCount = rowIndex * maxOptionsPerRow
                        let maxRowCountIndex = maxRowCount - 1
                        let maxDif = optionsCount - maxRowCount
                        
                        LazyHStack(spacing: 12) {
                            
                            let maxOptionIndex = (maxDif >= 0) ? maxRowCountIndex : optionsCount - 1
                            let firstOptionIndex = maxRowCountIndex - 2
                            
                            ForEach(firstOptionIndex...maxOptionIndex, id: \.self) { index in
                                
                                let title = options[index]
                                
                                ChipOptionView(
                                    isSelected: selections.first(where: { $0 == title }) != nil,
                                    isLoading: false,
                                    title: title,
                                    isSingleSelected: isSingleSelection ? title == selected : nil,
                                    toggleAction: { isSelected in
                                        onChangeSelection(
                                            for: index,
                                            isSelected: isSelected,
                                            singleSelection: isSingleSelection,
                                            selections: &selections,
                                            selected: &selected
                                        )
                                    }
                                )
                            } //: ForEach
                            
                        } //: HStack
                        
                    } //: ForEach
                    
                } //: VStack
                
            } //: if-check-empty
            
            // MARK: State - B2. Loaded (Yes / No Selection)
            if options.isEmpty && !isLoadingOptions && !hasLoadingFailed {
                ChipToggleView(isYes: $isYes)
            }
            
            // MARK: State - C. Failed
            if hasLoadingFailed {
                Text("Couldn't load \(title.lowercased())s at the moment")
                    .textStyle(
                        foregroundColor: .onBackground,
                        font: .interBold,
                        size: 14
                    )
                    .opacity(0.2)
            }

          
        } //: VStack
    }
    
    // MARK: - Actions
    func onChangeSelection(
        for index: Int,
        isSelected: Bool,
        singleSelection: Bool,
        selections: inout [String],
        selected: inout String
    ) {
        let option = options[index]
        
        // A. Single Selection
        if singleSelection {
            selected = option
            return
        }
        
        // B. Multi Selection
        // add to list
        if isSelected {
            selections.append(option)
            return
        }
        // remove from list
        selections.removeAll(where: { $0 == option })
    }
}

// MARK: - Preview
struct SelectionChipsView_Previews: PreviewProvider {
    static var options = TestData.sampleGenres.compactMap(\.name)
    static var selections: [String] {
        [ options[0], options[1] ]
    }
    
    static var previews: some View {
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant(selections),
            options: options,
            title: "Genres"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Multi Selection")
        
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
            options: [],
            isLoadingOptions: true,
            title: "Genres"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Multi Selection / Loading")
        
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
            title: "Adult Movie"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Single Selection")
        
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
            options: options,
            isSingleSelection: true,
            title: "Language"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Single Selection")
        
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
            options: [],
            isLoadingOptions: true,
            isSingleSelection: true,
            title: "Language"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Single Selection / Loading")
        
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
            options: [],
            isLoadingOptions: false,
            hasLoadingFailed: true,
            title: "Genre"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Multi Selection / Failed")
        
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
            options: [],
            isLoadingOptions: false,
            isSingleSelection: true,
            hasLoadingFailed: true,
            title: "Language"
        )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Colors.background.color)
            .previewDisplayName("Single Selection / Failed")
    }
}
