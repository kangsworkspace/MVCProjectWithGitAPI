//
//  ViewController.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/16/24.
//

import UIKit
import SafariServices

import Then

final class MainViewController: UIViewController {
    // MARK: - Feild
    let gitAPIModel = GitAPIModel.shared
    let imageCacheModel = ImageCacheModel.shared

    // MARK: - Layouts
    private lazy var searchView = SearchView().then {
        $0.textField.delegate = self
        $0.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        $0.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tableView = TableView().then {
        $0.tableView.dataSource = self
        $0.tableView.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var emptyView = EmptyView().then {
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Life Cycels
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
        gitAPIModel.login()
    }
    
    // MARK: - Functions
    private func setMain() {
        // 배경화면 색상 설정
        view.backgroundColor = .white
        
        // 레이아웃 설정들
        setAddView()
        setAutoLayout()
        setBinding()
    }
    
    private func setAddView() {
        view.addSubview(searchView)
        view.addSubview(tableView)
        view.addSubview(emptyView)
    }
    
    private func setAutoLayout() {
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
        
        // emptyView AutoLayout
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 40),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ])
    }
    
    private func setBinding() {
        gitAPIModel.didChangeUserInfos = { [self] _ in
            tableView.tableView.reloadData()
            checkEmpty()
        }
    }
    
    /// URL로 이동하는 함수
    /// - Parameter url:(String) : 이동할 URL
    /// - Parameter fromVC:(UIViewController) : 기준이 되는 뷰 컨트롤러
    private func goWebPage(url: String) {
        if url != "등록된 정보가 없습니다" {
            guard let url = URL(string: url) else { return }
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .automatic
            self.present(safariViewController, animated: true)
        }
    }
    
    private func checkEmpty() {
        let userInfos = gitAPIModel.userInfos
        
        if userInfos?.isEmpty == true {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
    
    // 다른 화면을 눌렀을 때 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        gitAPIModel.fetchUserData(userID: text, type: .searching)
        self.view.endEditing(true)
    }
}

// MARK: - Extensions
// UITableView의 dataSource 설정을 위한 extension
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitAPIModel.userInfos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        
        guard let userInfos = gitAPIModel.userInfos else { return cell }
        
        cell.nameLabel.text = userInfos[indexPath.row].login
        cell.urlLabel.text = userInfos[indexPath.row].url
        
        // 이미지 캐싱처리
        imageCacheModel.loadImage(urlString: userInfos[indexPath.row].avatarURL) { image in
            // 메인 쓰레드에서 이미지 변경
            DispatchQueue.main.async {
                cell.userImageView.image = image
            }
        }
        
        return cell
    }
}

// UITableView의 델리게이트 설정을 위한 extension
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchView.textField.isFirstResponder {
            self.view.endEditing(true)
        } else {
            guard let url = gitAPIModel.userInfos?[indexPath.row].url else { return }
            goWebPage(url: url)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 검새 결과가 없을 때 동작하지 않음
        guard gitAPIModel.userInfos != nil else { return }
        let tableView = tableView.tableView
        
        // tableView를 거의 끝까지 내렸을 때 추가 검색
        if tableView.contentOffset.y > (tableView.contentSize.height - tableView.bounds.size.height - 120) {
            gitAPIModel.fetchUserData(userID: "Paging", type: .paging)
        }
    }
}

// UITextField의 델리게이트 설정을 위한 extension
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            searchButtonTapped()
        }
        
        return true
    }
}
