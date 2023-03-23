//
//  WidgetView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    // MARK: - Props
    @Environment(\.widgetFamily) var widgetFamily
    var dayPick: MovieDay
    var hasTitle: Bool
    var hasSummary: Bool
    
    // MARK: - UI
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            WidgetMovieView(
                dayPick: dayPick,
                hasTitle: hasTitle,
                hasSummary: hasSummary
            )
        case .systemMedium:
            WidgetMovieView(
                dayPick: dayPick,
                hasTitle: hasTitle,
                hasSummary: hasSummary
            )
        default:
            WidgetMovieView(
                dayPick: dayPick,
                hasTitle: hasTitle,
                hasSummary: hasSummary
            )
        }
    }
}

