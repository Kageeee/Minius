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
    
    public class var sharedInstance: MiniusLoader {
        struct Singleton {
            static let instance = MiniusLoader(frame: CGRect.zero)
        }
        return Singleton.instance
    }
    
    //UI Components
    private var _mainView: UIView?
    private var _progressLoadingView: UIView = UIView(frame: .zero)
    private var _containerView: UIView = UIView(frame: .zero)
    private var _loaderImageView: UIImageView = UIImageView(frame: .zero)
    private var _overlayView: UIView = UIView(frame: .zero)
    private var _progressOverlayView: UIView = UIView(frame: .zero)
    private var _progressInnerLayer: CAShapeLayer = CAShapeLayer()
    private var _progressLoadingLayer: CAShapeLayer = CAShapeLayer()
    private var _mainBlurView: UIVisualEffectView = UIVisualEffectView(frame: .zero)
    
    //UI Parameters
    private var _progressViewBackgroundColor: UIColor = .clear
    private var _loadingViewLayerCornerRadius: CGFloat = 25
    private var _loadingViewLayerFillColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    private var _progressColor: UIColor = UIColor.MiniusColor.FifthBackgroundGradientColor
    private var _addProgressBlur: Bool = true
    
    //Animation parameters
    private var _completeAnimation = false
    private let _rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    //Exposed functions
    static func start(in view: UIView) {
        let loader = sharedInstance
        loader.alpha = 0
        loader._mainView = view
        view.addSubview(sharedInstance)
        loader.setupMainViewConstraints()
        loader.startAnimating()
    }
    
    static func stop() {
        let loader = sharedInstance
        loader.complete()
    }
    
    static func updateLoadingProgress(with value: CGFloat, animate: Bool) {
        let loader = sharedInstance
        loader.updateProgress(with: value, animate: animate)
    }
    
    
    
    //Private functions
    private func setProgressColor(for color: UIColor?, animated: Bool = true) {
        guard let averageColor = color else { return }
        self._progressColor = averageColor
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self._overlayView.backgroundColor = averageColor
        }
    }
    
    private func updateProgress(with value: CGFloat, animate: Bool) {
        let loadingPercentage = _containerView.bounds.height * value
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self._overlayView.frame = CGRect(origin: CGPoint(x: 0, y: self._containerView.bounds.height - loadingPercentage), size: CGSize(width: self._containerView.bounds.width, height: loadingPercentage))
        }, completion: nil)
    }
    
    private func complete() {
        _completeAnimation = true
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { isCompleted in
            self._completeAnimation = false
            self.removeFromSuperview()
        })
    }
    
    private func setupMainViewConstraints() {
        guard let parentView = _mainView ?? UIApplication.shared.keyWindow else { return }
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 1).isActive = true
        widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 1).isActive = true
        centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    }
    
    private func setupButton() {
        backgroundColor = .clear
        setupBlurView()
        setupContainerView()
        setupLoadingView()
        setupLoaderImageView()
        setupAnimations()
    }
    
    private func setupLoadingView() {
        _containerView.addSubview(_progressLoadingView)
        _progressLoadingView.backgroundColor = _progressViewBackgroundColor
        _progressLoadingView.translatesAutoresizingMaskIntoConstraints = false
        _progressLoadingView.heightAnchor.constraint(equalTo: _containerView.heightAnchor, multiplier: 1).isActive = true
        _progressLoadingView.widthAnchor.constraint(equalTo: _containerView.widthAnchor, multiplier: 1).isActive = true
        _progressLoadingView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _progressLoadingView.centerYAnchor.constraint(equalTo: _containerView.centerYAnchor).isActive = true
        _progressLoadingView.backgroundColor = _progressViewBackgroundColor
    }
    
    private func setupBlurView() {
        _mainBlurView = createBlurEffect(style: .dark, alpha: 1, addVibrancy: false)
        addSubview(_mainBlurView)
        _mainBlurView.backgroundColor = _progressViewBackgroundColor
        _mainBlurView.translatesAutoresizingMaskIntoConstraints = false
        _mainBlurView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        _mainBlurView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        _mainBlurView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _mainBlurView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupContainerView() {
        _mainBlurView.contentView.addSubview(_containerView)
        _containerView.backgroundColor = _progressViewBackgroundColor
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        _containerView.heightAnchor.constraint(equalTo: _containerView.widthAnchor, multiplier: 1).isActive = true
        _containerView.widthAnchor.constraint(equalTo: _mainBlurView.widthAnchor, multiplier: 0.4).isActive = true
        _containerView.centerXAnchor.constraint(equalTo: _mainBlurView.centerXAnchor).isActive = true
        _containerView.centerYAnchor.constraint(equalTo: _mainBlurView.centerYAnchor).isActive = true
    }
    
    private func setupLoaderImageView() {
        setupImage()
        _containerView.addSubview(_loaderImageView)
        _loaderImageView.backgroundColor = _progressViewBackgroundColor
        _loaderImageView.translatesAutoresizingMaskIntoConstraints = false
        _loaderImageView.contentMode = .scaleAspectFill
        _loaderImageView.heightAnchor.constraint(equalTo: _loaderImageView.widthAnchor, multiplier: 1).isActive = true
        _loaderImageView.widthAnchor.constraint(equalTo: _containerView.widthAnchor, multiplier: 0.5).isActive = true
        _loaderImageView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _loaderImageView.centerYAnchor.constraint(equalTo: _containerView.centerYAnchor).isActive = true
        
        _containerView.bringSubviewToFront(_loaderImageView)
        
    }
    private func setupProgressLoader() {
        _progressLoadingLayer.removeFromSuperlayer()
        let loadingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: _containerView.bounds.height), size: CGSize(width: _containerView.bounds.width, height: 0)), cornerRadius: _loadingViewLayerCornerRadius)
        
        _progressLoadingLayer.masksToBounds = true
        _progressLoadingLayer.path = loadingPath.cgPath
        _progressLoadingLayer.fillColor = _loadingViewLayerFillColor.cgColor
        
        _progressLoadingView.layer.cornerRadius = _loadingViewLayerCornerRadius
        _progressOverlayView.layer.addSublayer(_progressLoadingLayer)
    }
    
    private func setupOuterRect() {
        _progressOverlayView.removeFromSuperview()
        _overlayView.removeFromSuperview()
        
        _overlayView = createBlurEffect(style: .dark, alpha: 1, addVibrancy: false)
        _overlayView.frame = CGRect(origin: CGPoint(x: 0, y: _containerView.bounds.height), size: CGSize(width: _containerView.bounds.width, height: 0))
        _overlayView.backgroundColor = _progressColor
        _overlayView.layer.cornerRadius = _loadingViewLayerCornerRadius
        _overlayView.clipsToBounds = true
        
        _progressOverlayView = UIView()
        _progressOverlayView.backgroundColor = UIColor.clear
        _progressOverlayView.frame = _containerView.bounds
        _progressOverlayView.layer.cornerRadius = _loadingViewLayerCornerRadius
        _progressOverlayView.clipsToBounds = false
        if _addProgressBlur { _progressOverlayView.addBlurEffect(style: .regular, alpha: 0.5) }
        
        _progressOverlayView.addSubview(_overlayView)
        _progressOverlayView.sendSubviewToBack(_overlayView)
        _containerView.insertSubview(_progressOverlayView, belowSubview: _progressLoadingView)
        
    }
    
    private func setupInnerCircle() {
        _progressInnerLayer = createTransparentLayer(targetOrigin: _progressOverlayView.bounds.origin.applying(CGAffineTransform.init(translationX: _progressOverlayView.bounds.width / 4, y: _progressOverlayView.bounds.height / 4)), targetWidth: _progressOverlayView.bounds.width / 2, targetHeight: _progressOverlayView.bounds.width / 2, cornerRadius: _progressOverlayView.bounds.width / 4)
        _progressOverlayView.layer.mask = _progressInnerLayer
    }
    
    private func setupAnimations() {
        _rotationAnimation.toValue = (CGFloat.pi * 2) * 3
        _rotationAnimation.duration = 1
        _rotationAnimation.isCumulative = true
        _rotationAnimation.repeatCount = 1
        _rotationAnimation.timingFunction = .easeInOut
        _rotationAnimation.delegate = self
    }
    
    private func startAnimating() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        }, completion: nil)
        _loaderImageView.layer.add(_rotationAnimation, forKey: "rotating")
    }
    
    private func stopAnimating() {
//        _loaderImageView.layer.removeAllAnimations()
    }
    
    private func setupImage() {
        _loaderImageView.image = UIImage(named: "DefaultIcon")
    }
    
    private func updateLayers() {
        setupOuterRect()
        setupInnerCircle()
        setupProgressLoader()
        startAnimating()
    }
    
}

extension MiniusLoader: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard !_completeAnimation && flag else { return }
        startAnimating()
    }
    
}
