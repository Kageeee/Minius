//
//  FetchImageUseCase.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias FetchImageUseCaseCompletionHandler = (_ downloadedImage: UIImage?) -> ()

protocol FetchImageUseCase {
    func fetchImage(for urlString: String, completionHandler: @escaping FetchImageUseCaseCompletionHandler)
}

class FetchImageUseCaseImplementation: FetchImageUseCase {
    
    let disposeBag = DisposeBag()
    let imagesGateway: ImagesGateway?
    
    init(imagesGateway: ImagesGateway) {
        self.imagesGateway = imagesGateway
    }
    
    func fetchImage(for urlString: String, completionHandler: @escaping FetchImageUseCaseCompletionHandler) {
        imagesGateway?.fetchImage(for: urlString, completionHandler: { [weak self] (observableResult) in
            guard let self = self else { return }
            observableResult.subscribe(onSuccess: { result in
                switch result {
                case .success(let image):
                    completionHandler(image)
                case .failure(let error):
                    completionHandler(nil)
                }
            }, onError: { error in
                completionHandler(nil)
            })
            .disposed(by: self.disposeBag)
        })
    }
    
}
