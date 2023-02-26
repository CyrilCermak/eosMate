//
//  EOSChart.swift
//  eosMate
//
//  Created by Cyril on 7/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

struct EOSChart: Codable {
    let prices, marketCaps, totalVolumes: [[Double]]?
    
    var priceDataSet: [(x: Double, y: Double)] {
        return prices.map { $0.map { return (x: $0[0], y: $0[1]) } } ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
}
