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
    
    var isBackgroundTranslucent = false
    var animateBackground = true
    
    var currentGradient: Int = 0
    var gradient = CAGradientLayer()
    
    fileprivate var animationList = [CABasicAnimation]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        hero.isEnabled = true
        // Do any additional setup after loading the view.
        setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        let bgView = UIView(frame: view.bounds)
        gradient = bgView.createBackgroundGradient(alphaLevel: isBackgroundTranslucent ? 0.5 : 1)
        bgView.layer.insertSublayer(gradient, at: 0)
        
        view.addSubview(bgView)
        view.sendSubviewToBack(bgView)
        guard animateBackground, let animations = gradient.createCradientAnimation(for: UIColor.MiniusColor.getGradientSet(with: isBackgroundTranslucent ? 0.5 : 1), delay: 0, delegate: self) else { return }
        self.animationList = animations
        animateGradient()
    }
    
    func animateGradient() {
        gradient.add(animationList[currentGradient], forKey: "colorChange")
        currentGradient = ( currentGradient + 1 ) < animationList.count ? currentGradient + 1 : 0
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
