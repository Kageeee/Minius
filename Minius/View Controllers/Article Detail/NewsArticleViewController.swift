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

    @IBOutlet weak var _ivArticleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var _ivArticleCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var _webViewTopConstraint: NSLayoutConstraint!
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
    
    var viewModel: NewsArticleViewViewModel!
    var article: NewsArticle!
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleView()
        _webViewTopConstraint.constant = view.bounds.height
        setupViewModel()
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        let currentProgress = Float(webView?.estimatedProgress ?? 0)
        MiniusLoader.updateLoadingProgress(with: CGFloat(currentProgress), animate: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBlurEffect(for: _articleImageView, alpha: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupViewModel() {
        viewModel.output.showImage
            .drive(_articleImageView.rx.image)
            .disposed(by: _disposeBag)

        viewModel.output.loadingState
            .drive(onNext: { startLoading in
                if startLoading { MiniusLoader.start(in: self.view) }
                else { MiniusLoader.stop() }
            })
            .disposed(by: _disposeBag)
        
        viewModel.output.viewTitle
            .drive(_label.rx.text)
            .disposed(by: _disposeBag)
        
        viewModel.output.urlPresent.drive(onNext: { [unowned self] url in
            self.showSafariVC(with: url)
        }).disposed(by: _disposeBag)
        
    }
    
    private func setupTitleView() {
        _label.hero.id = "sourceName"
        _label.hero.modifiers = [.useGlobalCoordinateSpace]
        navigationItem.titleView = _label
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
    
}

extension NewsArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _isWebViewLoaded = true
        viewModel.finishedLoading()
        MiniusLoader.stop()
        _ivArticleTopConstraint.isActive = true
        _ivArticleCenterYConstraint.isActive = false
        _webViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.5) { [unowned self] in
            webView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
    }
    
}


extension NewsArticleViewController {
    
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        super.animationDidStop(anim, finished: flag)
    }
    
}
