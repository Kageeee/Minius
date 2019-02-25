//
//  NewsAPIResponse.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
    
    init(status: String, totalResults: Int, articles: [NewsArticle]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}
