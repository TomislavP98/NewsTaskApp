//
//  NetworkClient.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import Foundation

class NetworkClient {
    
    func getTopNews(page: Int, completion: ((Result<NewsResponse>) -> Void)?) {
        NetworkManager.shared.request(.search(for: .getCurrentHeadlines(page))) { (response) in
            DispatchQueue.main.async {
                guard let value = response.value else {
                    if let error = response.error {
                        
                        completion?(Result.failure(error))
                    } else {
                        completion?(Result.failure(NSError(domain: "Something went wrong, try again.", code: 1, userInfo: nil)))
                    }
                    return
                }
                completion?(self.processResult(response: Result.success(value), parser: NewsResponse.parseNews))
            }
        }
    }
    
    func getEverything(page: Int, sort: String, q: String,  completion: ((Result<NewsResponse>) -> Void)?) {
        NetworkManager.shared.request(.search(for: .getEverything(page, sort, q))) { (response) in
            DispatchQueue.main.async {
                guard let value = response.value else {
                    if let error = response.error {
                        
                        completion?(Result.failure(error))
                    } else {
                        completion?(Result.failure(NSError(domain: "Something went wrong, try again.", code: 1, userInfo: nil)))
                    }
                    return
                }
                completion?(self.processResult(response: Result.success(value), parser: NewsResponse.parseNews))
            }
        }
    }
    
    private func processResult<T> (response: Result<Data>, parser: ((_ data: Data) throws -> T)) -> Result<T> {
        if let error = response.error {
            return Result.failure(error)
        } else {
            do {
                let parsed = try parser(response.value!)
                return Result.success(parsed)
            } catch {
                print(error)
                return Result.failure(error)
            }
        }
    }
}
