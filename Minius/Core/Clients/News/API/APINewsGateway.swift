//
//  APINewsGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

class APINewsGatewayImplementation: NewsGateway {
    
    func getTopHeadlines(for country: NewsAPICountry?, completionHandler: @escaping GetTopHeadlinesGatewayCompletionHandler) {
        guard let request = try! GetTopHeadlinesRequest(country: country).toURLRequest() else { return }
        completionHandler(NetworkClient.shared.execute(request: request).asSingle())
    }
    
}
