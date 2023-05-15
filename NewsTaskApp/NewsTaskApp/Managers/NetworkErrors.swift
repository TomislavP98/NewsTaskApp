//
//  NetworkErrors.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    
    var value: T? {
        get {
            switch self {
            case .success(let a):
                return a
            default:
                return nil
            }
        }
    }
    
    var error: Error? {
        get {
            switch self {
            case .failure(let a):
                return a
            default:
                return nil
            }
        }
    }
    
    var isFailure: Bool {
        get {
            return error != nil
        }
    }
    
    var isSuccess: Bool {
        get {
            return value != nil
        }
    }
}

enum FetchingError: LocalizedError {
    case invalidURL
    case responseError(Int)
    
    var errorDescription: String? {
        get {
            switch self {
            case .invalidURL:
                return "Unsupported URL"
            case .responseError(let statusCode):
                return "Response error \(statusCode)"
            }
        }
    }
}
