//
//  APIImagesGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

protocol APIImagesGateway: ImagesGateway { }

class APIImagesGatewayImplementation: APIImagesGateway {
    
    func fetchImage(for urlString: String, completionHandler: FetchImageGatewayCompletionHandler) {
        guard let request = try? FetchImageRequest(urlString: urlString).toURLRequest(), let urlRequest = request else {
            completionHandler(Observable.just(.success(UIImage(named: "DefaultImage")!)).asSingle())
            return
        }
        
        completionHandler(NetworkClient.shared.downloadImage(request: urlRequest).asSingle())
    }
    
}
