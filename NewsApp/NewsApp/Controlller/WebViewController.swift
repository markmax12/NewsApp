//
//  WebViewController.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 05.02.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {

    //MARK: - Properties
    
    var webView: WKWebView!
    var selectedNews: String?
    
    
    //MARK: - Methods
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedNews = selectedNews {
            guard let url = URL(string: selectedNews) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
