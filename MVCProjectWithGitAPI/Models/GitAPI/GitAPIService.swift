//
//  GitAPIService.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Moya

enum GitAPIService {
    /// 깃 로그인
    case gitLogin
    /// RestAPI를 사용하기 위해 Git 토큰 가져오기
    /// - Parameter tempCode:(String) : 깃 로그인을 통해 발급받은 tempCode
    case gitToken
}

extension GitAPIService: TargetType {
    var baseURL: URL {
        switch self {
        case .gitLogin:
            return URL(string: "https://github.com")!
        case .gitToken:
            return URL(string: "https://github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .gitLogin:
            return "/login/oauth/authorize"
        case .gitToken:
            return"/login/oauth/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .gitLogin:
            return .get
        case .gitToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .gitLogin:
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
            
        case .gitToken:
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .gitLogin:
            return nil
        case .gitToken:
            return ["Accept": "application/json"]
        }
    }
}

