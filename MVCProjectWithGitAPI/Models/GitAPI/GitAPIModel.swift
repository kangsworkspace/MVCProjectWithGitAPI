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
    
    // 유저 정보
    var userInfos: [UserInfo]? {
        didSet {
            didChangeUserInfos?(self)
        }
    }
    /// userInfos 변경 시 동작할 함수를 담기 위한 코드
    var didChangeUserInfos: ((GitAPIModel) -> Void)?
    /// 검색 페이지(페이징 처리)
    var pageNum = 1
    
    // MARK: - Init
    private init() {}

    // MARK: - Functions
    /// 깃 로그인
    func login() {
        provider.request(.login) { result in
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
        provider.request(.getToken) { result in
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
    
    /// 유저 정보 가져오기
    /// - Parameter userID:(String) : 검색할 유저의 ID
    /// - Parameter page:(Int) : 페이징 처리를 위한 페이지 값
    /// - Parameter type:(GetUserInfoType) : 초기 검색 / 추가 검색을 나누는 타입
    /// - returns: 클로져로 종료 시점을 전달
    func fetchUserData(userID: String, type: UserInfoSearchType, completion: @escaping () -> Void) {
        provider.request(.gitUserInfo(userID: userID, page: self.pageNum)) { [self] result in
            switch result {
            case .success(let response):
                do {
                    guard let jsonString = String(data: response.data, encoding: .utf8) else { return }
                    guard let jsonData = jsonString.data(using: .utf8) else { return }
                    
                    // 디코드
                    let decoder = JSONDecoder()
                    let resultArray = try decoder.decode(UserInfoResults.self, from: jsonData)
                    
                    switch type {
                    case .searching:
                        userInfos = resultArray.userInfo
                        completion()
                        return
                    case .paging:
                        guard var tempUserInfo = userInfos else {
                            userInfos = resultArray.userInfo
                            completion()
                            return
                        }
                        
                        tempUserInfo += resultArray.userInfo
                        userInfos = tempUserInfo
                        completion()
                        return
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
