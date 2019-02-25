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
    
}

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.autoregister(NewsGateway.self, initializer: APINewsGatewayImplementation.init)
        defaultContainer.autoregister(GetTopHeadlinesUseCase.self, initializer: GetTopHeadlinesUseCaseImplementation.init)
        print("SUCCESS")
        
        defaultContainer.storyboardInitCompleted(ViewController.self) { (resolver, controller) in
            controller.getTopHeadlinesUseCase = resolver.resolve(GetTopHeadlinesUseCase.self)
        }
    }
}
