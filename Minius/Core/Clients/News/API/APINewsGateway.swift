//
//  APINewsGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

class APINewsGatewayImplementation: NewsGateway {
    
    func getTopHeadlines(for country: NewsAPICountry?, categories: [NewsAPICategory]?, sources: [NewsSource]?, completionHandler: @escaping GetTopHeadlinesGatewayCompletionHandler) {
        guard let request = try! GetTopHeadlinesRequest(country: country, category: categories, source: sources).toURLRequest() else { return }
        completionHandler(NetworkClient.shared.execute(request: request).asSingle())
    }
    func getNewsSources(for language: String?, country: NewsAPICountry?, categories: [NewsAPICategory]?, completionHandler: @escaping GetNewsSourcesGatewayCompletionHandler) {
        guard let request = try! GetNewsSourcesRequest(language: language, country: country, category: categories).toURLRequest() else { return }
        completionHandler(NetworkClient.shared.execute(request: request).asSingle())
    }
    
}
