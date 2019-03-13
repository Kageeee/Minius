//
//  UIApplication.swift
//  Minius
//
//  Created by Miguel Alcântara on 13/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    class func hasViewController<T>(for vcType: T.Type, _ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        var foundViewController: UIViewController?
        topViewController(base)?.children.forEach({
            if type(of: $0) == vcType {
                foundViewController = $0
                return
            }
            foundViewController = hasViewController(for: vcType, $0)
        })
        return foundViewController
    }
    
}
