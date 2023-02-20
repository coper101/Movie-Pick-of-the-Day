//
//  AsyncImageView.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 13/2/23.
//

import SwiftUI

typealias PaddingTop = (CGSize) -> CGFloat

struct AsyncImageView: View {
    // MARK: - Props
    @StateObject var imageRepository: ImageRepository
    
    let paddingTop: PaddingTop
    let placeholderUiImage = TestData.createImage(color: .black, width: 1083, height: 1539)
    let placeholderTitle: String
    
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
        paddingTop: @escaping PaddingTop = { _ in 0 }
    ) {
        self._imageRepository = .init(
            wrappedValue: .init(path: path, resolution: resolution, imageCache: imageCache)
        )
        self.paddingTop = paddingTop
        self.placeholderTitle = placeholderTitle
        
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
                    .padding(.top, paddingTop(uiImage.size))
            } else {
                NoImageView(title: placeholderTitle)
                    .transition(.opacity.animation(.easeIn(duration: 1.0)))
            }
        }
    } //: image
}
