//
//  NewsAPIError.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let newsAPIError = try? newJSONDecoder().decode(NewsAPIError.self, from: jsonData)

import Foundation

class NewsAPIError: Codable {
    let status, code, message: String
    
    init(status: String, code: String, message: String) {
        self.status = status
        self.code = code
        self.message = message
    }
}
