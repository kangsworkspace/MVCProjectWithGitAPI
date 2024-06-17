//
//  ImageCacheModel.swift
//  MVCProjectWithGitAPI
//
//  Created by Healthy on 6/17/24.
//

import UIKit

import Moya

final class ImageCacheModel {
    // MARK: - Field
    static let shared = ImageCacheModel()
    private let cache = NSCache<NSString, UIImage>()
    let provider = MoyaProvider<ImageCacheService>()
    
    // MARK: - Init
    private init() {
        self.cache.countLimit = 100
    }
    
    // MARK: - Functions
    /// URL주소를 통해 이미지를 가져오는 함수
    /// - Parameter urlString:(String) : 이미지를 불러올 URL 주소
    /// - returns: 클로져 형식으로 UIImage? 타입 리턴
    /// - 캐싱된 이미지가 있을 경우 캐싱된 이미지를 가져옵니다.
    /// - 캐싱된 이미지가 없을 경우 URL을 통해 네트워크에서 이미지를 불러옵니다.
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: urlString as NSString) {
            completion(image)
            return
        } else {
            loadImageFromNetWork(urlString: urlString) { image in
                completion(image)
                return
            }
        }
    }
    
    /// URL 주소를 통해 네트워크에서 이미지 가져오기
    private func loadImageFromNetWork(urlString: String, completion: @escaping (UIImage?) -> Void) {
        provider.request(.loadImage(urlString: urlString)) { result in
            switch result {
            case let .success(response):
                guard let image = UIImage(data: response.data) else {
                    completion(nil)
                    return
                }
                
                // 데이터를 새로 받아올 때 캐시에 저장
                self.uploadToNSCache(urlString: urlString, image: image)
                
                completion(image)
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
                
                completion(nil)
            }
        }
    }
    
    /// 캐싱된 이미지 로드
    private func loadFromNSCacheImage(imageURL: String) -> UIImage? {
        return cache.object(forKey: imageURL as NSString)
    }
    
    /// NSCache에 업로드
    private func uploadToNSCache(urlString: String, image: UIImage) {
        cache.setObject(image, forKey: urlString as NSString)
    }
}

