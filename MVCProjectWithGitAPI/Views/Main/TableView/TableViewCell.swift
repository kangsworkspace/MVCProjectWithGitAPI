//
//  tableViewCell.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Then

final class TableViewCell: UITableViewCell {
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicator.startAnimating()
        userImageView.image = nil
        nameLabel.text = nil
        urlLabel.text = nil
    }
    
    // MARK: - Layouts
    /// 유저 아바타 이미지 뷰
    private lazy var userImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유저 이름
    private var nameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유저 URL
    private var urlLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.4
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 로딩 인디케이터
    private let activityIndicator = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Functions
    func setMain() {
        setAddView()
        setAutoLayout()
    }
    
    func setAddView() {
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        self.addSubview(urlLabel)
        self.addSubview(activityIndicator)
    }
    
    func setAutoLayout() {
        // userImageView
        NSLayoutConstraint.activate([
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),

            userImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // nameLabel
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        // urlLabel
        NSLayoutConstraint.activate([
            urlLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            urlLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0),
            urlLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            urlLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // activityIndicator
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: 0),
            activityIndicator.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 0),
            activityIndicator.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 0),
            activityIndicator.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0),
        ])
    }
    
    func setConfig(name: String, urlString: String) {
        nameLabel.text = name
        urlLabel.text = urlString
    }
    
    func setImage(image: UIImage?) {
        activityIndicator.stopAnimating()
        userImageView.image = image
    }
}
