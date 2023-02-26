//
//  BlockchainTarget.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import Moya

public enum Blockchain {
    case account(name: String)
    case accountActions(name: String)
    case token(name: String, accountName: String)
    case ram
    case getKeyAccounts(pub: String)
}

extension Blockchain: TargetType {
    public var baseURL: URL {
        switch self {
        case .accountActions: return URL(string: Configuration.accountHistoryAPI)!
        default: return URL(string: Configuration.blockchainAPI)!
        }
    }
    
    public var path: String {
        switch self {
        case .account: return "/chain/get_account"
        case .accountActions: return "/history/get_actions"
        case .getKeyAccounts: return "/history/get_key_accounts"
        case .ram, .token: return "/chain/get_table_rows"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .accountActions:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case let .account(name): return .requestParameters(parameters: ["account_name": name], encoding: JSONEncoding.default)
        case let .accountActions(name): return .requestParameters(parameters: ["account_name": name, "pos": -1, "offset": -100], encoding: URLEncoding.default)
        case .ram: return .requestParameters(parameters: ["scope": "eosio", "code": "eosio", "table": "rammarket", "json": true], encoding: JSONEncoding.default)
        case let .token(tokenName, accountName):
            return .requestParameters(parameters: ["scope": accountName, "code": tokenName, "table": "accounts", "json": true], encoding: JSONEncoding.default)
        case let .getKeyAccounts(pub):
            return .requestParameters(parameters: ["public_key": pub], encoding: JSONEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .account, .accountActions, .ram, .token: return .successCodes
        case .getKeyAccounts: return .none
        }
    }
    
    public var sampleData: Data {
        return "{\"login\": \"xxx\", \"id\": 100}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
