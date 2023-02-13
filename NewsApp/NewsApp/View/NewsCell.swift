//
//  NewsViewCell.swift
//  NewsApp
//
//  Created by Maxim Ivanov on 04.02.2023.
//

import UIKit

final class NewsCell: UITableViewCell, ReusableIdentifier {
    
    //MARK: - Properties
    
    let newsImage: UIImageView = {
        let imageView = UIImageView.makeImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.setContentCompressionResistancePriority(.defaultLow - 100, for: .vertical)
        return imageView
    }()
    
    let heading: UILabel = {
        let label = UILabel.makeLabel(style: .headline)
        label.textAlignment = .center
        return label
    }()
    
    let viewCount: UILabel = {
        let label = UILabel.makeLabel(style: .body)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "0"
        label.textColor = .gray
        return label
    }()
    
    let viewIcon: UIImageView = {
        let imageView = UIImageView.makeImageView()
        let image = UIImage(systemName: "eye")
        imageView.image = image
        imageView.contentMode = .right
        return imageView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [viewIcon, viewCount])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10.0
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newsImage, heading, horizontalStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20.0
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let margins = contentView.layoutMarginsGuide
        
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)])
    }
}

