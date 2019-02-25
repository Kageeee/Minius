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
    func getTopHeadlines(for country: NewsAPICountry, completionHandler: @escaping GetTopHeadlinesUseCaseCompletionHandler)
}

class GetTopHeadlinesUseCaseImplementation: GetTopHeadlinesUseCase {
    
    let disposeBag = DisposeBag()
    
    let newsGateway: NewsGateway?
    
    init(newsGateway: NewsGateway) {
        self.newsGateway = newsGateway
    }
    
    func getTopHeadlines(for country: NewsAPICountry, completionHandler: @escaping ([NewsArticle]?) -> ()) {
        newsGateway?.getTopHeadlines(for: country, completionHandler: { [weak self] (observableResult) in
            guard let self = self else { return }
            observableResult.subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    completionHandler(response.articles)
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
