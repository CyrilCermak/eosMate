//
//  eosMateError.swift
//  eosMate
//
//  Created by Cyril on 3/9/17.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation

protocol AMErrorProtocol: Error {
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var code: Int { get }
}

struct AMError: AMErrorProtocol {
    var localizedTitle: String
    var localizedDescription: String
    var code: Int
}

struct EosMateError: Error {
    var localizedTitle: String
    var localizedDescription: String
    var code: Int
}
