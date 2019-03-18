//
//  GetTopHeadlinesUseCase.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias GetTopHeadlinesUseCaseCompletionHandler = (_ topHeadlines: [NewsArticle]?) -> ()

protocol GetTopHeadlinesUseCase {
    func getTopHeadlines(query: String?, completionHandler: @escaping GetTopHeadlinesUseCaseCompletionHandler)
}

class GetTopHeadlinesUseCaseImplementation: GetTopHeadlinesUseCase {
    
    private let _disposeBag = DisposeBag()
    
    private let _newsGateway: NewsGateway?
    private let _udClient   : UserDefaultsClient?
    
    init(newsGateway: NewsGateway, udClient: UserDefaultsClient) {
        self._newsGateway   = newsGateway
        self._udClient      = udClient
    }
    
    func getTopHeadlines(query: String?, completionHandler: @escaping GetTopHeadlinesUseCaseCompletionHandler) {
        _newsGateway?.getTopHeadlines(for: query,
                                      country: _udClient?.getDefaultCountry(),
                                      categories: _udClient?.getDefaultCategories(),
                                      sources: _udClient?.getDefaultSources(),
                                      completionHandler: { [weak self] (observableResult) in
            guard let self = self else { return }
            observableResult.subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    completionHandler(response.articles)
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
