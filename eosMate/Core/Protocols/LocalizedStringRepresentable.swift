//
//  Localizable.swift
//  eosMate
//
//  Created by Cyril Cermak on 13.03.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import Foundation

protocol LocalizedStringRepresentable {
    var text: String { get }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localization") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)**", comment: "")
    }
}
