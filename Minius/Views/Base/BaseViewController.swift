//
//  BaseViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 27/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import Hero

class BaseViewController: UIViewController {
    
    var isBackgroundTranslucent = true
    var animateBackground = false
    var addGradient = true
    
    var currentGradient: Int = 1
    var gradient = CAGradientLayer()
    
    var mainView = UIView() {
        didSet {
            mainView.hero.id = "backgroundBlurView"
            mainView.hero.modifiers = [.fade]
            mainView.backgroundColor = .clear
            mainView.alpha = 0.5
        }
    }
    
    fileprivate var animationList = [CABasicAnimation]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        hero.isEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackgroundWithGradient()
    }

    func setupBackgroundWithGradient() {
        guard !view.subviews.contains(mainView) else { return }
        mainView.frame = view.bounds        
        gradient = mainView.createBackgroundGradient(alphaLevel: isBackgroundTranslucent ? 0.5 : 1)
        mainView.layer.insertSublayer(gradient, at: 0)
        view.addSubview(mainView)
        view.sendSubviewToBack(mainView)
        guard animateBackground, let animations = gradient.createCradientAnimation(for: UIColor.MiniusColor.getGradientSet(with: isBackgroundTranslucent ? 0.5 : 1), delay: 0, delegate: self) else { return }
        self.animationList = animations
        animateGradient()
    }
//
//    func setupBackgroundWithoutGradient() {
//        mainView = UIVisualEffectView(frame: view.bounds).createBlurEffect(style: .dark, alpha: 1)
//        view.addSubview(mainView)
//        view.sendSubviewToBack(mainView)
//    }
    
    func animateGradient() {
        gradient.add(animationList[currentGradient], forKey: "colorChange")
        currentGradient = ( currentGradient + 1 ) < animationList.count ? currentGradient + 1 : 0
    }
    
    func animateBlur() {
        guard mainView is UIVisualEffectView else { return }
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            (self.mainView as? UIVisualEffectView)?.effect = UIBlurEffect(style: .dark)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BaseViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animation = anim as? CABasicAnimation, flag else { return }
        gradient.colors = animation.toValue as! [CGColor]
        animateGradient()
    }
}
