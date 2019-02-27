//
//  TopHeadlinesViewViewModel.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class TopHeadlinesViewViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    let input: Input
    let output: Output
    
    struct Input {
        let tappedURL: PublishRelay<String>
    }
    
    struct Output {
        let articleList: Driver<[TopHeadlineCellViewModel]>
        let showDetail: Signal<NewsArticle?>
    }
    
    var getTopHeadlinesUseCase: GetTopHeadlinesUseCase!
    
    //Input Relays
    private var _tappedURLRelay = PublishRelay<String>()
    
    //Output Relays
    private var _articleListRelay = BehaviorRelay<[NewsArticle]>(value: [])
    private var _topHeadlinesRelay = BehaviorRelay<[TopHeadlineCellViewModel]>(value: [])
    private var _showDetailRelay = PublishRelay<NewsArticle?>()
    
    //Private vars
    private var _selectedArticle: NewsArticle?
    
    init(getTopHeadlinesUseCase: GetTopHeadlinesUseCase) {
        self.getTopHeadlinesUseCase = getTopHeadlinesUseCase
        
        input = Input(tappedURL: _tappedURLRelay)
        output = Output(articleList: _topHeadlinesRelay.asDriver(),
                        showDetail: _showDetailRelay.asSignal())
        setupRelays()
        fetchData()
    }
    
    func getSelectedArticle() -> NewsArticle? {
        return _selectedArticle
    }
    
    private func setupRelays() {
        _articleListRelay.subscribe(onNext: { [unowned self] (articleList) in
            self._topHeadlinesRelay.accept(articleList.map { TopHeadlineCellViewModel(imageURL: $0.urlToImage, title: $0.title, url: $0.url) })
        }).disposed(by: disposeBag)
        
        _showDetailRelay
            .subscribe(onNext: { [unowned self] in self._selectedArticle = $0 })
            .disposed(by: disposeBag)
        
        _tappedURLRelay
            .map { url in self._articleListRelay.value.first(where: { $0.url == url }) }
            .bind(to: _showDetailRelay)
            .disposed(by: disposeBag)
        
    }
    
    private func fetchData() {
        createArticleListFetchObservable()
            .subscribe(onNext: { (article) in self._articleListRelay.accept(article) })
            .disposed(by: disposeBag)
    }
    
    private func createArticleListFetchObservable() -> Observable<[NewsArticle]> {
        return Observable<[NewsArticle]>.create { [unowned self] (observer) -> Disposable in
            self.getTopHeadlinesUseCase.getTopHeadlines(for: .Portugal, completionHandler: { articleList in
                observer.onNext(articleList ?? [])
            })
            
            return Disposables.create()
            }
    }
    
}
