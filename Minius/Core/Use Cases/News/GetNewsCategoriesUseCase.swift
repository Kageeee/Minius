//
//  GetNewsCategoriesUseCase.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias GetNewsCategoriesUseCaseCompletionHandler = (_ newsCategories: [NewsAPICategory]?) -> ()

protocol GetNewsCategoriesUseCase {
    func getNewsCategories(completionHandler: @escaping GetNewsCategoriesUseCaseCompletionHandler)
}

class GetNewsCategoriesUseCaseImplementation: GetNewsCategoriesUseCase {
    
    init() { }
    
    func getNewsCategories(completionHandler: @escaping ([NewsAPICategory]?) -> ()) {
        completionHandler(NewsAPICategory.toList())
    }
    
}
