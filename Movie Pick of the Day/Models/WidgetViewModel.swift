//
//  WidgetViewModel.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 23/3/23.
//

import Foundation
import SwiftUI
import Combine
import OSLog

final class WidgetViewModel {
    
    private var subscriptions = Set<AnyCancellable>()
    private let appDataRepository: AppDataRepositoryType
    
    init(appDataRepository: AppDataRepositoryType = AppDataRepository()) {
        self.appDataRepository = appDataRepository
    }
    
    func getMoviePickAndImage(completion: @escaping (MovieDay?, UIImage?) -> Void) {
        getMoviePickAndImagePublisher()
            .sink { completion($0, $1) }
            .store(in: &subscriptions)
    }
    
    func getMoviePickAndImagePublisher() -> AnyPublisher<(MovieDay?, UIImage?), Never> {
        Just(appDataRepository.getMoviePicksOfTheWeek())
            .eraseToAnyPublisher()
            .flatMap { moviePicks -> AnyPublisher<MovieDay?, Never> in
                return Just(moviePicks.getTodaysMovieDay(todaysDate: .init()))
                    .eraseToAnyPublisher()
            }
            .flatMap { (movieDay: MovieDay?) -> AnyPublisher<(MovieDay?, UIImage?), Never> in
                guard
                    let movieDay,
                    let movie = movieDay.movie,
                    let posterPath = movie.posterPath
                else {
                    return Just((nil, nil))
                        .eraseToAnyPublisher()
                }
                return TMDBService.getUIImage(of: posterPath, with: .w500)
                    .flatMap { uiImage -> AnyPublisher<(MovieDay?, UIImage?), Never> in
                        Just((movieDay, uiImage))
                            .eraseToAnyPublisher()
                    }
                    .replaceError(with: (movieDay, nil))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
