//
//  NewsAPI.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

enum NewsAPIEndpoint {
    case topHeadlines
}

enum NewsAPIQueryParameters: String {
    case Country
}

class NewsAPI {
    
    private let _apiKey = "c5eb4a36ccf84cb9b15aa9b24b62dfe8"
    private let _host = "https://newsapi.org/v2"
    
    private let _topHeadlinesEndpoint = "/top-headlines"
    
    static let sharedInstance = NewsAPI()
    
    private init() { }
    
    func getHost() -> String {
        return _host
    }
    
    func getKey() -> String {
        return _apiKey
    }
    
    func getURLString(for endpoint: NewsAPIEndpoint) -> String {
        var host = ""
        switch endpoint {
        case .topHeadlines:
            host = "\(_host)\(_topHeadlinesEndpoint)"
        }
        return host
    }
    
    
}
