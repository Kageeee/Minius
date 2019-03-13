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
        static let FirstBackgroundGradientColor = UIColor(red: 249/255, green: 244/255, blue: 233/255, alpha: 1)
        static let SecondBackgroundGradientColor = UIColor(red: 243/255, green: 220/255, blue: 193/255, alpha: 1)
        static let ThirdBackgroundGradientColor = UIColor(red: 224/255, green: 171/255, blue: 165/255, alpha: 1)
        static let FourthBackgroundGradientColor = UIColor(red: 161/255, green: 127/255, blue: 161/255, alpha: 1)
        static let FifthBackgroundGradientColor = UIColor(red: 115/255, green: 106/255, blue: 152/255, alpha: 1)
        
        static func getGradientSet(with alpha: CGFloat) -> [[CGColor]] {
            return [
                [FirstBackgroundGradientColor.withAlphaComponent(alpha).cgColor, SecondBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [SecondBackgroundGradientColor.withAlphaComponent(alpha).cgColor, ThirdBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [ThirdBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FourthBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [FourthBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FifthBackgroundGradientColor.withAlphaComponent(alpha).cgColor],
                [FifthBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FirstBackgroundGradientColor.withAlphaComponent(alpha).cgColor]
            ]
        }
        
        static func getGradientColors(with alpha: CGFloat) -> [CGColor] {
            return [FirstBackgroundGradientColor.withAlphaComponent(alpha).cgColor, SecondBackgroundGradientColor.withAlphaComponent(alpha).cgColor, ThirdBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FourthBackgroundGradientColor.withAlphaComponent(alpha).cgColor, FifthBackgroundGradientColor.withAlphaComponent(alpha).cgColor]
        }
        
    }
    
}
