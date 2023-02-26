//
//  Constants.swift
//  eosMate
//
//  Created by Cyril on 02/07/2017.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Font size
let kFontSizeExtraSmall: CGFloat = 10
let kFontSizeSmall: CGFloat = 12
let kFontSizeMedium: CGFloat = 16
let kFontSizeBig: CGFloat = 22
let kFontSizeExtraBig: CGFloat = 36
let isSmallIPhone: Bool = iPhoneSize.sizeForDevice() == .small
let isMidSizeIphone: Bool = iPhoneSize.sizeForDevice() == .middle
let isIphoneX: Bool = iPhoneSize.sizeForDevice() == .x
let screenSize: CGRect = UIScreen.main.bounds

let kBottomButtonInset = isIphoneX ? -35 : -20

enum iPhoneSize: Int {
    case small = 568
    case middle = 667
    case big = 736
    case x = 812
    case unsupported = 0
    
    static func sizeForDevice() -> iPhoneSize {
        switch Int(UIScreen.main.bounds.height) {
        case iPhoneSize.small.rawValue: return iPhoneSize.small
        case iPhoneSize.middle.rawValue: return iPhoneSize.middle
        case iPhoneSize.big.rawValue: return iPhoneSize.big
        case iPhoneSize.x.rawValue: return iPhoneSize.x
        default: return iPhoneSize.unsupported
        }
    }
}
