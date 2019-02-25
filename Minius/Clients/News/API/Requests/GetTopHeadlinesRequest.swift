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
    
    init(country: NewsAPICountry? = .Portugal, category: NewsAPICategory? = nil, source: String? = nil, query: String? = nil) throws {
        body = nil
        method = .get
        
        var buildURL = URLComponents(string: NewsAPI.sharedInstance.getURLString(for: .topHeadlines))
        var queryItems = [URLQueryItem]()
            
        if let country = country { queryItems.append(URLQueryItem(name: "country", value: country.countryCode())) }
        if let category = category { queryItems.append(URLQueryItem(name: "category", value: category.rawValue)) }
        if let source = source { queryItems.append(URLQueryItem(name: "sources", value: source)) }
        if let query = query { queryItems.append(URLQueryItem(name: "q", value: query)) }
        
        if !queryItems.isEmpty { buildURL?.queryItems = queryItems }
        
        guard let finalURL = try? buildURL?.asURL() else { throw RequestError.BuildRequest.unwrapURL }
        url = finalURL!
    }
    
    func toURLRequest() -> URLRequest? {
        return try? URLRequest(url: url, method: method, headers: headers)
    }
    
}
