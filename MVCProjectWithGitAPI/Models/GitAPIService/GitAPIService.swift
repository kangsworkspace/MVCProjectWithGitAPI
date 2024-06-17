//
//  GitAPIService.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Moya

enum GitAPIService {
    case gitLogin
}

extension GitAPIService: TargetType {
    var baseURL: URL {
        switch self {
        case .gitLogin:
            return URL(string: "https://github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .gitLogin:
            return "/login/oauth/authorize"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .gitLogin:
            return .get
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .gitLogin:
            return nil
        }
    }
}

