//
//  DependencyInjector.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

class DependencyInjector {
    
    static func getFetchImageUseCase() -> FetchImageUseCase? {
        return SwinjectStoryboard.defaultContainer.resolve(FetchImageUseCase.self)
    }
    
}

extension SwinjectStoryboard {
    @objc class func setup() {
        
        //User Defaults
        defaultContainer.autoregister(UserDefaultsClient.self, initializer: UserDefaultsClientImplementation.init).inObjectScope(.container)
        
        //News
        defaultContainer.autoregister(NewsGateway.self, initializer: APINewsGatewayImplementation.init).inObjectScope(.container)
        defaultContainer.autoregister(GetTopHeadlinesUseCase.self, initializer: GetTopHeadlinesUseCaseImplementation.init).inObjectScope(.container)
        
        //Images
        defaultContainer.autoregister(CacheClient.self, initializer: CacheClientImplementation.init).inObjectScope(.container)
        defaultContainer.autoregister(APIImagesGateway.self, initializer: APIImagesGatewayImplementation.init).inObjectScope(.container)
        defaultContainer.autoregister(LocalImagesGateway.self, initializer: LocalImagesGatewayImplementation.init).inObjectScope(.container)
        defaultContainer.autoregister(FetchImageUseCase.self, initializer: FetchImageUseCaseImplementation.init).inObjectScope(.container)
        
        
        
        defaultContainer.autoregister(TopHeadlinesViewViewModel.self, initializer: TopHeadlinesViewViewModel.init)
        defaultContainer.storyboardInitCompleted(TopHeadlinesViewController.self) { (resolver, controller) in
            controller.viewModel = resolver.resolve(TopHeadlinesViewViewModel.self)
        }
        
        defaultContainer.autoregister(NewsArticleViewViewModel.self, initializer: NewsArticleViewViewModel.init)
        defaultContainer.storyboardInitCompleted(NewsArticleViewController.self) { (resolver, controller) in
            controller.viewModel = resolver.resolve(NewsArticleViewViewModel.self)
        }
        
        
        defaultContainer.autoregister(HeadlinesFilterViewViewModel.self, initializer: HeadlinesFilterViewViewModel.init)
        defaultContainer.storyboardInitCompleted(HeadlinesFilterViewController.self) { (resolver, controller) in
            controller.viewModel = resolver.resolve(HeadlinesFilterViewViewModel.self)
        }
        
        defaultContainer.autoregister(NewsSettingsEditViewModel.self, initializer: NewsSettingsEditViewModel.init)
        defaultContainer.storyboardInitCompleted(NewsSettingsEditViewController.self) { (resolver, controller) in
            controller.viewModel = resolver.resolve(NewsSettingsEditViewModel.self)
        }
        
    }
}
