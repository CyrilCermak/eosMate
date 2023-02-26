//
//  SentTransactionRequest.swift
//  eosMate
//
//  Created by Cyril on 20/6/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation

public enum TransactionRequestType: String, Codable {
    case tokens, ram, stake, custom
    
    var detailName: String {
        switch self {
        case .tokens: return "Token Transfer"
        case .ram: return "RAM Transfer"
        case .stake: return "Stake Transfer"
        case .custom: return "Custom Transaction"
        }
    }
}

public struct MateTransactionRequest: Codable {
    var id: Int
    var type: TransactionRequestType
    
    var transactionName: String
    var accountName: String
    var tableName: String
    var action: String
    var parameters: String
    
    init(id: Int, type: TransactionRequestType, transactionName: String, accountName: String, tableName: String, action: String, parameters: String) {
        self.id = id
        self.type = type
        
        self.transactionName = transactionName
        self.accountName = accountName
        self.tableName = tableName
        self.action = action
        self.parameters = parameters
    }
    
    init(tr: TransactionRequest) {
        id = 0
        type = .custom
        transactionName = tr.transactionName
        accountName = tr.accountName
        tableName = tr.tableName
        action = tr.action
        parameters = tr.parameters
    }
}

public struct TransactionRequest: Codable {
    var transactionName: String
    var accountName: String
    var tableName: String
    var action: String
    var parameters: String
    
    init(tr: MateTransactionRequest) {
        transactionName = tr.transactionName
        accountName = tr.accountName
        tableName = tr.tableName
        action = tr.action
        parameters = tr.parameters
    }
    
    init(transactionName: String, accountName: String, tableName: String, action: String, parameters: String) {
        self.transactionName = transactionName
        self.accountName = accountName
        self.tableName = tableName
        self.action = action
        self.parameters = parameters
    }
}
