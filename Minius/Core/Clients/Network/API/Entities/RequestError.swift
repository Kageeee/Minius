//
//  RequestError.swift
//  Minius
//
//  Created by Miguel Alcântara on 21/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

struct RequestError {
    
    enum BuildRequest: Error {
        case unwrapURL
    }
    
    enum ParsingRequest: Error {
        case imageDataCorrupt
    }
    
}
