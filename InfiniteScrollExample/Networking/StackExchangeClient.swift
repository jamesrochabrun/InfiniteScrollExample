//
//  StackExchangeClient.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/12/21.
//


import Combine
import Foundation

protocol CombineAPI {
    var session: URLSession { get }
    func execute<Model>(
        _ request: URLRequest,
        decodingType: Model.Type,
        queue: DispatchQueue,
        retries: Int)
    -> AnyPublisher<Model, Error> where Model: Decodable
}

extension CombineAPI {
    
    func execute<Model>(
        _ request: URLRequest,
        decodingType: Model.Type,
        queue: DispatchQueue = .main,
        retries: Int = 0)
    -> AnyPublisher<Model, Error> where Model: Decodable {
        
        session.dataTaskPublisher(for: request)
            .mapError { error -> APIError in
                switch error {
                case URLError.notConnectedToInternet:
                    return .noInternet
                default:
                    return .responseUnsuccessful(description: "\(error.localizedDescription)")
                }
            }
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.responseUnsuccessful(description: "\(String(describing: $0.response.url?.absoluteString))")
                }
                return $0.data
            }
            .decode(type: decodingType, decoder: JSONDecoder())
            .receive(on: queue)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}

final class StackExchangeClient: CombineAPI {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetch<Model>(_ modelType: Model.Type, for page: Int) -> AnyPublisher<Model, Error> where Model: Decodable {
        let request = StackExchangeEndpoint.moderators.request(["page" : "\(page)"])
        print("PATH \(String(describing: request.url?.absoluteString))")
        return execute(request, decodingType: modelType)
    }
}

public enum APIError: Error {
    
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure
    case noInternet
    
    var localizedDescription: String {
        switch self {
        case .requestFailed(let desc): return "Request Failed error -> \(desc)"
        case .invalidData: return "Invalid Data error)"
        case .responseUnsuccessful(let desc): return "Response Unsuccessful error -> \(desc)"
        case .jsonParsingFailure: return "JSON Parsing Failure error)"
        case .jsonConversionFailure(let desc): return "JSON Conversion Failure -> \(desc)"
        case .noInternet: return "No internet connection"
        }
    }
}
