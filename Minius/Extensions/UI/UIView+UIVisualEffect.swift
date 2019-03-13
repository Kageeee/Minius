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
    
    open func createBackgroundGradient(alphaLevel: CGFloat = 1) -> CAGradientLayer {
        return createGradientLayer(with: bounds,
                                   type: .axial,
                                   colors: UIColor.MiniusColor.getGradientSet(with: alphaLevel)[1],
                                   startPoint: .zero,
                                   endPoint: CGPoint(x: 0.72, y: 0.72))
    }
    
    open func createGradientLayer(with bounds: CGRect? = nil,
                                  type: CAGradientLayerType = .axial,
                                  colors: [Any] = [UIColor.clear.cgColor, UIColor.white.cgColor],
                                  startPoint: CGPoint = .zero,
                                  endPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                                  locationStart: NSNumber = 0,
                                  locationEnd: NSNumber = 1) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.type = type
        gradient.colors = colors
        if bounds != nil { gradient.frame = bounds! }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.drawsAsynchronously = true
        return gradient
    }
    
    final func createBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat, customBounds: CGRect? = nil, inFront: Bool? = true) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = customBounds != nil ? customBounds! : self.bounds
        blurView.tag = 111
        blurView.alpha = alpha
        return blurView
    }
    
    final func addBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat, customBounds: CGRect? = nil, inFront: Bool? = true) {
        let blurView = createBlurEffect(style: style, alpha: alpha, customBounds: customBounds, inFront: inFront)
        _ = inFront! ? self.insertSubview(blurView, at: 0) : self.addSubview(blurView)
    }
    
    final func removeBlurEffect() {
        subviews
            .filter({ $0.tag == 111 })
            .first?
            .removeFromSuperview()
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
        translatesAutoresizingMaskIntoConstraints = false
        addLeadingAnchor(to: view.leadingAnchor)
        addTrailingAnchor(to: view.trailingAnchor)
        addBottomAnchor(to: view.bottomAnchor)
        addTopAnchor(to: view.topAnchor)
    }
    
    
}
