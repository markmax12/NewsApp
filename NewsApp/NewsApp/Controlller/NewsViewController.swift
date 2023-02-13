//
//  ViewController.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 04.02.2023.
//

import UIKit

final class NewsViewController: UITableViewController {
    
    //MARK: - Properties
    
    private(set) var newsList: ArticleCollection = Store.shared.news
    private let refresh = UIRefreshControl()
    
    var numberOfCells = 2
    var heightOfCell: CGFloat = 330
    
    var lastLoadedTimestamp = Date().timeIntervalSince1970
    var isLoading = false
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupRefreshControl()
        
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        numberOfCells = Int(view.bounds.height / heightOfCell)
        if newsList.articles.isEmpty {
            fetchNews()
        }
    }
    
    private func fetchNews() {
        NetworkManager.fetchNews { [weak self] (result: Result<NewsResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                response.articles.forEach {
                    let art = Article(news: $0)
                    self.newsList.articles.append(art)
                }
                self.lastLoadedTimestamp = Date().timeIntervalSince1970
                Store.shared.save(data: self.newsList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async {
            ErrorAlert.show(error.localizedDescription) { alert in
                self.present(alert, animated: true)
            }
            return
        }
    }
    
    //MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as! NewsCell
        
        cell.heading.text = newsList.articles[indexPath.row].news?.title
        if let imageURL = newsList.articles[indexPath.row].getImageURL() {
            cell.newsImage.loadImageFromURL(url: imageURL)
        } else {
            cell.newsImage.image = UIImage(systemName: "photo")
        }
        cell.viewCount.text = "\(newsList.articles[indexPath.row].viewCount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex {
            let indicatorSpinner = UIActivityIndicatorView(style: .large)
            indicatorSpinner.startAnimating()
            indicatorSpinner.color = UIColor.gray
            indicatorSpinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            tableView.tableFooterView = indicatorSpinner
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        let news = newsList.articles[indexPath.row]
        news.viewCount += 1
        tableView.reloadData()
        vc.news = news.news
        if let imageURL = newsList.articles[indexPath.row].getImageURL() {
            vc.newsImage.loadImageFromURL(url: imageURL)
        } else {
            vc.newsImage.image = UIImage(systemName: "photo")
        }
        Store.shared.save(data: newsList)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadMore(scrollView)
    }
    
    //MARK: - Pagination
    
    func canLoadMore(_ scrollView: UIScrollView) -> Bool {
        let isOnBottom = scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - (heightOfCell * CGFloat(numberOfCells))
        let timePassedSinceIsOnBttom = Date().timeIntervalSince1970 - lastLoadedTimestamp > 3
        return isOnBottom && timePassedSinceIsOnBttom
    }
    
    func loadMore(_ scrollView: UIScrollView) {
        if canLoadMore(scrollView) {
            if !isLoading {
                self.isLoading = true
                NetworkManager.fetchNews(pageNumber: (self.newsList.articles.count / 20) + 1) { [weak self] (result: Result<NewsResponse, Error>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        response.articles.forEach {
                            let art = Article(news: $0)
                            self.newsList.articles.append(art)
                        }
                        Store.shared.save(data: self.newsList)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        self.showError(error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    //MARK: - Pull-to-refresh
    
    private func setupRefreshControl() {
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshNewsList), for: .valueChanged)
    }
    
    @objc private func refreshNewsList() {
        NetworkManager.fetchNews { [weak self] (result: Result<NewsResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                var arr = [Article]()
                for article in response.articles {
                    if article.url == self.newsList.articles[0].news?.url {
                        break
                    }
                    let article = Article(news: article)
                    arr.append(article)
                }
                self.newsList.articles.insert(contentsOf: arr, at: 0)
                self.lastLoadedTimestamp = Date().timeIntervalSince1970
                Store.shared.save(data: self.newsList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.refresh.isRefreshing {
                        self.refresh.endRefreshing()
                    }
                }
            case .failure(let error):
                if self.refresh.isRefreshing {
                    self.refresh.endRefreshing()
                }
                self.showError(error)
            }
        }
    }
}
