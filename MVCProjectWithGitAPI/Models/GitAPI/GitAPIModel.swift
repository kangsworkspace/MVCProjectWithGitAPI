//
//  GitAPIModel.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Moya

final class GitAPIModel {
    // MARK: - Field
    static let shared = GitAPIModel()
    let provider = MoyaProvider<GitAPIService>()
    
    
    // MARK: - Init
    private init() {}

    /// 깃 로그인
    func login() {
        provider.request(.gitLogin) { result in
            switch result {
            case .success(let response):
                if let url = response.request?.url {
                    // 웹 브라우저에서 URL 열기
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case .failure(let error):
                print("GitHub 로그인을 시작하지 못했습니다:", error)
            }
        }
    }
    
    /// AccessToken 가져오기
    /// - Parameter tempCode:(String) : 로그인을 통해 가져온 임시 코드
    func fetchAccessToken() {
        provider.request(.gitToken) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] else { return }
                    Constants.accessToken = (json["access_token"] as? String)!
                } catch let error {
                    print("Error parsing response: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
