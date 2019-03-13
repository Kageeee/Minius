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

    @IBOutlet weak var webViewLoadProgressBar: UIProgressView!
    @IBOutlet weak var loadingContentView: UIView!
    @IBOutlet weak var backButton: MiniusButton! {
        didSet {
            backButton.hero.modifiers = [.fade]
            backButton.hero.id = "settingsButton"
        }
    }
    
    @IBAction func buttonPressed(_ sender: MiniusButton) {
        hero.dismissViewController()
    }
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
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
    
    private let disposeBag = DisposeBag()
    
    var viewModel: NewsArticleViewViewModel!
    var article: NewsArticle!
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        webViewLoadProgressBar.layer.mask = webViewLoadProgressBar.createGradientLayer(with: webViewLoadProgressBar.bounds, endPoint: CGPoint(x: 1, y: 0))
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        let currentProgress = Float(webView?.estimatedProgress ?? 0)
        webViewLoadProgressBar.setProgress(currentProgress, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViewModel() {
        viewModel.output.showImage
            .drive(_articleImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.output.loadingState
            .drive(_loadingActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.urlPresent.drive(onNext: { url in
            self.showSafariVC(with: url)
        }).disposed(by: disposeBag)
        
    }
    
    private func showSafariVC(with URL: URL) {
        webView.load(URLRequest(url: URL))
    }
    
}

extension NewsArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.finishedLoading()
        UIView.animate(withDuration: 0.5) {
            webView.alpha = 1
            self.loadingContentView.alpha = 0
        }
    }
    
}
