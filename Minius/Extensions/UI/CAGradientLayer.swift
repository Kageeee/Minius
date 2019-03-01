//
//  CAGradientLayer.swift
//  Minius
//
//  Created by Miguel Alcântara on 01/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    struct Minius {
        static let duration: CFTimeInterval = 3
    }
    
    private func createCradientAnimation(for colors: [Any], delay: CFTimeInterval, delegate: CAAnimationDelegate? = nil) -> CABasicAnimation? {
        guard let gradientColors = colors as? [CGColor] else { return nil }
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = delegate
        gradientChangeAnimation.duration = Minius.duration
        gradientChangeAnimation.toValue = gradientColors
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        return gradientChangeAnimation

    }
    
    func createCradientAnimation(for colors: [[Any]], delay: CFTimeInterval = 0, delegate: CAAnimationDelegate? = nil) -> [CABasicAnimation]? {
        guard let cgColors = colors as? [[CGColor]] else { return nil }
        return cgColors
            .enumerated()
            .compactMap({
                createCradientAnimation(for: $1,
                                        delay: 0,
                                        delegate: delegate)
            })
        
    }
    
    func animateGradient(to colors: [[Any]], delegate: CAAnimationDelegate? = nil) {
        guard let gradientColors = colors as? [[CGColor]] else { return }
        removeAllAnimations()
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [CAAnimation]()
        
        if let animationList = createCradientAnimation(for: gradientColors) {
            animationGroup.animations = animationList
        }
        animationGroup.duration = CFTimeInterval(animationGroup.animations?.count ?? 1) * Minius.duration
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.delegate = delegate
        animationGroup.timingFunction = .easeInOut
        
        add(animationGroup, forKey: "changeGradient")
    }
    
}
