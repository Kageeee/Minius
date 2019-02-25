//
//  Result.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
