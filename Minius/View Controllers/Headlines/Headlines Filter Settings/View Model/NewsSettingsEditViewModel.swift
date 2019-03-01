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
    
    var settingsList: Driver<[HeadlineFilterCellViewModel]>
    
    init(udClient: UserDefaultsClient) {
        _udClient = udClient
        
        settingsList = _settingsListRelay.asDriver()
    }
    
    func buildList(for filter: SettingsFilter) {
        switch filter {
        case .country:
            _settingsListRelay.accept(NewsAPICountry.toList().map({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue, value: "") }))
        default:
            _settingsListRelay.accept(NewsAPICountry.toList().map({ HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue, value: "") }))
        }
    }
    
}


