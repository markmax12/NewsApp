//
//  Article.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import Foundation

final class Article: Codable {
 
    //MARK: - Properties
    
    var news: News?
    var viewCount = 0
    
    //MARK: - Methods
    
    init(news: News? = nil, viewCount: Int = 0) {
        self.news = news
        self.viewCount = viewCount
    }
    
    public func getImageURL() -> URL? {
        guard let path = self.news?.urlToImage else { return nil }
        guard let url = URL(string: path) else { return nil }
        return url
    }
}
