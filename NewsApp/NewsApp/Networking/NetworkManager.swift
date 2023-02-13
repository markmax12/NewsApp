//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 04.02.2023.
//

import Foundation

public enum NewsAPI {
    public static var newsAPIComponents: URLComponents {
        var compontents = URLComponents()
        compontents.scheme = "https"
        compontents.host = "newsapi.org"
        compontents.path = "/v2/everything"
        compontents.queryItems = [
        URLQueryItem(name: "q", value: "bitcoin"),
        URLQueryItem(name: "pageSize", value: "20"),
        URLQueryItem(name: "apiKey", value: "bb66c8b42282470eae8e25fab9bc2c48")
        //Uncomment to see recent news (lots of garbage)
       //URLQueryItem(name: "sortBy", value: "publishedAt")
        ]
        
        return compontents
    }
    
    
}

final class NetworkManager {
    
    class func fetchNews<T: Decodable>(pageNumber number: Int = 1, completion: @escaping (Result<T, Error>) -> Void) {
        
        var compontents = NewsAPI.newsAPIComponents
        compontents.queryItems?.append(URLQueryItem(name: "page", value: "\(number)"))
        guard let url = compontents.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard response != nil, let data = data else { return }
            
            do {
                let newsResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(newsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
