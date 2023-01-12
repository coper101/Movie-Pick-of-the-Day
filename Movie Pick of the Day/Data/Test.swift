//
//  Test.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation
import UIKit

class TestData {
    
    static func createMovie(id: Int) -> Movie {
        .init(
            id: id,
            title: nil,
            originalTitle: nil,
            overview: nil,
            releaseDate: nil,
            voteAverage: nil,
            voteCount: nil,
            popularity: nil,
            genreIDs: nil,
            adult: nil,
            video: nil,
            originalLanguage: nil,
            posterPath: nil,
            backdropPath: nil
        )
    }
    
    static func createMovieDay(movieID: Int, day: Day) -> MovieDay {
        .init(day: day, id: movieID)
    }
    
    static func createImage(
        color: UIColor = .black,
        width: CGFloat = 1080,
        height: CGFloat = 1920
    ) -> UIImage {
        .init(
            color: color,
            size: .init(width: width, height: height)
        )!
    }
}

extension UIImage {
    
  convenience init?(
    color: UIColor,
    size: CGSize
  ) {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    
      guard let cgImage = image?.cgImage else {
          return nil
      }
      self.init(cgImage: cgImage)
  }
    
}
