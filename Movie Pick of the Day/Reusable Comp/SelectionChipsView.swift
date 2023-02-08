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
    var isSingleSelection: Bool = false
    
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
            
            // Row 2: OPTIONS
            // Text("selections: \(selections.debugDescription)")
            
            if !options.isEmpty {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    let maxOptionsPerRow = 3
                    let optionRowsCount = (Double(options.count) / Double(maxOptionsPerRow)).rounded(.up)
                    let optionsCount = options.count
                    
                    ForEach(1...Int(optionRowsCount), id: \.self) { rowIndex in
                        
                        let maxRowCount = rowIndex * maxOptionsPerRow
                        let maxRowCountIndex = maxRowCount - 1
                        let maxDif = optionsCount - maxRowCount
                        
                        HStack(spacing: 12) {
                            
                            let maxOptionIndex = (maxDif >= 0) ? maxRowCountIndex : optionsCount - 1
                            let firstOptionIndex = maxRowCountIndex - 2
                            
                            ForEach(firstOptionIndex...maxOptionIndex, id: \.self) { index in
                                
                                let title = options[index]
                                
                                ChipOptionView(
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

            if options.isEmpty {
                ChipToggleView(isYes: $isYes)
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
    
    static var previews: some View {
        SelectionChipsView(
            isYes: .constant(true),
            selected: .constant(""),
            selections: .constant([]),
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
    }
}
