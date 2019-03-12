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
    case sources
}

protocol NewsAPIConfiguration {
    func getKey() -> String
    func getHost() -> String
    func getURLString(for endpoint: NewsAPIEndpoint) -> String
}

class NewsAPI: NewsAPIConfiguration {
    
    private let _apiKey: [UInt8] = [34, 69, 21, 38, 81, 13, 86, 81, 2, 23, 3, 118, 103, 44, 0, 83, 7, 82, 65, 47, 4, 78, 17, 115, 100, 43, 119, 66, 20, 34, 0, 84]
    private let _host = "https://newsapi.org/v2"
    private let _topHeadlinesEndpoint = "/top-headlines"
    private let _newsSourcesEndpoint = "/sources"
    
    static let sharedInstance = NewsAPI()
    
    private init() { }
    
    func getHost() -> String {
        return _host
    }
    
    func getKey() -> String {
        return Obfuscator.init().reveal(key: _apiKey)
    }
    
    func getURLString(for endpoint: NewsAPIEndpoint) -> String {
        var host = "\(_host)"
        switch endpoint {
        case .topHeadlines:
            host += "\(_topHeadlinesEndpoint)"
        case .sources:
            host += "\(_newsSourcesEndpoint)"
        }
        return host
    }
    
    
}
