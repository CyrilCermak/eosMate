//
//  ObserverTarget.swift
//  eosMate
//
//  Created by Cyril on 4/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//
import Foundation
import Moya

public enum ObserverAPI {
    case subscribeFor(name: String, amount: Double)
}

extension ObserverAPI: TargetType {
    public var baseURL: URL {
        return URL(string: Configuration.eosMateAPI)!
    }

    public var path: String {
        switch self {
        case .subscribeFor: return "/account"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case let .subscribeFor(name, amount): return .requestParameters(parameters: ["name": name, "amount": "\(amount) EOS"], encoding: JSONEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .subscribeFor: return .successCodes
        }
    }
    
    public var sampleData: Data {
        return "{\"login\": \"xxx\", \"id\": 100}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
