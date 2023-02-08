//
//  Logging.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 8/2/23.
//

import OSLog

extension Logger {
    
    enum Category: String {
        // case widgetProvider = "widgetprovider"
        case movieRepository = "movierepository"
        case appModel = "appmodel"
        case network = "network"
    }
    
    // static let widgetProvider = createLogger(of: .widgetProvider)
    static let movieRepository = createLogger(of: .movieRepository)
    static let appModel = createLogger(of: .appModel)
    static let network = createLogger(of: .network)
    
    static func createLogger(of category: Category) -> Logger {
        let subsystem = Bundle.main.bundleIdentifier!
        return .init(subsystem: subsystem, category: category.rawValue)
    }
}
