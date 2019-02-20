//
//  NewsAPI.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

class NewsAPI {
    
    private let _apiKey = "c5eb4a36ccf84cb9b15aa9b24b62dfe8"
    private let _host = "https://newsapi.org/v2"
    
    static let sharedInstance = NewsAPI()
    
    private init() { }
    
    func getHost() -> String {
        return _host
    }
    
    func getKey() -> String {
        return _apiKey
    }
    
}
