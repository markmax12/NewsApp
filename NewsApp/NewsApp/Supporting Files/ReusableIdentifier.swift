//
//  ReusableIdentifier.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 04.02.2023.
//

import Foundation

protocol ReusableIdentifier: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableIdentifier {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

