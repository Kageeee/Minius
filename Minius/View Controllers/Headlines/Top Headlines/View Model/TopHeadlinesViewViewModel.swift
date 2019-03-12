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

protocol BaseViewModel { }

protocol ViewModelInput {}
protocol ViewModelOutput {}
protocol ViewModelType { }


protocol TopHeadlinesViewModelInput: ViewModelInput {
    func tappedURL(with urlString: String)
    func reloadNews()
}

protocol TopHeadlinesViewModelOutput: ViewModelOutput {
    var showTableView: Driver<Bool> { get }
    var articleList: Driver<[TopHeadlineCellViewModel]> { get }
    var showDetail: Signal<NewsArticle?> { get }
}

protocol TopHeadlinesViewModelType: ViewModelType {
    var input: TopHeadlinesViewModelInput { get }
    var output: TopHeadlinesViewModelOutput { get }
}

class TopHeadlinesViewViewModel: BaseViewModel, TopHeadlinesViewModelType, TopHeadlinesViewModelInput, TopHeadlinesViewModelOutput {
    
    var input: TopHeadlinesViewModelInput { return self }
    var output: TopHeadlinesViewModelOutput { return self }
    
    
    private let _disposeBag = DisposeBag()
    
    var getTopHeadlinesUseCase: GetTopHeadlinesUseCase!
    
    var articleList: Driver<[TopHeadlineCellViewModel]>
    var showDetail: Signal<NewsArticle?>
    var showTableView: Driver<Bool>
    
    //Input Relays
    private var _tappedURLRelay = PublishRelay<String>()
    
    //Output Relays
    private var _articleListRelay = BehaviorRelay<[NewsArticle]>(value: [])
    private var _topHeadlinesRelay = BehaviorRelay<[TopHeadlineCellViewModel]>(value: [])
    private var _showDetailRelay = PublishRelay<NewsArticle?>()
    private var _showTableViewRelay = PublishRelay<Bool>()
    
    //Private vars
    private var _selectedArticle: NewsArticle?
    
    init(getTopHeadlinesUseCase: GetTopHeadlinesUseCase) {
        self.getTopHeadlinesUseCase = getTopHeadlinesUseCase
        
        articleList = _topHeadlinesRelay.asDriver()
        showDetail = _showDetailRelay.asSignal()
        showTableView = _showTableViewRelay.asDriver(onErrorJustReturn: false)
        setupObservers()
        setupRelays()
    }
    
    func getSelectedArticle() -> NewsArticle? {
        return _selectedArticle
    }
    
    private func setupRelays() {
        _articleListRelay.subscribe(onNext: { [unowned self] (articleList) in
            self._topHeadlinesRelay.accept(articleList.map { TopHeadlineCellViewModel(imageURL: $0.urlToImage, sourceName: $0.source.name, title: $0.title, url: $0.url) })
        }).disposed(by: _disposeBag)
        
        _showDetailRelay
            .subscribe(onNext: { [unowned self] in self._selectedArticle = $0 })
            .disposed(by: _disposeBag)
        
        _tappedURLRelay
            .map { url in self._articleListRelay.value.first(where: { $0.url == url }) }
            .bind(to: _showDetailRelay)
            .disposed(by: _disposeBag)
        
    }
    
    private func setupObservers() {
        Observable.combineLatest(UserDefaults.standard.rx.observe(String.self, UserDefaultsKeys.country.rawValue),
                       UserDefaults.standard.rx.observe(String.self, UserDefaultsKeys.categories.rawValue),
                       UserDefaults.standard.rx.observe(String.self, UserDefaultsKeys.sources.rawValue))
            .subscribe(onNext: { [unowned self] _ in
                self.fetchData()
            })
            .disposed(by: _disposeBag)
    }
    
    private func fetchData() {
        createArticleListFetchObservable()
            .subscribe(onNext: { [weak self] (articleList) in
                guard let self = self else { return }
                self._articleListRelay.accept(articleList)
                self._showTableViewRelay.accept(!articleList.isEmpty)
            })
            .disposed(by: _disposeBag)
    }
    
    private func createArticleListFetchObservable() -> Observable<[NewsArticle]> {
        return Observable<[NewsArticle]>.create { [unowned self] (observer) -> Disposable in
            self.getTopHeadlinesUseCase.getTopHeadlines(completionHandler: { articleList in
                observer.onNext(articleList ?? [])
            })
            return Disposables.create()
        }
    }
    
    func tappedURL(with urlString: String) {
        _tappedURLRelay.accept(urlString)
    }
    
    func reloadNews() {
        fetchData()
    }
    
    
}
