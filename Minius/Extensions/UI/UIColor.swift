//
//  UIColor.swift
//  Minius
//
//  Created by Miguel Alcântara on 01/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    struct MiniusColor {
        static let FirstBackgroundGradientColor = UIColor(red: 186/255, green: 162/255, blue: 252/255, alpha: 1)
        static let SecondBackgroundGradientColor = UIColor(red: 176/255, green: 248/255, blue: 242/255, alpha: 1)
        static let ThirdBackgroundGradientColor = UIColor(red: 0/255, green: 33/255, blue: 71/255, alpha: 1)
        static let FourthBackgroundGradientColor = UIColor(red: 47/255, green: 183/255, blue: 186/255, alpha: 1)
        
        static func getGradientSet(with alpha: CGFloat) -> [[CGColor]] {
            return [
                [FirstBackgroundGradientColor.withAlphaComponent(alpha).cgColor, SecondBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [SecondBackgroundGradientColor.withAlphaComponent(alpha).cgColor, ThirdBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [ThirdBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FourthBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [FourthBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FirstBackgroundGradientColor.withAlphaComponent(alpha).cgColor]
            ]
        }
    }
    
}
