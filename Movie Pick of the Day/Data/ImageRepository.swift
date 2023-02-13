//
//  ImageRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 13/2/23.
//

import Foundation
import SwiftUI
import OSLog
import Combine

enum Phase {
    case loading
    case failed
    case successful
}

class ImageRepository: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()

    let path: String?
    let resolution: ImageResolution
    var imageCache: ImageCache
    
    @Published var uiImage: UIImage?
    @Published var phase: Phase = .loading
    
    init(
        path: String?,
        resolution: ImageResolution,
        imageCache: ImageCache
    ) {
        self.path = path
        self.resolution = resolution
        self.imageCache = imageCache
        
        getUIImage()
    }
    
    func getUIImage() {
        guard let path else {
            return
        }
        Logger.imageRepository.debug("getUIImage - path: \(path)")
        
        // load image from cache
        let key = "\(path)/\(resolution.rawValue)"
        if let uiImage = imageCache[key] {
            self.uiImage = uiImage
            self.phase = .successful
            return
        }
        
        // load image from remote
        Networking.requestImage(
            request: GetImage(imageResolution: resolution, posterPath: path)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                Logger.imageRepository.debug("getUIImage - failure")
                
                if error is NetworkError {
                    let networkError = error as! NetworkError
                    switch networkError {
                    case .server(let message):
                        Logger.imageRepository.debug("getUIImage - server error: \(message)")
                    case .request(let message):
                        Logger.imageRepository.debug("getUIImage - request error: \(message)")
                    default:
                        break
                    }
                }
                
                self?.phase = .failed
                
            case .finished:
                Logger.imageRepository.debug("getUIImage - finished")
            }
        } receiveValue: { [weak self] uiImage in
            Logger.imageRepository.debug("getUIImage - success")

            guard let self else {
                return
            }
            self.uiImage = uiImage
            self.phase = .successful
            self.imageCache[key] = uiImage
        }
        .store(in: &subscriptions)
    }
    
}
