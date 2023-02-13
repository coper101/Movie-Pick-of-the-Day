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
    var isResizable: Bool = false
    var isScaledToFill: Bool = false
    var scaleEffect: CGFloat = 1
    
    init(
        imageCache: ImageCache,
        path: String?,
        resolution: ImageResolution,
        isResizable: Bool = false,
        isScaledToFill: Bool = false,
        scaleEffect: CGFloat = 1,
        paddingTop: @escaping PaddingTop = { _ in 0 }
    ) {
        self._imageRepository = .init(
            wrappedValue: .init(path: path, resolution: resolution, imageCache: imageCache)
        )
        self.paddingTop = paddingTop
        self.isResizable = isResizable
        self.isScaledToFill = isScaledToFill
    }
    
    // MARK: - UI
    var body: some View {
        switch imageRepository.phase {
        case .successful:
            image
        case .failed:
            Color.black
        case .loading:
            Color.black
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
                    .padding(.top, paddingTop(uiImage.size))
            } else {
                Image(uiImage: placeholderUiImage)
            }
        }
    } //: image
}
