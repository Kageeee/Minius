//
//  LocalImagesGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol LocalImagesGateway: ImagesGateway {
    func addImageToCache(image: UIImage?, key: String)
}

class LocalImagesGatewayImplementation: LocalImagesGateway {
    
    let cacheClient: CacheClient
    
    init(cacheClient: CacheClient) {
        self.cacheClient = cacheClient
    }
    
    func addImageToCache(image: UIImage?, key: String) {
        guard let image = image else { return }
        cacheClient.addImage(with: image, for: key)
    }
    
    func fetchImage(for urlString: String, completionHandler: FetchImageGatewayCompletionHandler) {
        let image = cacheClient.getImage(for: urlString)
        let result: Result<UIImage> = image == nil ? .failure(RequestError.BuildRequest.unwrapURL) : .success(image!)
        completionHandler(Observable.just(result).asSingle())
    }
    
}
