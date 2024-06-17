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
    let gitHubService = GitHubService.shared
    
    // MARK: - Layouts
    private lazy var searchView = SearchView().then {
        $0.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        $0.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tableView = TableView().then {
        $0.tableView.dataSource = self
        $0.tableView.delegate = self
        $0.tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Life Cycels
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
        gitHubService.login()
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
        view.addSubview(tableView)
    }
    
    func setAutoLayout() {
        // searchView AutoLayout
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        // TableView AutoLayout
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // clearButton 히든 처리 로직
    @objc func textFieldDidChange() {
        if searchView.textField.text == "" {
            searchView.clearButton.isHidden = true
        } else {
            searchView.clearButton.isHidden = false
        }
    }
    
    // clearButton 동작 로직
    @objc func clearButtonTapped() {
        searchView.textField.text = ""
        searchView.clearButton.isHidden = true
    }
    
    // searchButton 동작 로직
    @objc func searchButtonTapped() {
        guard let text = searchView.textField.text else { return }
        
        // textField가 비어있을 때 동작 X
        guard !text.isEmpty else { return }
        
        print("검색 버튼 눌림")
    }
}

// MARK: - Extensions
// UITableView의 dataSource 설정을 위한 extension
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.backgroundColor = .blue
        return cell
    }
}

// UITableView의 델리게이트 설정을 위한 extension
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
}
