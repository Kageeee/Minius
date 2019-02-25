//
//  APIRequestProtocol.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import Alamofire

typealias HTTPBodyType = [String: Any]

protocol APIRequestProtocol {
    var url         : URL { get }
    var headers     : [String: String]? { get }
    var body        : HTTPBodyType? { get }
    var method      : HTTPMethod { get }
    
    func toURLRequest() -> URLRequest?
}

extension APIRequestProtocol {
    
    var headers     : [String: String]? {
        return nil
    }
    
    var body        : HTTPBodyType? {
        return nil
    }
    
    var method      : HTTPMethod {
        return .get
    }
    
    func toURLRequest() -> URLRequest? {
        return try? URLRequest(url: url, method: method, headers: headers)
    }
    
}
