//
//  ImageCacheService.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import Foundation

import Moya

enum ImageCacheService {
    /// URL을 통해 이미지를 가져오는 경우
    /// - Parameter urlString:(String) : 이미지를 가져올 URL 주소
    case loadImage(urlString: String)
}

extension ImageCacheService: TargetType {
    var baseURL: URL {
        switch self {
        case let .loadImage(urlString):
            return URL(string: urlString)!
        }
    }
    
    var path: String {
        switch self {
        case .loadImage:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .loadImage:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .loadImage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .loadImage:
            return nil
        }
    }
}
