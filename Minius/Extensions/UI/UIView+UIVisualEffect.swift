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
                                   colors: UIColor.MiniusColor.getGradientColors(with: alphaLevel),
                                   startPoint: .zero,
                                   endPoint: CGPoint(x: 1, y: 1),
                                   locations: [0.03, 0.23, 0.45, 0.65, 0.87])
    }
    
    open func createGradientLayer(with bounds: CGRect? = nil,
                                  type: CAGradientLayerType = .axial,
                                  colors: [Any] = [UIColor.clear.cgColor, UIColor.white.cgColor],
                                  startPoint: CGPoint = .zero,
                                  endPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                                  locations: [NSNumber]? = nil) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.type = type
        gradient.colors = colors
        gradient.locations = locations
        if bounds != nil { gradient.frame = bounds! }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.drawsAsynchronously = true
        return gradient
    }
    
    final func createBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat, customBounds: CGRect? = nil, inFront: Bool? = true, addVibrancy: Bool = false) -> UIVisualEffectView {
        var visualEffect: UIVisualEffect!
        let blurEffect = UIBlurEffect(style: style)
        visualEffect = addVibrancy ? UIVibrancyEffect(blurEffect: blurEffect) : blurEffect
        let blurView = UIVisualEffectView(effect: visualEffect)
        blurView.frame = customBounds != nil ? customBounds! : self.bounds
        blurView.tag = 111
        blurView.alpha = alpha
        blurView.clipsToBounds = true
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = layer.cornerRadius
        return blurView
    }
    
    final func addBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat, customBounds: CGRect? = nil, inFront: Bool? = true) {
        let blurView = createBlurEffect(style: style, alpha: alpha, customBounds: customBounds, inFront: inFront)
        _ = inFront! ? self.insertSubview(blurView, at: 0) : self.addSubview(blurView)
    }
    
    final func removeBlurEffect() {
        getBlurEffect()?.removeFromSuperview()
    }
    
    final func getBlurEffect() -> UIView? {
        return subviews
            .filter({ $0.tag == 111 })
            .first
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
    
    func createTransparentLayer(targetOrigin: CGPoint,
                                targetWidth: CGFloat,
                                targetHeight: CGFloat,
                                cornerRadius: CGFloat = 0,
                                layerOpacity: Float = 1,
                                contents: Any? = nil) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), cornerRadius: 0)
        let transparentPath = UIBezierPath(roundedRect: CGRect(x: targetOrigin.x, y: targetOrigin.y, width: targetWidth, height: targetHeight), cornerRadius: cornerRadius)
        path.append(transparentPath)
        
        
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.backgroundColor = backgroundColor?.cgColor ?? UIColor.clear.cgColor
        fillLayer.opacity = layerOpacity
        
        layer.contents = contents
        return fillLayer
    }
    
    func addTransparentLayer(targetOrigin: CGPoint,
                             targetWidth: CGFloat,
                             targetHeight: CGFloat,
                             cornerRadius: CGFloat = 0,
                             layerOpacity: Float = 1,
                             contents: Any? = nil) {
        let fillLayer = createTransparentLayer(targetOrigin: targetOrigin, targetWidth: targetWidth, targetHeight: targetHeight, cornerRadius: cornerRadius, layerOpacity: layerOpacity, contents: contents)
        layer.mask = fillLayer
    }
    
}
