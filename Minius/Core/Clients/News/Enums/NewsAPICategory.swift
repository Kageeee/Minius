//
//  NewsAPICategory.swift
//  Minius
//
//  Created by Miguel Alcântara on 21/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

enum NewsAPICategory: String {
    
    case None       = "none"
    case Business = "business"
    case Entertainment = "entertainment"
    case General = "general"
    case Health = "health"
    case Science = "science"
    case Sports = "sports"
    case Technology = "technology"
    
    static func toList() -> [NewsAPICategory] {
        return [.None, .Business, .Entertainment, .General, .Health, .Science, .Sports, .Technology]
    }
    
}

extension NewsAPICategory {
    
    static let separator = ", "
    
    static func parse(with string: String) -> [NewsAPICategory] {
        var list = [NewsAPICategory]()
        _ = string
            .components(separatedBy: NewsAPICategory.separator)
            .map({ list.append(NewsAPICategory(rawValue: $0.lowercased()) ?? .None) })
        
        return list
    }
}

extension Array where Element == NewsAPICategory {
    
    func toString() -> String {
        var outputString = ""
        guard !self.isEmpty else { return NewsAPICategory.None.rawValue.localizedCapitalized }
        forEach { outputString += "\($0.rawValue.localizedCapitalized)\(NewsAPICategory.separator)" }
        outputString.removeLast(2)
        return outputString
    }
    
}
