//
//  DateFormatter.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import Foundation

extension Date {
    var datePublishedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    var datePublished: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: self)
    }
}
