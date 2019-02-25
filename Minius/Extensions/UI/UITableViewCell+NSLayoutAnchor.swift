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
    
    func createGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear, UIColor.black]
        gradient.locations = [0, 1]
        return gradient
    }
   
}
