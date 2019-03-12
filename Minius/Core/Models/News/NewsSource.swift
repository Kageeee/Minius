//
//  NewsSource.swift
//  Minius
//
//  Created by Miguel Alcântara on 12/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let newsAPIError = try? newJSONDecoder().decode(NewsAPIError.self, from: jsonData)

import Foundation

class NewsSourceList: Codable {
    let status: String
    let sources: [Source]
    
    init(status: String, sources: [Source]) {
        self.status = status
        self.sources = sources
    }
}

class Source: Codable {
    let id, name, description: String
    let url: String
    let category, language, country: String
    
    init(id: String, name: String, description: String, url: String, category: String, language: String, country: String) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}
