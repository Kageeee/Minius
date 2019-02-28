//
//  HeadlinesFilterViewModel.swift
//  Minius
//
//  Created by Miguel Alcântara on 28/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HeadlinesFilterViewModelInput: ViewModelInput {
    
}

protocol HeadlinesFilterViewModelOutput: ViewModelOutput {
    var settingsList: Driver<[HeadlineFilterCellViewModel]> { get }
}

protocol HeadlinesFilterViewModelType: ViewModelType {
    var input: HeadlinesFilterViewModelInput { get }
    var output: HeadlinesFilterViewModelOutput { get }
}

enum SettingsFilter: String {
    case country
    case category
    case sources
    
    static func filtersList() -> [SettingsFilter] {
        return [.country, .category, .sources]
    }
}

class HeadlinesFilterViewViewModel: BaseViewModel, HeadlinesFilterViewModelType, HeadlinesFilterViewModelInput, HeadlinesFilterViewModelOutput {

    var input: HeadlinesFilterViewModelInput { return self }
    var output: HeadlinesFilterViewModelOutput { return self }
    
    
    private let disposeBag = DisposeBag()
    
    private var _settingsListRelay = BehaviorRelay<[HeadlineFilterCellViewModel]>(value: [])
    
    var settingsList: Driver<[HeadlineFilterCellViewModel]>
    
    init() {
        settingsList = _settingsListRelay.asDriver()
        
        buildSettingsList()
    }
    
    func buildSettingsList() {
        var list = [HeadlineFilterCellViewModel]()
        SettingsFilter.filtersList().forEach({
            list.append(HeadlineFilterCellViewModel(imageTitle: "DefaultImage", title: $0.rawValue.uppercased()))
        })
        
        _settingsListRelay.accept(list)
    }
    
}
