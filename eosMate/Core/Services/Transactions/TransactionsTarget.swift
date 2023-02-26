//
//  TransactionsTarget.swift
//  eosMate
//
//  Created by Cyril on 22/9/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation
import Moya

public enum TransactionsEndpoint {
    case pendingTransactions(accountName: String)
    case transaction(request: MateTransactionRequest)
    case deletePendingTransaction(request: MateTransactionRequest)
}

extension TransactionsEndpoint: TargetType {
    public var baseURL: URL {
        return URL(string: Configuration.eosMateAPI)!
    }

    public var path: String {
        switch self {
        case .pendingTransactions: return "/transactions"
        case .transaction: return "/transaction"
        case .deletePendingTransaction: return "/transaction"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .pendingTransactions: return .get
        case .transaction: return .post
        case .deletePendingTransaction: return .delete
        }
    }
    
    public var task: Task {
        switch self {
        case let .pendingTransactions(accountName):
            return .requestParameters(parameters: ["accountName": accountName], encoding: URLEncoding.default)
        case let .transaction(request):
            return .requestJSONEncodable(request)
        case let .deletePendingTransaction(request):
            return .requestJSONEncodable(request)
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .pendingTransactions: return .successCodes
        default: return .successCodes
        }
    }
    
    public var sampleData: Data {
        return "{\"login\": \"xxx\", \"id\": 100}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        let bearer = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImN5cmlsY2VybWFrQGdtYWlsLmNvbSIsImlkIjoiQzAzNEQwN0MtMDYzMC00QTBCLTlENjYtRjRERTRFOUVFNzI2IiwiZmlyc3ROYW1lIjoiQ3lyaWwiLCJsYXN0TmFtZSI6IkNlcm1hayIsIndlYnNpdGUiOiJjeXJpbGNlcm1hay5jb20iLCJjb21wYW55TmFtZSI6IkFjaGlldmVNZSJ9.vm7kP_FpootWCGa1QcYRojdNMYOooMESVPJAoqCo16s"
//        let bearer = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmaXJzdE5hbWUiOiJDeXJpbCIsIndlYnNpdGUiOiJjeXJpbGNlcm1hay5jb20iLCJlbWFpbCI6ImN5cmlsY2VybWFrMkBnbWFpbC5jb20iLCJpZCI6IjQ0MDNBRDM5LTQyMzgtNEUzQS04MkQ0LUVCRTMwNTk2RDQyOSIsImxhc3ROYW1lIjoiQ2VybWFrIiwiY29tcGFueU5hbWUiOiJBY2hpZXZlTWUifQ.a9nwNUyJAitl4jZJm2QUukXOWHDIXmhgA3C0DZz-Spc"
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(bearer)"
        ]
    }
}
