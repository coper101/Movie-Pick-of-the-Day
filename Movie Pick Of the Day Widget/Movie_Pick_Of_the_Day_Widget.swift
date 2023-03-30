//
//  Movie_Pick_Of_the_Day_Widget.swift
//  Movie Pick Of the Day Widget
//
//  Created by Wind Versi on 23/3/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Movie_Pick_Of_the_Day_Widget: Widget {
    // MARK: - Props
    private let supportedFamilies: [WidgetFamily] = {
        var family: [WidgetFamily] = [.systemSmall, .systemMedium]
        return family
    }()

    // MARK: - UI
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: WidgetKind.main.name,
            intent: MovieDescriptionIntent.self,
            provider: Provider(widgetViewModel: .init())
        ) { entry in
            WidgetView(
                dayPick: entry.dayPick,
                hasTitle: entry.hasTitle,
                hasSummary: entry.hasSummary,
                uiImage: entry.uiImage
            )
        }
        .configurationDisplayName("Today")
        .description("Movie Picked for You")
        .supportedFamilies(supportedFamilies)
    }
}

// MARK: - Preview
struct Movie_Pick_Of_the_Day_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(
            dayPick: TestData.sampleMovieDay,
            hasTitle: true,
            hasSummary: true,
            uiImage: UIImage(named: "sample-poster")
        )
        .previewDisplayName("System Small")
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WidgetView(
            dayPick: TestData.sampleMovieDay,
            hasTitle: true,
            hasSummary: true,
            uiImage: UIImage(named: "sample-poster")
        )
        .previewDisplayName("System Medium")
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
