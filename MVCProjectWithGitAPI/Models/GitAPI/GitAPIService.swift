//
//  GitAPIService.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import Foundation

import Moya

enum GitAPIService {
    /// 깃 로그인
    case login
    
    /// RestAPI를 사용하기 위해 Git 토큰 가져오기
    case getToken
    
    /// Rest API로 유저의 정보를  가져오는 경우
    /// - Parameter userID:(Int) : 검색할 유저의 아이디
    /// - Parameter page:(Int) : 페이징 처리를 위한 페이지 값
    case gitUserInfo(userID: String, page: Int)
}

extension GitAPIService: TargetType {
    var baseURL: URL {
        switch self {
        case .login:
            return URL(string: "https://github.com")!
        case .getToken:
            return URL(string: "https://github.com")!
        case .gitUserInfo:
            return URL(string: "https://api.github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login/oauth/authorize"
        case .getToken:
            return"/login/oauth/access_token"
        case .gitUserInfo:
            return "/search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .get
        case .getToken:
            return .post
        case .gitUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login:
            guard let clientID = Bundle.main.cliendID else {
                print("cliendID를 로드하지 못했습니다.")
                return .requestPlain
            }
            
            let scope = "user"
            
            let parameters: [String: Any] = [
                "client_id": clientID,
                "scope": scope
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .getToken:
            guard let clientID = Bundle.main.cliendID else {
                print("cliendID를 로드하지 못했습니다.")
                return .requestPlain
            }
            
            guard let clientSecrets = Bundle.main.clientSecrets else {
                print("cliendID를 로드하지 못했습니다.")
                return .requestPlain
            }
            
            let tempCode = Constants.tempCode
            
            let parameters: [String: Any] = [
                "client_id": clientID,
                "client_secret": clientSecrets,
                "code": tempCode
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .gitUserInfo(userID, page):
            let parameters: [String: Any] = ["q": "\(userID) in:login", "page": page, "per_page": 30]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return nil
        case .getToken:
            return ["Accept": "application/json"]
        case .gitUserInfo(_, _):
            let accessToken = Constants.accessToken
            
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        }
    }
}

