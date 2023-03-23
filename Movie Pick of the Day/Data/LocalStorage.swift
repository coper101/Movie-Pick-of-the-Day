//
//  LocalStorage.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import Foundation

enum AppGroup: String {
    case main = "group.com.penguinworks.Movie-Pick-Of-The-Day"
    var groupIdentifier: String {
        self.rawValue
    }
}

class LocalStorage {
    
    static func getUserDefaults() -> UserDefaults? {
        .init(suiteName: AppGroup.main.groupIdentifier)
    }
    
    // Data
    static func setData(_ data: Data, forKey key: Keys) {
        guard let defaults = getUserDefaults() else {
            return
        }
        defaults.set(data, forKey: key.rawValue)
    }
    
    static func getData(forKey key: Keys) -> Data? {
        guard let defaults = getUserDefaults() else {
            return nil
        }
        return defaults.data(forKey: key.rawValue)
    }
    
    // Any Object - dates
    static func setItem(_ value: Any?, forKey key: Keys) {
        guard let defaults = getUserDefaults() else {
            return
        }
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func getItem(forKey key: Keys) -> Any? {
        guard let defaults = getUserDefaults() else {
            return nil
        }
        return defaults.object(forKey: key.rawValue)
    }

    // Dictionary
    static func getDictionary(forKey key: Keys) -> [String: Int]? {
        guard let defaults = getUserDefaults() else {
            return nil
        }
        let dictionary = defaults.object(forKey: key.rawValue) as? [String: Int]
        return dictionary
    }
    
    static func getDictionary(forKey key: Keys) -> [String: Any]? {
        guard let defaults = getUserDefaults() else {
            return nil
        }
        let dictionary = defaults.object(forKey: key.rawValue) as? [String: Any]
        return dictionary
    }

    // Integer
    static func getInt(forKey key: Keys) -> Int {
        guard let defaults = getUserDefaults() else {
            return 0
        }
        return defaults.integer(forKey: key.rawValue)
    }
}
