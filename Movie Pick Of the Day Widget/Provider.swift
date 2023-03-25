//
//  Provider.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import SwiftUI
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
            uiImage: UIImage(named: "sample-poster"),
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
        
        getNewEntry(for: configuration, completion: completion)
    }

    /// Set the time when the data of widget will be updated
    func getTimeline(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        Logger.widgetProvider.debug("getTimeline")
        
        getNewEntry(for: configuration) { entry in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            Logger.widgetProvider.debug("timeline: \(timeline.entries)")
            completion(timeline)
        }
    }
    
}

extension Provider {
        
    func getNewEntry(
        for configuration: Intent,
        completion: @escaping (Entry) -> Void
    ) -> Void {
        widgetViewModel.getMoviePickAndImage { dayPick, uiImage in
            switch configuration.movieDescription {
            case .title:
                completion(
                    .init(
                        date: Date(),
                        dayPick: dayPick,
                        uiImage: uiImage,
                        hasTitle: true,
                        hasSummary: false
                    )
                )
            case .summary:
                completion(
                    .init(
                        date: Date(),
                        dayPick: dayPick,
                        uiImage: uiImage,
                        hasTitle: false,
                        hasSummary: true
                    )
                )
            default:
                completion(
                    .init(
                        date: Date(),
                        dayPick: dayPick,
                        uiImage: uiImage,
                        hasTitle: true,
                        hasSummary: true
                    )
                )
            }
        }
    }
    
}
