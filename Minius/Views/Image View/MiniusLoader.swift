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

protocol RDNibs {
    var nibName: String { get }
}

extension RDNibs {
    var nibName: String { return String(describing: type(of: self)) }
}


protocol ViewFromXib { }

extension ViewFromXib where Self: UIView, Self: RDNibs {
    
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


class MiniusLoader: UIView, RDNibs, ViewFromXib {
    
    @IBOutlet weak var progressLoadingView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loaderImageView: UIImageView! {
        didSet {
            setupImage()
        }
    }
    
    @IBOutlet weak var _progressTopConstraint: NSLayoutConstraint!
    
    
    private var _innerLayer: CAShapeLayer = CAShapeLayer()
    private var _outerLayer: CAShapeLayer = CAShapeLayer()
    private var _progressInnerLayer: CAShapeLayer = CAShapeLayer()
    private var _progressOuterLayer: CAShapeLayer = CAShapeLayer()
    private var _progressLoadingLayer: CAShapeLayer = CAShapeLayer()
    private var _blurView: UIVisualEffectView = UIVisualEffectView()
    private var _overlayView: UIView = UIView()
    private var _progressOverlayView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
    }
    
    func updateProgress(with value: CGFloat, animate: Bool) {
        _progressLoadingLayer.removeFromSuperlayer()
        
//        let loadingPercentage = bounds.height * value
        let loadingPercentage = bounds.height * 0.4
        
        let emptyPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: bounds.width, height: loadingPercentage)), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: _overlayView.bounds.width / 10, height: _overlayView.bounds.width / 10))

        let emptyColor = UIColor.clear
        emptyColor.setFill()
        emptyPath.fill()

        let loadingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: bounds.height - loadingPercentage), size: CGSize(width: bounds.width, height: loadingPercentage)), cornerRadius: _overlayView.bounds.width / 10)

        let loadingColor = UIColor.red
        loadingColor.setFill()
        loadingPath.fill()

        let progressPath = UIBezierPath()
        progressPath.append(loadingPath)

        _progressLoadingLayer = CAShapeLayer()
        _progressLoadingLayer.path = progressPath.cgPath
        _progressOverlayView.layer.addSublayer(_progressLoadingLayer)
        
    }
    
    private func setupProgressLoader() {
        progressLoadingView.backgroundColor = .white
        progressLoadingView.transform = CGAffineTransform.init(translationX: 0, y: bounds.height)
        progressLoadingView.layer.cornerRadius = _overlayView.bounds.width / 10
    }
    
    private func setupButton() {
        setupOuterRect()
        setupInnerCircle()
        setupProgressLoader()
        setupAnimations()
    }
    
    private func setupOuterRect() {
        _outerLayer.removeFromSuperlayer()
        _overlayView.removeFromSuperview()
        _progressOverlayView.removeFromSuperview()
        
        _outerLayer.path = UIBezierPath(roundedRect: containerView.bounds , cornerRadius: 5).cgPath
        _progressOuterLayer.path = UIBezierPath(roundedRect: containerView.bounds , cornerRadius: 5).cgPath
        _overlayView = UIView()
        _overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        _overlayView.frame = bounds
        _overlayView.layer.cornerRadius = _overlayView.bounds.width / 10
        _overlayView.clipsToBounds = true
        
        _progressOverlayView = UIView()
        _progressOverlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        _progressOverlayView.frame = bounds
        _progressOverlayView.layer.cornerRadius = _progressOverlayView.bounds.width / 10
        _progressOverlayView.clipsToBounds = false
        
        
        containerView.insertSubview(_overlayView, aboveSubview: progressLoadingView)
        containerView.insertSubview(_progressOverlayView, aboveSubview: progressLoadingView)
    }
    
    private func setupInnerCircle() {
        _innerLayer.removeFromSuperlayer()
        _innerLayer = _overlayView.addTransparentLayer(targetOrigin: _overlayView.bounds.origin.applying(CGAffineTransform.init(translationX: _overlayView.bounds.width / 4, y: _overlayView.bounds.height / 4)), targetWidth: _overlayView.bounds.width / 2, targetHeight: _overlayView.bounds.width / 2, cornerRadius: _overlayView.bounds.width / 4) as! CAShapeLayer
        
        _progressInnerLayer.removeFromSuperlayer()
        _progressInnerLayer = _progressOverlayView.addTransparentLayer(targetOrigin: _progressOverlayView.bounds.origin.applying(CGAffineTransform.init(translationX: _progressOverlayView.bounds.width / 4, y: _progressOverlayView.bounds.height / 4)), targetWidth: _progressOverlayView.bounds.width / 2, targetHeight: _progressOverlayView.bounds.width / 2, cornerRadius: _progressOverlayView.bounds.width / 4) as! CAShapeLayer
        
        
        layoutIfNeeded()
//        _blurView.layer.addSublayer(_innerLayer)
        bringSubviewToFront(loaderImageView)
    }
    
    private func setupAnimations() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.toValue = CGFloat.pi * 2 * 5
        anim.duration = 2
        anim.isCumulative = true
        anim.repeatCount = .greatestFiniteMagnitude
        anim.timingFunction = .easeInOut
        
        loaderImageView.layer.add(anim, forKey: "rotating")
    }
    
    private func setupImage() {
        loaderImageView.image = UIImage(named: "DefaultIcon")
    }
    
}
