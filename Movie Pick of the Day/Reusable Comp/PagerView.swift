//
//  PagerView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 1/2/23.
//

import SwiftUI

struct PagerView<Content, Content2>: View where Content: View, Content2: View {
    // MARK: - Props
    @State private var selectedItem: PagerItem = .item1
    var item1Action: Action
    var item2Action: Action
    var bottomPadding: CGFloat = 0
    @ViewBuilder var item1Content: Content
    @ViewBuilder var item2Content: Content2
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Layer 1: CONTENT
            if selectedItem == .item1 {
                item1Content
                    .fillMaxSize()
            } else {
                item2Content
                    .fillMaxSize()
            }
            
            // Layer 2: PAGER SELECTION
            PagerTabView(selectedItem: $selectedItem)
                .onChange(of: selectedItem) { item in
                    switch item {
                    case .item1:
                        item1Action()
                    case .item2:
                        item2Action()
                    }
                }
                .padding(.bottom, bottomPadding)
            
        } //: ZStack
    }
    
    // MARK: - Actions
}

// MARK: - Preview
struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        PagerView(
            item1Action: {},
            item2Action: {},
            item1Content: { Text("Content 1") },
            item2Content: { Text("Content 2") }
        )
            .previewLayout(.sizeThatFits)
            // .background(Colors.Background)
    }
}
