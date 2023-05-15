//
//  NetworkManager.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import Foundation

/// API_KEY  is restricted to 100 requests in 12 h, app won't show any results if that happens
let API_KEY = "c17c1adefede4f76b0cb092a8be6630a"

// MARK: - Networking setup
enum Path {
    case getCurrentHeadlines(_ page: Int)
    case getEverything(_ page: Int, _ sort: String, _ q: String)
}

struct Endpoint {
    let path: Path
    var queryItems: [URLQueryItem]
        
    static func search(for path: Path) -> Endpoint {
        switch path {
        case .getCurrentHeadlines(let page):
            return Endpoint(path: path,
                            queryItems: [URLQueryItem(name: "page", value: String(page)),
                                         URLQueryItem(name: "pageSize", value: String(20)),
                                         URLQueryItem(name: "apiKey", value: API_KEY),
                                         URLQueryItem(name: "country", value: "us")])
            
        case .getEverything(let page, let sort, let q):
            return Endpoint(path: path,
                            queryItems: [URLQueryItem(name: "page", value: String(page)),
                                         URLQueryItem(name: "pageSize", value: String(20)),
                                         URLQueryItem(name: "apiKey", value: API_KEY),
                                         URLQueryItem(name: "sortBy", value: sort),
                                         URLQueryItem(name: "q", value: q)])
       
        }
    }
    var url: URL? {
        var components = URLComponents()
        switch path {
        
        case .getCurrentHeadlines(_):
            components.scheme = "https"
            components.host = "newsapi.org"
            components.path = "/v2/top-headlines"
        
        case .getEverything(_, _, _):
            components.scheme = "https"
            components.host = "newsapi.org"
            components.path = "/v2/everything"
        }
        
        components.queryItems = queryItems
        
        return components.url
    }
}

class NetworkManager {
    static var shared = NetworkManager()
    
    let session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: sessionConfig)
    }()
    
    func request(_ endpoint: Endpoint, handler: @escaping ((Result<Data>) -> Void)) {
        guard let url = endpoint.url else {
            handler(Result.failure(FetchingError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, urlResponse, error in
            if let errorUnwrapped = error {
                handler(Result.failure(errorUnwrapped))
                return
            }
            
            if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                handler(Result.failure(FetchingError.responseError(httpResponse.statusCode)))
                
                return
            }
            
            guard let dataUnwrapped = data else {
                fatalError("Data should not be empty, impossible scenario!")
            }
            
            handler(Result.success(dataUnwrapped))
        }
        task.resume()
    }
}
 

