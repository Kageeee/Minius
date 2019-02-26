//
//  String.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

extension String {
   
    func toNSString() -> NSString {
        return NSString(string: self)
    }
    
}
