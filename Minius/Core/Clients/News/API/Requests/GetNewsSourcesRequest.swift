//
//  GetNewsSourcesRequest.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import Alamofire

class GetNewsSourcesRequest : NewsAPIRequestProtocol {
    
    var url: URL
    var body: HTTPBodyType?
    var method: HTTPMethod
    
    init(language: String? = nil, country: NewsAPICountry? = .Portugal, category: [NewsAPICategory]? = nil) throws {
        body = nil
        method = .get
        
        var buildURL = URLComponents(string: NewsAPI.sharedInstance.getURLString(for: .sources))
        var queryItems = [URLQueryItem]()
            
        if let country = country { queryItems.append(URLQueryItem(name: "country", value: country.countryCode())) }
        if let category = category?.first, category != .None { queryItems.append(URLQueryItem(name: "category", value: category.rawValue)) }
        if let language = language { queryItems.append(URLQueryItem(name: "language", value: language)) }
        
        if !queryItems.isEmpty { buildURL?.queryItems = queryItems }
        
        guard let finalURL = try? buildURL?.asURL() else { throw RequestError.BuildRequest.unwrapURL }
        url = finalURL!
    }
    
}
