//
//  Models.swift
//  Strong
//
//  Created by Nurlybek Saktagan on 17.05.2023.
//

import Foundation

struct CountryModel: Codable {
    var name: NameModel?
    var capital: [String]?
    var cca2: String?
    var population: Int?
    var area: Double?
    var currencies: [String: CurrenciesModel]?
    var flags: FlagsModel?
    var region: String?
    var timezones: [String]?
    var capitalInfo: CapitalInfoModel?
}

struct NameModel: Codable {
    var common: String?
}

struct CurrenciesModel: Codable {
    var name: String?
    var symbol: String?
}

struct FlagsModel: Codable {
    var png: String?
}

struct CapitalInfoModel: Codable {
    var latlng: [Double]?
}
