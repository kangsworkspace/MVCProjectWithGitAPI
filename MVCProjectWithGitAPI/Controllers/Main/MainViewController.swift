//
//  ViewController.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/16/24.
//

import UIKit

import Then

final class MainViewController: UIViewController {
    // MARK: - Feild
    
    // MARK: - Layouts
    private lazy var searchView = SearchView().then {
        $0.searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Life Cycels
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
    }
    
    // MARK: - Functions
    func setMain() {
        // 배경화면 색상 설정
        view.backgroundColor = .white
        
        // 레이아웃 설정들
        setAddView()
        setAutoLayout()
    }
    
    func setAddView() {
        view.addSubview(searchView)
    }
    
    func setAutoLayout() {
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }
    
    
    
    // Clear 버튼 히든 처리 로직
    @objc func textFieldDidChange() {
        if searchView.searchTextField.text == "" {
            searchView.clearButton.isHidden = true
        } else {
            searchView.clearButton.isHidden = false
        }
    }
}

// MARK: - Extensions

