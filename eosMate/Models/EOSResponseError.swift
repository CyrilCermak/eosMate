//
//  EOSErrorResponse.swift
//  eosMate
//
//  Created by Cyril on 27/8/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation
import PromiseKit

struct EOSResponseError: Codable {
    let code: Int?
    let message: String?
    let responseError: ResponseErrorDetail?
    
    enum CodingKeys: String, CodingKey {
        case code, message
        case responseError = "error"
    }
}

// MARK: - ResponseError
struct ResponseErrorDetail: Codable {
    let code: Int?
    let name, what: String?
    let details: [Detail]?
}

// MARK: - Detail
struct Detail: Codable {
    let message, file: String?
    let lineNumber: Int?
    let method: String?
    
    enum CodingKeys: String, CodingKey {
        case message, file
        case lineNumber = "line_number"
        case method
    }
}

extension NSError {
    var eosResponseError: EOSResponseError? {
        guard let e = self as? PromiseKit.PMKHTTPError else {
            return nil
        }
        guard let responseDict = e.jsonDictionary as? [String: AnyHashable] else {
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: responseDict, options: .sortedKeys)
            return try JSONDecoder().decode(EOSResponseError.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
