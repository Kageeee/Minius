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
