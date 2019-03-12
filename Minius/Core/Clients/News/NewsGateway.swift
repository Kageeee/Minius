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
typealias GetNewsSourcesGatewayCompletionHandler = (_ newsSourcesResponse: Single<Result<NewsAPISourceResponse>>) -> Void

protocol NewsGateway {
    func getTopHeadlines(for country: NewsAPICountry?, categories: [NewsAPICategory]?, sources: [NewsSource]?, completionHandler: @escaping GetTopHeadlinesGatewayCompletionHandler)
    func getNewsSources(for language: String?, country: NewsAPICountry?, categories: [NewsAPICategory]?, completionHandler: @escaping GetNewsSourcesGatewayCompletionHandler)
}

