//
//  RAMRow.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

struct RAMRow: Codable {
    let rows: [Row]?
    let more: Bool?
    
    var ramPrice: Double? {
        if let row = rows?.first {
            if let baseBalance = row.base?.balance?.split(separator: " ").first, let quoteBalance = row.quote?.balance?.split(separator: " ").first,
               let intBaseBalance = Double(baseBalance), let inqQuoteBalance = Double(quoteBalance) {
                let priceInKb = (inqQuoteBalance / (intBaseBalance * 1) * 1024)
                return round(priceInKb * 1000) / 1000
            }
        }
        return nil
    }
}

struct Row: Codable {
    let supply: String?
    let base, quote: Base?
}

struct Base: Codable {
    let balance, weight: String?
}
