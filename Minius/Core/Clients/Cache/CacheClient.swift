//
//  CacheClient.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

protocol CacheClient {
    func getImage(for key: String) -> UIImage?
    func addImage(with image: UIImage, for key: String)
    func removeImage(for key: String)
}

class CacheClientImplementation: CacheClient {
    
    private let _imageCache: NSCache<NSString, UIImage>
    
    init() {
        _imageCache = NSCache<NSString, UIImage>()
    }
    
    func getImage(for key: String) -> UIImage? {
        return _imageCache.object(forKey: key.toNSString())
    }
    
    func addImage(with image: UIImage, for key: String) {
        _imageCache.setObject(image, forKey: key.toNSString())
    }
    
    func removeImage(for key: String) {
        _imageCache.removeObject(forKey: key.toNSString())
    }
    
    
}
