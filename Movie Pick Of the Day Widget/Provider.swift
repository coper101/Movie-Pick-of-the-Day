//
//  Provider.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import WidgetKit
import Intents
import OSLog

struct Provider: IntentTimelineProvider {
    
    let widgetViewModel: WidgetViewModel
    
    typealias Entry = MovieEntry
    typealias Intent = MovieDescriptionIntent

    /// Show placeholder data before transitioning to show the actual data
    func placeholder(in context: Context) -> Entry {
        Logger.widgetProvider.debug("placeholder")
        
        return .init(
            date: .init(),
            dayPick: TestData.sampleMovieDay,
            hasTitle: true,
            hasSummary: true
        )
    }

    /// Show widget snapshot or preview before adding it to home screen
    func getSnapshot(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Entry) -> ()
    ) {
        Logger.widgetProvider.debug("getSnapshot")
        
        getNewEntry(
            for: configuration,
            date: Date(),
            completion: completion
        )
    }

    /// Set the time when the data of widget will be updated
    func getTimeline(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        Logger.widgetProvider.debug("getTimeline")
        
        let currentDate = Date()
        getNewEntry(
            for: configuration,
            date: currentDate
        ) { entry in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            Logger.widgetProvider.debug("timeline: \(timeline.entries)")
            completion(timeline)
        }
    }
    
}

extension Provider {
        
    func getNewEntry(
        for configuration: Intent,
        date: Date,
        completion: @escaping (Entry) -> Void
    ) -> Void {
        let dayPick = widgetViewModel.getMoviePick()
        
        switch configuration.movieDescription {
        case .title:
            completion(
                .init(
                    date: Date(),
                    dayPick: dayPick,
                    hasTitle: true,
                    hasSummary: false
                )
            )
        case .summary:
            completion(
                .init(
                    date: Date(),
                    dayPick: dayPick,
                    hasTitle: false,
                    hasSummary: true
                )
            )
        default:
            completion(
                .init(
                    date: Date(),
                    dayPick: dayPick,
                    hasTitle: true,
                    hasSummary: true
                )
            )
        }
        
    }
    
}
