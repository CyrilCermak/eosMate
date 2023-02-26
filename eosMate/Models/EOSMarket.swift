//
//  EOSMarket.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

struct EOSMarket: Codable {
    let id, symbol, name, image: String?
    let currentPrice, marketCap, totalVolume, high24H: Double?
    let low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let roi: Roi?
    var currentRoundedPrice: Double? {
        if let currentPrice = currentPrice {
            return Double(round(1000 * currentPrice) / 1000)
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case roi
    }
}

struct Roi: Codable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}
