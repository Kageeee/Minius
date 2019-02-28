//
//  UserDefaultsClient.swift
//  Minius
//
//  Created by Miguel Alcântara on 28/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case country
    case categories
    case sources
}

protocol UserDefaultsClient {
    func setDefaultCountry(country: NewsAPICountry)
    func setDefaultCategories(categories: [NewsAPICategory])
    func setDefaultSources(sources: [NewsSource])
    func getDefaultCountry() -> NewsAPICountry?
    func getDefaultCategories() -> [NewsAPICategory]?
    func getDefaultSources() -> [NewsSource]?
}

class UserDefaultsClientImplementation: UserDefaultsClient {
    
    private let _userDefaults: UserDefaults
    
    init() {
        _userDefaults = UserDefaults.standard
    }
    
    func setDefaultCountry(country: NewsAPICountry) {
        setObject(value: country, defaultsKey: .country)
    }
    
    func setDefaultCategories(categories: [NewsAPICategory]) {
        setObject(value: categories, defaultsKey: .categories)
    }
    
    func setDefaultSources(sources: [NewsSource]) {
        setObject(value: sources, defaultsKey: .sources)
    }
    
    func getDefaultCountry() -> NewsAPICountry? {
        return getObject(for: .country) as? NewsAPICountry
    }
    
    func getDefaultCategories() -> [NewsAPICategory]? {
        return getObject(for: .categories) as? [NewsAPICategory]
    }
    
    func getDefaultSources() -> [NewsSource]? {
        return getObject(for: .sources) as? [NewsSource]
    }
    
    private func setObject(value: Any, defaultsKey: UserDefaultsKeys) {
        _userDefaults.set(value, forKey: defaultsKey.rawValue)
    }
    
    private func getObject(for defaultsKey: UserDefaultsKeys) -> Any? {
        return _userDefaults.object(forKey: defaultsKey.rawValue)
    }
    
}
