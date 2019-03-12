//
//  GetNewsCountriesUseCase.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift

typealias GetNewsCountriesUseCaseCompletionHandler = (_ newsCountries: [NewsAPICountry]?) -> ()

protocol GetNewsCountriesUseCase {
    func getNewsCountries(completionHandler: @escaping GetNewsCountriesUseCaseCompletionHandler)
}

class GetNewsCountriesUseCaseImplementation: GetNewsCountriesUseCase {
    
    init() { }
    
    func getNewsCountries(completionHandler: @escaping ([NewsAPICountry]?) -> ()) {
        completionHandler(NewsAPICountry.toList())
    }
    
}
