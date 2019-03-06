//
//  NewsAPICategory.swift
//  Minius
//
//  Created by Miguel Alcântara on 21/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

enum NewsAPICategory: String {
    case Business = "business"
    case Entertainment = "entertainment"
    case General = "general"
    case Health = "health"
    case Science = "science"
    case Sports = "sports"
    case Technology = "technology"
    
    static func toList() -> [NewsAPICategory] {
        return [.Business, .Entertainment, .General, .Health, .Science, .Sports, .Technology]
    }
}
