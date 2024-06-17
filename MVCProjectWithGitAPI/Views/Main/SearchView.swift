//
//  CustomSearchView.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/16/24.
//

import UIKit

import Then

final class SearchView: UIView {
    // MARK: - Fields
    
    
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
        $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 스택뷰
    private let searchStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // search 텍스트 필드
    private(set) var searchTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.placeholder = "유저 검색"
        $0.autocapitalizationType = .none
        $0.clearsOnBeginEditing = false
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.returnKeyType = .search
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // clear 버튼
    private let searchClearButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(UIImage(systemName: "x.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // search 버튼
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Functions
    private func setMain() {
        // 레이아웃 설정들
        setAddView()
        setAutoLayout()
    }
    
    private func setAddView() {
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchClearButton)
        searchStackView.addArrangedSubview(searchButton)
        backgroundView.addSubview(searchStackView)
        self.addSubview(backgroundView)
    }
    
    private func setAutoLayout() {
        // backgroundView AutoLayout
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            // 카드 크기
            backgroundView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // searchStackView AutoLayout
        NSLayoutConstraint.activate([
            searchStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0),
            
            searchStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            searchStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -6),
            
            searchStackView.heightAnchor.constraint(equalToConstant: 30),
            
            // Inner
            
            // searchClearButton
            searchClearButton.widthAnchor.constraint(equalToConstant: 30),
            searchClearButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 0),
        
            // searchButton
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor, constant: 0)
        ])
    }
}
