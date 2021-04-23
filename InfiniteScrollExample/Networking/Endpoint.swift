//
//  Endpoint.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/12/21.
//

import Foundation

typealias Parameters = [String: String]

enum StackExchangeEndpoint {
    
    case moderators
    
    var base: String { "https://api.stackexchange.com" }
    var path: String {
        switch self {
        case .moderators: return "/2.2/users/moderators"
        }
    }
    
    static var defaultParameters: Parameters { ["order": "desc", "sort" : "reputation", "site" : "stackoverflow", "filter": "!-*jbN0CeyJHb"] }
    
    func request(_ parameters: Parameters? = nil) -> URLRequest {
        
        var components = URLComponents(string: base)! //forceunwrapped becuase we know it exists
        components.path = path
        var defaultParameters = StackExchangeEndpoint.defaultParameters
        defaultParameters.merge(parameters ?? [:]) { current, _ in current }
        components.queryItems = defaultParameters.map { key, value in URLQueryItem(name: key, value: value) }
        let url = components.url! //want to crash if no information is complete
        return URLRequest(url: url)
    }
}

