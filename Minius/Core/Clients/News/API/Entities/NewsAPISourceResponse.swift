//
//  NewsAPISourceResponse.swift
//  Minius
//
//  Created by Miguel Alcântara on 12/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let newsAPIError = try? newJSONDecoder().decode(NewsAPIError.self, from: jsonData)

import Foundation

class NewsAPISourceResponse: Codable {
    let status: String
    let sources: [NewsAPISource]
    
    init(status: String, sources: [NewsAPISource]) {
        self.status = status
        self.sources = sources
    }
}
