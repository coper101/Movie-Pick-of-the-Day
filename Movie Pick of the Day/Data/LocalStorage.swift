//
//  LocalStorage.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 7/1/23.
//

import Foundation

class LocalStorage {
    
    static func getUserDefaults() -> UserDefaults? {
        .standard
    }
    
    static func setItem(_ value: Any?, forKey key: Keys) {
        guard let defaults = getUserDefaults() else {
            return
        }
        defaults.set(value, forKey: key.rawValue)
    }

    static func getDictionary(forKey key: Keys) -> [Int: Int]? {
        guard let defaults = getUserDefaults() else {
            return nil
        }
        let dictionary = defaults.object(forKey: key.rawValue) as? [Int: Int]
        return dictionary
    }
    
    static func getDictionary(forKey key: Keys) -> [String: Any]? {
        guard let defaults = getUserDefaults() else {
            return nil
        }
        let dictionary = defaults.object(forKey: key.rawValue) as? [String: Any]
        return dictionary
    }

}
