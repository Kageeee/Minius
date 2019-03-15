//
//  NewsArticleViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import Hero
import RxSwift
import RxCocoa
import WebKit

class NewsArticleViewController: BaseViewController {

    @IBOutlet weak var loadingImageView: MiniusLoader! {
        didSet {
            loadingImageView.hero.id = "settingsButton"
        }
    }
    @IBOutlet weak var _ivArticleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var _ivArticleCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var _webViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var webViewLoadProgressBar: UIProgressView!
    @IBOutlet weak var loadingContentView: UIView!
    @IBOutlet weak var backButton: MiniusButton! {
        didSet {
            backButton.hero.modifiers = [.fade, .useGlobalCoordinateSpace]
            backButton.hero.id = "settingsButton"
        }
    }
    
    @IBAction func buttonPressed(_ sender: MiniusButton) {
        hero.dismissViewController()
    }
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.hero.id = "dummyView"
            webView.hero.modifiers = [.forceNonFade, .useGlobalCoordinateSpace]
            webView.alpha = 0
            webView.navigationDelegate = self
        }
    }
    
    @IBOutlet weak var _articleImageView: UIImageView! {
        didSet {
            _articleImageView.hero.id = "ivArticleTitle"
            _articleImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var _loadingActivityIndicator: UIActivityIndicatorView! {
        didSet {
            _loadingActivityIndicator.hidesWhenStopped = true
            _loadingActivityIndicator.style = .whiteLarge
        }
    }
    
    private let _disposeBag = DisposeBag()
    private var _isWebViewLoaded = false
    private let _label = UILabel()
    private let _shapeLayer = CAShapeLayer()
    
    var viewModel: NewsArticleViewViewModel!
    var article: NewsArticle!
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _label.hero.id = "sourceName"
        _label.hero.modifiers = [.useGlobalCoordinateSpace]
        navigationItem.titleView = _label
        _webViewTopConstraint.constant = view.bounds.height
        setupViewModel()
        
        webViewLoadProgressBar.layer.mask = webViewLoadProgressBar.createGradientLayer(with: webViewLoadProgressBar.bounds, endPoint: CGPoint(x: 1, y: 0))
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        let currentProgress = Float(webView?.estimatedProgress ?? 0)
        _shapeLayer.strokeEnd = CGFloat(currentProgress)
        _articleImageView.removeBlurEffect()
        addBlurEffect(for: _articleImageView, alpha: CGFloat(1-currentProgress))
        webViewLoadProgressBar.setProgress(currentProgress, animated: true)
        loadingImageView.updateProgress(with: CGFloat(currentProgress), animate: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBlurEffect(for: _articleImageView, alpha: 1)
//        setupImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addLayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        guard !_isWebViewLoaded else { _articleImageView.removeBlurEffect(); return }
//        addBlurEffect(for: _articleImageView)
       
    }
    
    private func setupViewModel() {
        viewModel.output.showImage
            .drive(_articleImageView.rx.image)
            .disposed(by: _disposeBag)

        viewModel.output.loadingState
            .drive(_loadingActivityIndicator.rx.isAnimating)
            .disposed(by: _disposeBag)
        
        viewModel.output.viewTitle
            .drive(_label.rx.text)
            .disposed(by: _disposeBag)
        
        viewModel.output.urlPresent.drive(onNext: { [unowned self] url in
            self.showSafariVC(with: url)
        }).disposed(by: _disposeBag)
        
    }
    
    private func showSafariVC(with URL: URL) {
        webView.load(URLRequest(url: URL))
    }
    
    private func addBlurEffect(for view: UIView, alpha: CGFloat = 1) {
        let blurEffectView = UIView().createBlurEffect(style: .dark, alpha: alpha)
        view.removeBlurEffect()
        view.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.addDefaultConstraints(referencing: view)
        blurEffectView.layer.mask = view.createGradientLayer(with: view.bounds, endPoint: CGPoint(x: 0, y: 1))
        view.layoutIfNeeded()
    }
    
    func addLayer() {
        _shapeLayer.removeFromSuperlayer()
        _shapeLayer.fillColor = UIColor.clear.cgColor
        _shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: _articleImageView.bounds.width / 2, y: _articleImageView.bounds.height / 2), radius: _articleImageView.bounds.height / 2, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        _shapeLayer.strokeColor = UIColor.red.cgColor
        _shapeLayer.lineWidth = 5
        _shapeLayer.strokeEnd = 0
        _articleImageView.layer.addSublayer(_shapeLayer)
    }
    
    private func setupImageView() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.toValue = CGFloat.pi * 2 * 5
        anim.duration = 2
        anim.isCumulative = true
        anim.repeatCount = .greatestFiniteMagnitude
        anim.timingFunction = .easeInOut
        
        loadingImageView.layer.add(anim, forKey: "rotating")
    }
    
    
    
}

extension NewsArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _isWebViewLoaded = true
        viewModel.finishedLoading()
        _ivArticleTopConstraint.isActive = true
        _ivArticleCenterYConstraint.isActive = false
        _webViewTopConstraint.constant = 0
        _shapeLayer.strokeStart = 1
        UIView.animate(withDuration: 0.5) { [unowned self] in
//            webView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
    }
    
}


extension NewsArticleViewController {
    
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        super.animationDidStop(anim, finished: flag)
    }
    
}
