//
//  UIView+UIVisualEffect.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    final func createBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat, customBounds: CGRect? = nil, inFront: Bool? = true) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = customBounds != nil ? customBounds! : self.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin];
        blurView.tag = 111
        blurView.alpha = alpha
        return blurView
    }
    
    final func addBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat, customBounds: CGRect? = nil, inFront: Bool? = true) {
        let blurView = createBlurEffect(style: style, alpha: alpha, customBounds: customBounds, inFront: inFront)
        _ = inFront! ? self.insertSubview(blurView, at: 0) : self.addSubview(blurView)
    }
    
    func addLeadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, active: Bool = true) {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = active
    }
    
    func addTrailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, active: Bool = true) {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = active
    }
    
    func addTopAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, active: Bool = true) {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = active
    }
    
    func addBottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, active: Bool = true) {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = active
    }
    
    func addDefaultConstraints(referencing view: UIView) {
        addLeadingAnchor(to: view.leadingAnchor)
        addTrailingAnchor(to: view.trailingAnchor)
        addBottomAnchor(to: view.bottomAnchor)
        addTopAnchor(to: view.topAnchor)
    }
    
    
}
