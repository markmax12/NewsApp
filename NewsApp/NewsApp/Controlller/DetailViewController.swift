//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 04.02.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    
    var news: News? {
        didSet {
            titleLabel.text = news?.title ?? ""
            datePublishedLabel.text = news?.publishedAt?.datePublished?.datePublishedString
            sourceLabel.text = news?.source.name ?? ""
            bodyText.text = news?.description ?? ""
        }
    }
    
    let newsImage: UIImageView = {
        let imageView = UIImageView.makeImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.setContentCompressionResistancePriority(.defaultLow - 100, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh + 1000, for: .vertical)
        return imageView
    }()
    
    private let titleLabel = UILabel.makeLabel(style: .title1)
    
    private let datePublishedLabel = UILabel.makeLabel(style: .footnote)
    
    private let sourceLabel: UILabel = {
        let label = UILabel.makeLabel(style: .subheadline)
        label.textColor = .gray
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
        if let italicDescriptor = descriptor.withSymbolicTraits(.traitItalic) {
            label.font = UIFont(descriptor: italicDescriptor, size: 0)
        }
        return label
    }()
    
    private let bodyText: UITextView = {
        let view = UITextView()
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.isScrollEnabled = false
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    
    private lazy var openWebViewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Read Full Text", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addAction(UIAction(handler: { _ in
            self.openWebView() }),
            for: .touchUpInside)
        
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, sourceLabel, datePublishedLabel, bodyText, openWebViewButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        view.addSubview(stackView)
        view.addSubview(newsImage)
        let readableGuide = view.readableContentGuide
        NSLayoutConstraint.activate([
            newsImage.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            newsImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            newsImage.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            newsImage.heightAnchor.constraint(equalTo: newsImage.widthAnchor, multiplier: 0.5),
            
            stackView.leadingAnchor.constraint(equalTo: readableGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: readableGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: readableGuide.bottomAnchor)])
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        return scrollView
    }()
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        navigationItem.largeTitleDisplayMode = .never
        title = "Article"
    }
    
    
    private func setupView() {
        view.addSubview(scrollView)
        
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentGuide.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            frameGuide.widthAnchor.constraint(equalTo: contentGuide.widthAnchor)
        ])
    }
    
    private func openWebView() {
        let vc = WebViewController()
        vc.selectedNews = news?.url
        navigationController?.pushViewController(vc, animated: true)
    }

}
