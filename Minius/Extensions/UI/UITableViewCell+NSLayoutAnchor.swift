//
//  UITableViewCell+NSLayoutAnchor.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit



extension UITableViewCell {
    
    func createGradientLayer(with bounds: CGRect? = nil) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
        if bounds != nil { gradient.frame = bounds! }
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        return gradient
    }
   
}
