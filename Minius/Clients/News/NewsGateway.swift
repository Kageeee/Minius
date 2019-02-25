//
//  NewsGateway.swift
//  Minius
//
//  Created by Miguel Alcântara on 21/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

protocol NewsGateway {
    func getTopHeadlines(for country: NewsAPICountry)
}
