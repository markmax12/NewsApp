//
//  UITextView & UILabel Factories.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import UIKit

extension UILabel {
    static func makeLabel(style: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension UIImageView {
    static func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

