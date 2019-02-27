//
//  MiniusButton.swift
//  Minius
//
//  Created by Miguel Alcântara on 27/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit

class MiniusButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var backgroundView = UIView()
    private var buttonImageView = UIImageView()
    
    var rotateAngle: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        transform           = .identity
        titleLabel?.text    = ""
        layer.cornerRadius  = bounds.width / 2
        addBackgroundView()
        addImageView()
        setupActions()
    }
    
    private func addBackgroundView() {
        backgroundView = UIView(frame: bounds)
        backgroundView.isUserInteractionEnabled = false
        let blurEffect = backgroundView.createBlurEffect(style: .dark, alpha: 1)
        blurEffect.layer.cornerRadius = bounds.width / 2
        blurEffect.clipsToBounds = true
        blurEffect.layer.mask = createGradientLayer(with: backgroundView.bounds, type: .conic)
        backgroundView.addSubview(blurEffect)
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
    }
    
    private func addImageView() {
        buttonImageView = UIImageView(frame: bounds)
        buttonImageView.isUserInteractionEnabled = false
        buttonImageView.image = UIImage(named: "DefaultImage")
        addSubview(buttonImageView)
        bringSubviewToFront(buttonImageView)
    }
    
    private func setupActions() {
        addTarget(self, action: #selector(animateButton), for: .touchUpInside)
    }
    
    @objc private func animateButton() {
        rotateAngle += 90
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(rotationAngle: self.rotateAngle)
        }, completion: nil)
        
    }
    
    
}
