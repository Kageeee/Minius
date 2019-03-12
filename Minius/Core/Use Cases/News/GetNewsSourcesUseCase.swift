//
//  GetNewsSourcesUseCase.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias GetNewsSourcesUseCaseCompletionHandler = (_ newsSources: [NewsAPISource]?) -> ()

protocol GetNewsSourcesUseCase {
    func getNewsSources(completionHandler: @escaping GetNewsSourcesUseCaseCompletionHandler)
}

class GetNewsSourcesUseCaseImplementation: GetNewsSourcesUseCase {
    
    private let _disposeBag = DisposeBag()
    
    private let _newsGateway: NewsGateway?
    private let _udClient   : UserDefaultsClient?
    
    init(newsGateway: NewsGateway, udClient: UserDefaultsClient) {
        self._newsGateway   = newsGateway
        self._udClient      = udClient
    }
    
    func getNewsSources(completionHandler: @escaping ([NewsAPISource]?) -> ()) {
        _newsGateway?.getNewsSources(for: nil, country: _udClient?.getDefaultCountry(), categories: _udClient?.getDefaultCategories(), completionHandler: { [weak self] (observableResult) in
            guard let self = self else { return }
            observableResult.subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    completionHandler(response.sources)
                case .failure(_):
                    completionHandler(nil)
                }
            }, onError: { error in
                completionHandler(nil)
            })
                .disposed(by: self._disposeBag)
        })
        
    }
    
}
