//
//  Entry.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import WidgetKit
import SwiftUI

struct MovieEntry: TimelineEntry {
    let date: Date
    let dayPick: MovieDay?
    let uiImage: UIImage?
    let hasTitle: Bool
    let hasSummary: Bool
}
