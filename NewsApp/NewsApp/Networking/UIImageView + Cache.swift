//
//  UIImageView + Cache.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import UIKit

extension UIImageView {
    func loadImageFromURL(url: URL, withPlaceHolder placeHolder: UIImage? = UIImage(systemName: "photo")) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeHolder
            URLSession.shared.dataTask(with: request) { data, response, _ in
                if let data = data, let response = response, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }.resume()
        }
    }
}
