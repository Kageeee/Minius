//
//  NewsAPICountry.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import Foundation

enum NewsAPICountry: String {
    case Argentina                           = "AR"
    case Australia                           = "AU"
    case Austria                             = "AT"
    case Belgium                             = "BE"
    case Brazil                              = "BR"
    case Bulgaria                            = "BG"
    case Canada                              = "CA"
    case China                               = "CN"
    case Colombia                            = "CO"
    case Cuba                                = "CU"
    case CzechRepublic                       = "CZ"
    case Egypt                               = "EG"
    case France                              = "FR"
    case Germany                             = "DE"
    case Greece                              = "GR"
    case HongKong                            = "HK"
    case Hungary                             = "HU"
    case India                               = "IN"
    case Indonesia                           = "ID"
    case Ireland                             = "IE"
    case Israel                              = "IL"
    case Italy                               = "IT"
    case Japan                               = "JP"
    case KoreaRepublic                       = "KR"
    case Latvia                              = "LV"
    case Lithuania                           = "LT"
    case Malaysia                            = "MY"
    case Mexico                              = "MX"
    case Morocco                             = "MA"
    case Netherlands                         = "NL"
    case NewZealand                          = "NZ"
    case Nigeria                             = "NG"
    case Norway                              = "NO"
    case Philippines                         = "PH"
    case Poland                              = "PL"
    case Portugal                            = "PT"
    case Romania                             = "RO"
    case Russia                              = "RU"
    case SaudiArabia                         = "SA"
    case Serbia                              = "RS"
    case Singapore                           = "SG"
    case Slovakia                            = "SK"
    case Slovenia                            = "SI"
    case SouthAfrica                         = "ZA"
    case Sweden                              = "SE"
    case Switzerland                         = "CH"
    case Taiwan                              = "TW"
    case Thailand                            = "TH"
    case Turkey                              = "TR"
    case Ukraine                             = "UA"
    case UnitedArabEmirates                  = "AE"
    case UnitedKingdom                       = "GB"
    case UnitedStates                        = "US"
    case Venezuela                           = "VE"
    
    func countryCode() -> String {
        return self.rawValue.lowercased()
    }
    
}
