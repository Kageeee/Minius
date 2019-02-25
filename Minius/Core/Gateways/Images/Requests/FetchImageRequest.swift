//
//  FetchImageRequest.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import Alamofire

class FetchImageRequest: APIRequestProtocol {
    
    var url: URL
    
    init(urlString: String) throws {
        guard let finalURL = URL(string: urlString) else { throw RequestError.BuildRequest.unwrapURL }
        url = finalURL
    }
    
    
}
