//
//  NewsAPIRequestProtocol.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

protocol NewsAPIRequestProtocol: APIRequestProtocol { }

extension NewsAPIRequestProtocol {
    var headers: [String : String]? {
        return [HTTPHeaders.XApiKey.rawValue:NewsAPI.sharedInstance.getKey()]
    }
}
