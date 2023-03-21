//
//  Movie_Pick_of_the_DayApp.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import SwiftUI

@main
struct Movie_Pick_of_the_DayApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var imageCacheRepo = ImageCacheRepository()
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(appViewModel)
                .environmentObject(imageCacheRepo)
        }
    }
}
