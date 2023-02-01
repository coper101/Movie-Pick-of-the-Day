//
//  Test.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation
import UIKit

class TestData {
    
    static func createMovie(
        id: Int,
        title: String? = nil,
        overview: String? = nil
    ) -> Movie {
        .init(
            id: id,
            title: title,
            originalTitle: nil,
            overview: overview,
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
    
    static let sampleMovie = createMovie(
        id: 101,
        title: "Avatar: The Way of Water",
        overview: """
                Set more than a decade after the events of the first film, learn the story of the Sully family (Jake, Neytiri, and their kids), the trouble that follows them, the lengths they go to keep each other safe, the battles they fight to stay alive, and the tragedies they endure.
                """
    )
    
    static let sampleMovieDay = MovieDay(
        day: .monday,
        id: sampleMovie.id ?? 1,
        movie: sampleMovie
    )
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
