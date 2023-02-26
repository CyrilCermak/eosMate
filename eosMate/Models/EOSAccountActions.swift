//
//  EOSAccountActions.swift
//  eosMate
//
//  Created by Cyril on 8/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TransactionType: String, Codable {
    case transfer, stakeTransfer, unstakeTransfer, buyRam, sellRam, toWithMessage, unknown
}

enum EOSXTransactionsSerializer {
    static func transactions(from json: JSON) -> [EOSXTransaction] {
        let actions = json["actions"].array
        var transactions = [EOSXTransaction]()
        for action in actions ?? [] {
            let act = action["action_trace"].dictionary?["act"]
            let blockTime = action["block_time"].string
            let account = act?["account"].string
            var payload: Any?
            var type: TransactionType = .unknown
            
            if let jsonData = act?["data"] {
                if let tr = jsonTo(json: jsonData.dictionaryObject ?? [:], type: Transfer.self) {
                    payload = tr as AnyObject
                    type = .transfer
                } else if let tr = jsonTo(json: jsonData.dictionaryObject ?? [:], type: StakeTransfer.self) {
                    payload = tr as AnyObject
                    type = .stakeTransfer
                } else if let tr = jsonTo(json: jsonData.dictionaryObject ?? [:], type: UnstakeTransfer.self) {
                    payload = tr as AnyObject
                    type = .unstakeTransfer
                } else if let tr = jsonTo(json: jsonData.dictionaryObject ?? [:], type: BuyRam.self) {
                    payload = tr as AnyObject
                    type = .buyRam
                } else if let tr = jsonTo(json: jsonData.dictionaryObject ?? [:], type: SellRam.self) {
                    payload = tr as AnyObject
                    type = .sellRam
                } else if let tr = jsonTo(json: jsonData.dictionaryObject ?? [:], type: ToWithMessage.self) {
                    payload = tr as AnyObject
                    type = .toWithMessage
                } else {
                    payload = jsonData.dictionaryObject
                }
                
                if let dict = jsonData.dictionaryObject {
                    let tr = EOSXTransaction(account: account, payload: payload, dictPayload: dict, blockTime: blockTime, transactionType: type)
                    if let date = Date(yyyyMMddTHHmmss: blockTime) {
                        if transactions.contains(where: { (Date(yyyyMMddTHHmmss: $0.blockTime) ?? Date()) == date }) {
                            continue
                        }
                        
                        transactions.append(tr)
                    }
                }
            }
        }
        
        return transactions.sorted(by: { Date(yyyyMMddTHHmmss: $0.blockTime) ?? Date() > Date(yyyyMMddTHHmmss: $1.blockTime) ?? Date() })
    }
}

struct EOSXAuthorization: Codable {
    let actor: String?
}

struct EOSXTransaction {
    let account: String?
    var payload: Any?
    var dictPayload: [String: Any]?
    var blockTime: String?
    var transactionType: TransactionType = .unknown
    
    var date: Date? {
        guard let blockTime = blockTime else { return nil }
        let dateFormatter = DateFormatter()
        // 2018-07-26T22:29:55.500
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: String(blockTime.split(separator: ".").first ?? ""))
    }
    
    var formattedDate: String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        // 2018-07-26T22:29:55.500
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case from, receiver
        case stakeNetQuantity = "stake_net_quantity"
        case stakeCPUQuantity = "stake_cpu_quantity"
        case transfer, to, quantity, memo, account, permission, parent
    }
}
