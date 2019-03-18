//
//  UIImageView.swift
//  Minius
//
//  Created by Miguel Alcântara on 18/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    final func roundImage(border: Bool? = false) {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true;
        guard border! else { return }
        addRoundBorder()
    }
    
    private func addRoundBorder(borderColor: UIColor? = UIColor.white.withAlphaComponent(0.8), borderWidth: CGFloat? = 8) {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.fillColor = UIColor.clear.cgColor
        border.strokeColor = borderColor?.cgColor
        border.lineWidth = borderWidth!
        
        self.layer.addSublayer(border)
    }
}
