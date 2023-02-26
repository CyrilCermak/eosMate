//
//  Transactions.swift
//  eosMate
//
//  Created by Cyril on 29/7/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation

struct Transfer: Codable {
    let from: String
    let to: String
    let quantity: String
    let memo: String
}

struct EosTransactionResult {
    let transactionId: String?
}

struct StakeTransfer: Codable {
    var from: String
    var receiver: String
    var stakeNetQuantity: String
    var stakeCpuQuantity: String
    var transfer: UInt = 0
    
    private enum CodingKeys: String, CodingKey {
        case from
        case receiver
        case stakeNetQuantity = "stake_net_quantity"
        case stakeCpuQuantity = "stake_cpu_quantity"
        case transfer
    }
}

struct UnstakeTransfer: Codable {
    var from: String
    var receiver: String
    var unstakeNetQuantity: String
    var unstakeCpuQuantity: String
    var transfer: UInt = 0
    
    private enum CodingKeys: String, CodingKey {
        case from
        case receiver
        case unstakeNetQuantity = "unstake_net_quantity"
        case unstakeCpuQuantity = "unstake_cpu_quantity"
        case transfer
    }
}

struct BuyRam: Codable {
    var payer: String
    var receiver: String
    var quant: String
}

struct SellRam: Codable {
    var account: String
    var bytes: Float
}

struct ToWithMessage: Codable {
    var to: String
    var message: String
}
