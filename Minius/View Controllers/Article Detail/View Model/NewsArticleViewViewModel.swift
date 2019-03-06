
//
//  NewsArticleViewViewModel.swift
//  Minius
//
//  Created by Miguel Alcântara on 27/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol NewsArticleViewModelInput: ViewModelInput {
    func loadArticle(for article: NewsArticle)
}

protocol NewsArticleViewModelOutput: ViewModelOutput {
    var showImage: Driver<UIImage?> { get }
    var populateTitle: Driver<String> { get }
    var urlPresent: Driver<URL> { get }
    var viewTitle: Driver<String> { get }
    var loadingState: Driver<Bool> { get }
}

protocol NewsArticleViewModelType: ViewModelType {
    var input: NewsArticleViewModelInput { get }
    var output: NewsArticleViewModelOutput { get }
}


class NewsArticleViewViewModel: BaseViewModel, NewsArticleViewModelType, NewsArticleViewModelInput, NewsArticleViewModelOutput {
    
    var input: NewsArticleViewModelInput { return self }
    var output: NewsArticleViewModelOutput { return self }
    
    private var _fetchImageUseCase: FetchImageUseCase?
    private var _article: NewsArticle!
    
    //Input Relay
    private let _articleRelay = PublishRelay<NewsArticle?>()
    
    //Output relay
    private let _imageDownloadRelay = BehaviorRelay<UIImage?>(value: nil)
    private let _viewTitleRelay = BehaviorRelay<String>(value: "")
    private let _articleTitleRelay = BehaviorRelay<String>(value: "")
    private let _detailRelay = BehaviorRelay<URL>(value: URL(string: "www.google.com")!)
    private let _loadingRelay = BehaviorRelay<Bool>(value: true)
    
    var showImage: Driver<UIImage?>
    var populateTitle: Driver<String>
    var urlPresent: Driver<URL>
    var viewTitle: Driver<String>
    var loadingState: Driver<Bool>
    
    init(fetchImageUseCase: FetchImageUseCase) {
        self._fetchImageUseCase = fetchImageUseCase
        
        showImage = _imageDownloadRelay.asDriver()
        populateTitle = _articleTitleRelay.asDriver()
        urlPresent = _detailRelay.asDriver()
        viewTitle = _viewTitleRelay.asDriver()
        loadingState = _loadingRelay.asDriver()
    }
    
    private func createFetchArticleImageHandler() -> (NewsArticle) -> Void {
        return { article in self.fetchImage(for: article) }
    }
    
    private func fetchImage(for article: NewsArticle) {
        _fetchImageUseCase?.fetchImage(for: article.urlToImage ?? "", completionHandler: { [weak self] (image) in
            guard let self = self else { return }
            self._imageDownloadRelay.accept(image)
        })
    }
    
    func loadArticle(for article: NewsArticle) {
        setLoading(with: true)
        fetchImage(for: article)
        showTitle(title: article.title)
        setViewTitle(title: article.source.name)
        initializeSafariVC(with: article.url)
    }
    
    private func showTitle(title: String) {
        _articleTitleRelay.accept(title)
    }
    
    private func setViewTitle(title: String) {
        _viewTitleRelay.accept(title)
    }
    
    private func initializeSafariVC(with url: String) {
        guard let finalURL = URL(string: url) else { return }
        _detailRelay.accept(finalURL)
    }
    
    private func setLoading(with value: Bool) {
        _loadingRelay.accept(value)
    }
}
