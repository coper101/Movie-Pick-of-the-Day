//
//  Network.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 6/1/23.
//

import Foundation
import Combine
import UIKit
import OSLog

enum NetworkError: Error, Equatable {
    
    case request(String)
    case decode(String)
    case server(String)
    case image(String)
    
    var description: String {
        switch self {
        case .request(let message):
            return message
        case .decode(let message):
            return message
        case .server(let message):
            return message
        case .image(let message):
            return message
        }
    }
}

enum Method: String {
    case GET
    case POST
}

protocol Request {
    associatedtype Response: Decodable
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: Method { get }
    var parameters: [String: String] { get }
}

protocol ImageRequest {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
}

extension Publisher {
    
    func decode<Item, Coder>(type: Item.Type, decoder: Coder, errorTransform: @escaping (Error) -> Failure) -> Publishers.FlatMap<Publishers.MapError<Publishers.Decode<Just<Self.Output>, Item, Coder>, Self.Failure>, Self> where Item : Decodable, Coder : TopLevelDecoder, Self.Output == Coder.Input {
        return flatMap {
            Just($0)
                .decode(type: type, decoder: decoder)
                .mapError { errorTransform($0) }
        }
    }
    
}

class Networking {
    
    static func requestImage<R>(request: R) -> AnyPublisher<UIImage, Error> where R: ImageRequest {
        /// path
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        /// url
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.request("Invalid URL"))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.request("Invalid URL Response")
                }
                guard (200..<400).contains(response.statusCode) else {
                    throw NetworkError.server("Server Error")
                }
                return data
            }
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw NetworkError.request("Conversion to UIImage Error")
                }
                return uiImage
            }
            .eraseToAnyPublisher()
    }
    
    static func request<R>(request: R) -> AnyPublisher<R.Response, Error> where R: Request {
        /// path
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = request.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        /// url
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.request("Invalid URL"))
                .eraseToAnyPublisher()
        }
        Logger.network.debug("request - request url: \(url.absoluteURL)")
        
        /// request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.request("Invalid URL Response")
                }
                guard (200..<400).contains(response.statusCode) else {
                    throw NetworkError.server("Server Error")
                }
                return data
            }
            .decode(type: R.Response.self, decoder: JSONDecoder()) {
                NetworkError.decode($0.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
}
