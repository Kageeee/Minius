//
//  NewsArticle.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let newsAPIResponse = try? newJSONDecoder().decode(NewsAPIResponse.self, from: jsonData)

import Foundation

struct NewsArticle: Codable {
    let source: NewsSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    init(source: NewsSource, author: String?, title: String, description: String?, url: String, urlToImage: String?, publishedAt: String, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

struct NewsSource: Codable {
    let id: String?
    let name: String
    
    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}
