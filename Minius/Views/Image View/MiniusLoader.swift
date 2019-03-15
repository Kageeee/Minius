//
//  MiniusLoader.swift
//  Minius
//
//  Created by Miguel Alcântara on 14/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

import Foundation

protocol MiniusNibs {
    var nibName: String { get }
}

extension MiniusNibs {
    var nibName: String { return String(describing: type(of: self)) }
}


protocol ViewFromXib { }

extension ViewFromXib where Self: UIView, Self: MiniusNibs {
    
    var containerView: UIView? {
        return subviews.first
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromXib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        addSubview(view)
    }
}


@IBDesignable class MiniusLoader: UIView, MiniusNibs, ViewFromXib {
    
    //UI Components
    private var _progressLoadingView: UIView = UIView(frame: .zero)
    private var _containerView: UIView = UIView(frame: .zero)
    private var _loaderImageView: UIImageView = UIImageView(frame: .zero)
    private var _overlayView: UIView = UIView(frame: .zero)
    private var _progressOverlayView: UIView = UIView(frame: .zero)
    private var _progressInnerLayer: CAShapeLayer = CAShapeLayer()
    private var _progressLoadingLayer: CAShapeLayer = CAShapeLayer()
    private var _mainBlurView: UIView = UIView(frame: .zero)
    
    
    //UI Parameters
    private var _progressViewBackgroundColor: UIColor = .clear
    private var _loadingViewLayerCornerRadius: CGFloat = 25
    private var _loadingViewLayerFillColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    private var _progressColor: UIColor = .blue
    private var _addProgressBlur: Bool = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        xibSetup()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        xibSetup()
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        setupButton()
//        _loadingViewLayerCornerRadius = _progressOverlayView.bounds.width / 6
        updateLayers()
    }
    
    //Exposed functions
    func updateProgress(with value: CGFloat, animate: Bool) {
        let loadingPercentage = bounds.height * value
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self._overlayView.frame = CGRect(origin: CGPoint(x: 0, y: self.bounds.height - loadingPercentage), size: CGSize(width: self.bounds.width, height: loadingPercentage))
        }, completion: nil)
    }
    
    func complete() {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }, completion: nil)
    }
    
    
    //Private functions
    private func setupButton() {
        backgroundColor = .clear
        setupContainerView()
        setupLoadingView()
        setupLoaderImageView()
        updateLayers()
    }
    
    private func setupLoadingView() {
        _containerView.addSubview(_progressLoadingView)
        _progressLoadingView.backgroundColor = _progressViewBackgroundColor
        _progressLoadingView.translatesAutoresizingMaskIntoConstraints = false
        _progressLoadingView.heightAnchor.constraint(equalTo: _containerView.heightAnchor, multiplier: 1).isActive = true
        _progressLoadingView.widthAnchor.constraint(equalTo: _containerView.widthAnchor, multiplier: 1).isActive = true
        _progressLoadingView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _progressLoadingView.centerYAnchor.constraint(equalTo: _containerView.centerYAnchor).isActive = true
    }
    
    private func setupContainerView() {
        addSubview(_containerView)
        _containerView.backgroundColor = _progressViewBackgroundColor
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        _containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        _containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        _containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupLoaderImageView() {
        setupImage()
        _containerView.addSubview(_loaderImageView)
        _loaderImageView.backgroundColor = _progressViewBackgroundColor
        _loaderImageView.translatesAutoresizingMaskIntoConstraints = false
        _loaderImageView.contentMode = .scaleAspectFill
        
        _loaderImageView.heightAnchor.constraint(equalTo: _loaderImageView.widthAnchor, multiplier: 1).isActive = true
        _loaderImageView.widthAnchor.constraint(equalTo: _containerView.widthAnchor, multiplier: 0.75).isActive = true
        _loaderImageView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _loaderImageView.centerYAnchor.constraint(equalTo: _containerView.centerYAnchor).isActive = true
        
        
        _containerView.bringSubviewToFront(_loaderImageView)
        
    }
    private func setupProgressLoader() {
        _progressLoadingView.transform = CGAffineTransform.init(translationX: 0, y: _containerView.bounds.height)

        let loadingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: _containerView.bounds.height), size: CGSize(width: _containerView.bounds.width, height: 0)), cornerRadius: _loadingViewLayerCornerRadius)
        
        _progressLoadingLayer.masksToBounds = false
        _progressLoadingLayer.path = loadingPath.cgPath
        _progressLoadingLayer.fillColor = _loadingViewLayerFillColor.cgColor
        
        _progressLoadingView.backgroundColor = _progressViewBackgroundColor
        _progressLoadingView.layer.cornerRadius = _loadingViewLayerCornerRadius
        _progressOverlayView.layer.addSublayer(_progressLoadingLayer)
    }
    
    private func setupOuterRect() {
        _progressOverlayView.removeFromSuperview()
        _overlayView.removeFromSuperview()
        
        _overlayView = createBlurEffect(style: .dark, alpha: 1)
        _overlayView.frame = CGRect(origin: CGPoint(x: 0, y: _containerView.bounds.height), size: _containerView.bounds.size)
        _overlayView.backgroundColor = _progressColor
        _overlayView.layer.cornerRadius = _loadingViewLayerCornerRadius
        _overlayView.clipsToBounds = true
        
        _progressOverlayView = UIView()
        _progressOverlayView.backgroundColor = UIColor.clear
        _progressOverlayView.frame = _containerView.bounds
        _progressOverlayView.layer.cornerRadius = _loadingViewLayerCornerRadius
        _progressOverlayView.clipsToBounds = false
        if _addProgressBlur { _progressOverlayView.addBlurEffect(style: .regular, alpha: 1) }
        
        _progressOverlayView.addSubview(_overlayView)
        _containerView.insertSubview(_progressOverlayView, aboveSubview: _progressLoadingView)
        
    }
    
    private func setupInnerCircle() {
        _progressInnerLayer = createTransparentLayer(targetOrigin: _progressOverlayView.bounds.origin.applying(CGAffineTransform.init(translationX: _progressOverlayView.bounds.width / 4, y: _progressOverlayView.bounds.height / 4)), targetWidth: _progressOverlayView.bounds.width / 2, targetHeight: _progressOverlayView.bounds.width / 2, cornerRadius: _progressOverlayView.bounds.width / 4)
        _progressOverlayView.layer.mask = _progressInnerLayer
    }
    
    private func setupAnimations() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.toValue = (CGFloat.pi * 2) * 3
        anim.duration = 1
        anim.isCumulative = true
        anim.repeatCount = .greatestFiniteMagnitude
        anim.timingFunction = .easeInOut
        
        _loaderImageView.layer.add(anim, forKey: "rotating")
    }
    
    private func setupImage() {
        _loaderImageView.image = UIImage(named: "DefaultIcon")
    }
    
    private func updateLayers() {
        setupOuterRect()
        setupInnerCircle()
        setupProgressLoader()
        setupAnimations()
    }
    
}
