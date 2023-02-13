//
//  Store.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import Foundation

final class Store {
    static private let documentDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let shared = Store(url: documentDirectory)
    
    private(set) var news: ArticleCollection
    
    init(url: URL?) {
        if let url = url,
           let data = try? Data(contentsOf: url.appendingPathComponent(.storeLocation)),
           let news = try? JSONDecoder().decode(ArticleCollection.self, from: data) {
            self.news = news
        } else {
            self.news = ArticleCollection()
        }
    }
    
    func save(data: ArticleCollection) {
        if let savedData = try? JSONEncoder().encode(data) {
            try! savedData.write(to: Self.documentDirectory.appendingPathComponent(.storeLocation))
        }
        
    }
}

fileprivate extension String {
    static let storeLocation = "store.json"
}
