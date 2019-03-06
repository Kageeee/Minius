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
    
    var settingsList: Driver<[HeadlineFilterCellViewModel]>
    
    init(udClient: UserDefaultsClient) {
        _udClient = udClient   
        settingsList = _settingsListRelay.asDriver()
    }
    
    func buildList(for filter: SettingsFilter) {
        self.filter = filter
        switch filter {
        case .country:
            _settingsListRelay.accept(NewsAPICountry.toList().map({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue, value: $0.rawValue) }))
        default:
            _settingsListRelay.accept(NewsAPICountry.toList().map({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue, value: $0.rawValue) }))
        }
    }
    
    func tappedCell(with value: String) {
        guard let filter = filter else { return }
        switch filter {
        case .country:
            guard let country = NewsAPICountry(rawValue: value) else { return }
            _udClient.setDefaultCountry(country: country)
        default:
            return
        }
    }
    
    func scrollToSelected() {
        
    }
    
    func isValueSelected(with value: String) -> Bool {
        return value == _udClient.getDefaultCountry()?.countryCode()
    }
    
}


