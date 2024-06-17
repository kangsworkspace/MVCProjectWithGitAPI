//
//  EmptyView.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Then

final class EmptyView: UIView {
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
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 빈 화면 안내 레이블
    private let emptyLabel = UILabel().then {
        $0.text = "검색어에 해당하는 유저가 없어요"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .gray
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Functions
    private func setMain() {
        // 레이아웃 설정들
        setAddView()
        setAutoLayout()
    }
    
    private func setAddView() {
        backgroundView.addSubview(emptyLabel)
        self.addSubview(backgroundView)
    }
    
    private func setAutoLayout() {
        // backgroundView AutoLayout
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            backgroundView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // emptyLabel AutoLayout
        NSLayoutConstraint.activate([
            emptyLabel.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 0),
            emptyLabel.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 0),
            emptyLabel.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: 0),
            emptyLabel.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: 0),
        ])
    }
}
