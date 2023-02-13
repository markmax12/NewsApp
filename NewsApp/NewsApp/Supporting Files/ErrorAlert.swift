//
//  ErrorAlert.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import UIKit

class ErrorAlert {
    static func show(_ message: String, completion: (UIAlertController) -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        completion(alert)
    }
}
