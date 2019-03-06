//
//  NewsGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 21/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias GetTopHeadlinesGatewayCompletionHandler = (_ topHeadlinesResponse: Single<Result<NewsAPIResponse>>) -> Void

protocol NewsGateway {
    func getTopHeadlines(for country: NewsAPICountry?, completionHandler: @escaping GetTopHeadlinesGatewayCompletionHandler)
}

