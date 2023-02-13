//
//  News.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 04.02.2023.
//

import Foundation

import Foundation

// MARK: - News
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

// MARK: - Article
struct News: Codable {
    let source: Source
    let author, title, description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}



