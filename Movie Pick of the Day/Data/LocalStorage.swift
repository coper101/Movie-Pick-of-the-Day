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

}
