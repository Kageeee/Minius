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
        
        //News
        defaultContainer.autoregister(NewsGateway.self, initializer: APINewsGatewayImplementation.init)
        defaultContainer.autoregister(GetTopHeadlinesUseCase.self, initializer: GetTopHeadlinesUseCaseImplementation.init)
        
        //Images
        defaultContainer.autoregister(ImagesGateway.self, initializer: APIImagesGatewayImplementation.init)
        defaultContainer.autoregister(FetchImageUseCase.self, initializer: FetchImageUseCaseImplementation.init)
        
        defaultContainer.storyboardInitCompleted(TopHeadlinesViewController.self) { (resolver, controller) in
            controller.getTopHeadlinesUseCase = resolver.resolve(GetTopHeadlinesUseCase.self)
        }
        
    }
}
