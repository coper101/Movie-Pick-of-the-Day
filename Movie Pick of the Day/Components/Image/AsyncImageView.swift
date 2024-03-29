//
//  AsyncImageView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 13/2/23.
//

import SwiftUI

struct AsyncImageView: View {
    // MARK: - Props
    @StateObject var imageRepository: ImageRepository
    
    let placeholderTitle: String
    
    let hasMovingUpAndDownAnimation: Bool
    let hasScaleUpAnimation: Bool
    
    var path: String?
    var resolution: ImageResolution
    var showLoading: Bool
    
    var isResizable: Bool = false
    var isScaledToFill: Bool = false
    var scaleEffect: CGFloat = 1
    
    init(
        imageCache: ImageCache,
        path: String?,
        resolution: ImageResolution,
        showLoading: Bool = true,
        placeholderTitle: String,
        isResizable: Bool = false,
        isScaledToFill: Bool = false,
        scaleEffect: CGFloat = 1,
        hasMovingUpAndDownAnimation: Bool = false,
        hasScaleUpAnimation: Bool = false
    ) {
        self.path = path
        self._imageRepository = .init(
            wrappedValue: .init(path: path, resolution: resolution, imageCache: imageCache)
        )
        self.placeholderTitle = placeholderTitle
        self.hasMovingUpAndDownAnimation = hasMovingUpAndDownAnimation
        self.hasScaleUpAnimation = hasScaleUpAnimation
        
        self.resolution = resolution
        self.showLoading = showLoading
        
        self.isResizable = isResizable
        self.isScaledToFill = isScaledToFill
    }
    
    // MARK: - UI
    var body: some View {
        Group {
            switch imageRepository.phase {
            case .loading:
                if showLoading {
                    LoadingImageView()
                } else {
                    Color.black
                }
            case .successful:
                image
            case .failed:
                NoImageView(title: placeholderTitle)
            }
        } //: Group
        .transition(.opacity.animation(.easeIn(duration: 1.0)))
        .onChange(of: path) { newPath in
            imageRepository.path = newPath
            imageRepository.getUIImage()
        }
    }
    
    var image: some View {
        Group {
            if let uiImage = imageRepository.uiImage {
                Image(uiImage: uiImage)
                    .`if`(isResizable) {
                        $0.resizable()
                    }
                    .`if`(isScaledToFill) {
                        $0.scaledToFill()
                    }
                    .scaleEffect(scaleEffect)
                    .`if`(hasMovingUpAndDownAnimation) {
                        $0.withMovingUpAndDownAnimation()
                    }
                    .`if`(hasScaleUpAnimation) {
                        $0.withScaleAndPopAnimation(originalScale: scaleEffect)
                    }
            } else {
                NoImageView(title: placeholderTitle)
                    .transition(.opacity.animation(.easeIn(duration: 1.0)))
            }
        }
    } //: image
}
