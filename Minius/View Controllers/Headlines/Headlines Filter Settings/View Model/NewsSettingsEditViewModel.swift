//
//  NewsSettingsEditViewModel.swift
//  Minius
//
//  Created by Miguel Alcântara on 01/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol NewsSettingsEditViewModelInput: ViewModelInput {
    func buildList(for filter: SettingsFilter)
    func tappedCell(with value: String)
    func scrollToSelected()
}

protocol NewsSettingsEditViewModelOutput: ViewModelOutput {
    var settingsList: Driver<[HeadlineFilterCellViewModel]> { get }
}

protocol NewsSettingsEditViewModelType: ViewModelType {
    var input: NewsSettingsEditViewModelInput { get }
    var output: NewsSettingsEditViewModelOutput { get }
}


class NewsSettingsEditViewModel: NewsSettingsEditViewModelType, NewsSettingsEditViewModelInput, NewsSettingsEditViewModelOutput {
    
    var input: NewsSettingsEditViewModelInput { return self }
    var output: NewsSettingsEditViewModelOutput { return self }
    
    private let disposeBag = DisposeBag()
    private let _udClient: UserDefaultsClient
    
    private var _settingsListRelay  = BehaviorRelay<[HeadlineFilterCellViewModel]>(value: [])
    private var _dismissVCRelay  = PublishRelay<Void>()
    
    private var filter: SettingsFilter!
    
    //Use Cases
    private var _getCountriesUseCase: GetNewsCountriesUseCase!
    private var _getCategoriesUseCase: GetNewsCategoriesUseCase!
    private var _getSourcesUseCase: GetNewsSourcesUseCase!
    
    var settingsList: Driver<[HeadlineFilterCellViewModel]>
    
    init(udClient: UserDefaultsClient,
         getCountriesUseCase: GetNewsCountriesUseCase,
         getCategoriesUseCase: GetNewsCategoriesUseCase,
         getSourcesUseCase: GetNewsSourcesUseCase) {
        _udClient = udClient
        _getCountriesUseCase = getCountriesUseCase
        _getCategoriesUseCase = getCategoriesUseCase
        _getSourcesUseCase = getSourcesUseCase
        settingsList = _settingsListRelay.asDriver()
    }
    
    func buildList(for filter: SettingsFilter) {
        self.filter = filter
        switch filter {
        case .country:
            _getCountriesUseCase.getNewsCountries(completionHandler: createCountriesCompletionHandler())
        case .categories:
            _getCategoriesUseCase.getNewsCategories(completionHandler: createCategoriesCompletionHandler())
        default:
            _getSourcesUseCase.getNewsSources(completionHandler: createSourcesCompletionHandler())
        }
    }
    
    func tappedCell(with value: String) {
        guard let filter = filter else { return }
        switch filter {
        case .country:
            guard let country = NewsAPICountry(rawValue: value) else { return }
            _udClient.setDefaultCountry(country: country)
        case .categories:
            let categories = NewsAPICategory.parse(with: value)
            _udClient.setDefaultCategories(categories: categories)
        default:
            return
        }
    }
    
    func scrollToSelected() {
        
    }
    
    func isValueSelected(with value: String) -> Bool {
        return value == _udClient.getDefaultCountry()?.countryCode()
    }
    
    private func updateSettingsList(with list: [HeadlineFilterCellViewModel]?) {
        guard let list = list else { return }
        _settingsListRelay.accept(list)
    }
    
    private func createCountriesCompletionHandler() -> GetNewsCountriesUseCaseCompletionHandler {
        let handler: GetNewsCountriesUseCaseCompletionHandler = { [weak self] countries in
            guard let self = self else { return }
            self.updateSettingsList(with: countries?.compactMap({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue, value: $0.rawValue) }))
        }
        
        return handler
    }
    
    private func createCategoriesCompletionHandler() -> GetNewsCategoriesUseCaseCompletionHandler {
        let handler: GetNewsCategoriesUseCaseCompletionHandler = { [weak self] categories in
            guard let self = self else { return }
            self.updateSettingsList(with: categories?.compactMap({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue.titleCased, value: $0.rawValue) }))
        }
        
        return handler
    }
    
    private func createSourcesCompletionHandler() -> GetNewsSourcesUseCaseCompletionHandler {
        let handler: GetNewsSourcesUseCaseCompletionHandler = { [weak self] sources in
            guard let self = self else { return }
            self.updateSettingsList(with: sources?.compactMap({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.name, value: $0.id) }))
        }
        
        return handler
    }
    
}


