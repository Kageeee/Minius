//
//  FetchImageUseCase.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias FetchImageUseCaseCompletionHandler = (_ downloadedImage: UIImage?, _ fromCache: Bool) -> ()

protocol FetchImageUseCase {
    func fetchImage(for urlString: String, completionHandler: @escaping FetchImageUseCaseCompletionHandler)
}

class FetchImageUseCaseImplementation: FetchImageUseCase {
    
    let disposeBag = DisposeBag()
    let apiImagesGateway: APIImagesGateway?
    let localImagesGateway: LocalImagesGateway?
    
    init(apiImagesGateway: APIImagesGateway, localImagesGateway: LocalImagesGateway) {
        self.apiImagesGateway   = apiImagesGateway
        self.localImagesGateway = localImagesGateway
    }
    
    func fetchImage(for urlString: String, completionHandler: @escaping FetchImageUseCaseCompletionHandler) {
        
        fetchCachedImage(for: urlString) { [weak self] (image,_)  in
            guard let self = self else { return }
            if let image = image {
                completionHandler(image,true)
                return
            }
            self.fetchNetworkImage(for: urlString, completionHandler: { (image,_) in
                self.localImagesGateway?.addImageToCache(image: image, key: urlString)
                completionHandler(image, false)
            })
        }
        
    }
    
    private func fetchCachedImage(for urlString: String, completionHandler: @escaping FetchImageUseCaseCompletionHandler) {
        localImagesGateway?.fetchImage(for: urlString, completionHandler: { [weak self] (observableResult) in
            guard let self = self else { return }
            observableResult.subscribe(onSuccess: { (result) in
                switch result {
                case .success(let image):
                    completionHandler(image, true)
                case .failure(_):
                    completionHandler(nil, false)
                }
            }, onError: { _ in
                completionHandler(nil,false)
            }).disposed(by: self.disposeBag)
        })
    }
    
    private func fetchNetworkImage(for urlString: String, completionHandler: @escaping FetchImageUseCaseCompletionHandler) {
        let fromCache = false
        apiImagesGateway?.fetchImage(for: urlString, completionHandler: { [weak self] (observableResult) in
            guard let self = self else { return }
            observableResult.subscribe(onSuccess: { (result) in
                switch result {
                case .success(let image):
                    completionHandler(image, fromCache)
                case .failure(_):
                    completionHandler(nil, fromCache)
                }
            }, onError: { _ in
                completionHandler(nil, fromCache)
            }).disposed(by: self.disposeBag)
        })
    }
    
}
