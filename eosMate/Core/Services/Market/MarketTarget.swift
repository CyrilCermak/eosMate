//
//  MarketTarget.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import Moya

public enum Market {
    case baseData
    case chart(int: Int)
}

extension Market: TargetType {
    public var baseURL: URL { return URL(string: Configuration.marketAPI)! }
    public var path: String {
        switch self {
        case .baseData: return "/markets"
        case .chart: return "/eos/market_chart"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .baseData: return .requestParameters(parameters: ["vs_currency": "usd", "ids": "eos"], encoding: URLEncoding.default)
        case let .chart(numberOfDays): return .requestParameters(parameters: ["vs_currency": "usd", "days": numberOfDays], encoding: URLEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .baseData: return .successCodes
        default: return .successCodes
        }
    }
    
    public var sampleData: Data {
        return "{\"login\": \"xxx\", \"id\": 100}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
