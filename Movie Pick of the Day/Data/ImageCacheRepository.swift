//
//  ImageCacheRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 13/2/23.
//

import UIKit
import OSLog

// MARK: Protocol
protocol ImageCache {
    subscript(_ key: String) -> UIImage? { get set }
}

// MARK: App Implementation
final class ImageCacheRepository: ImageCache, ObservableObject {
                             
    private let cache = NSCache<NSString, UIImage>()
    
    // key: path + resolution
    // e.g. /<thePath>/<w500 or original>
    subscript(_ key: String) -> UIImage? {
        get {
            // cache[key]
            cache.object(forKey: key as NSString)
        }
        set {
            // cache[key] = UIImage? (remove image if nil)
            let key = key as NSString
            
            if let newValue {
                cache.setObject(newValue, forKey: key)
                Logger.imageCacheRepository.debug("added image for key \(key)")
                return
            }
            cache.removeObject(forKey: key)
            Logger.imageCacheRepository.debug("removed image for key \(key)")
        }
    }
}
