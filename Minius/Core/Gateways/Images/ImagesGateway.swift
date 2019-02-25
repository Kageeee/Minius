//
//  ImagesGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias FetchImageGatewayCompletionHandler = (_ topHeadlinesResponse: Single<Result<UIImage>>) -> Void

protocol ImagesGateway {
    func fetchImage(for urlString: String, completionHandler: FetchImageGatewayCompletionHandler)
}
