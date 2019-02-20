//
//  GetTopHeadlinesRequest.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import Alamofire

class GetTopHeadlinesRequest : NewsAPIRequestProtocol {
    
    var url: URL
    var body: HTTPBodyType?
    var method: HTTPMethod
    
    init(country: String = "pt") {
        body = nil
        method = .get
        
        let urlString = NewsAPI.sharedInstance.getURLString(for: .topHeadlines) + "?country=\(country)"
        url = URL(string: urlString)!
    }
    
    func toURLRequest() -> URLRequest? {
        return try? URLRequest(url: url, method: method, headers: headers)
    }
    
}
