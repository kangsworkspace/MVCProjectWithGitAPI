//
//  GitAPIService.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Moya

final class GitHubService {
    // 싱글톤
    static let shared = GitHubService()
    private init() {}
    
    /// Git 로그인 화면 띄우기
    func login() {
        guard let clientID = Bundle.main.cliendID else {
            print("cliendID를 로드하지 못했습니다.")
            return
        }
        
        let scope = "user"
        let authURLString = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=\(scope)"
        
        if let authURL = URL(string: authURLString) {
            // 웹 브라우저에서 URL 열기
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
        }
    }
}
