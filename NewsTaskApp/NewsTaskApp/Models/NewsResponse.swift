//
//  NewsResponse.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import Foundation

// MARK: - NewsResponse
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
    
    static func parseNews(data: Data) throws -> NewsResponse {
        let news = try JSONDecoder().decode(NewsResponse.self, from: data)
        return news
    }
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

