//
//  tableView.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Then

class TableView: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    // 백그라운드 뷰
    private let backgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 테이블 뷰
    private(set) var tableView = UITableView().then {
        $0.rowHeight = 70
        $0.register(TableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Functions
    private func setMain() {
        // 레이아웃 설정들
        setAddView()
        setAutoLayout()
    }
    
    private func setAddView() {
        backgroundView.addSubview(tableView)
        self.addSubview(backgroundView)
    }
    
    private func setAutoLayout() {
        // backgroundView AutoLayout
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        // tableView AutoLayout
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: 0),
        ])
    }
}
