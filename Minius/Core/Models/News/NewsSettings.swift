//
//  NewsSettings.swift
//  Minius
//
//  Created by Miguel Alcântara on 28/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

struct NewsSettings {
    let country: NewsAPICountry
    let categories: [NewsAPICategory]?
    let sources: [NewsSource]?
    
    init(country: NewsAPICountry) {
        self.country    = country
        self.categories = nil
        self.sources    = nil
    }
}
