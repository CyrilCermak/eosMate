//
//  Double+.swift
//  eosMate
//
//  Created by Cyril on 8/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import Darwin

extension Double {
    func roundToTwoDecimal() -> Double {
        return Double(Darwin.round(self * 1000) / 1000)
    }
    
    func formatNumberToMatesDigits() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 6 // maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
