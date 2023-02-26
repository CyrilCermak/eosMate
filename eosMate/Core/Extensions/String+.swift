//
//  String+.swift
//  eosMate
//
//  Created by Cyril on 17/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import UIKit

extension String {
    /// iOS bug in times of writing this function where the system locale separator
    /// does not match the actual separator used by the keyboard
    /// this approach should fix it
    func formatAmount() -> String {
        let dotSeparator: Character = "."
        let commaSeparator: Character = ","
        let systemSeparator = Character(Locale.current.decimalSeparator ?? ".")
        if contains(dotSeparator) {
            return "\(addZeroesTo(amount: self, separator: dotSeparator)) EOS"
        }
        if contains(commaSeparator) {
            return "\(addZeroesTo(amount: self, separator: commaSeparator)) EOS"
        }
        if contains(systemSeparator) {
            return "\(addZeroesTo(amount: self, separator: systemSeparator)) EOS"
        }
        return "\(self).0000 EOS"
    }
    
    func supportedFloatString() -> String {
        let dotSeparator = "."
        let commaSeparator = ","
        let systemSeparator = Locale.current.decimalSeparator ?? "."
        if contains(dotSeparator) {
            return replacingOccurrences(of: dotSeparator, with: ".")
        }
        if contains(commaSeparator) {
            return replacingOccurrences(of: commaSeparator, with: ".")
        }
        if contains(systemSeparator) {
            return replacingOccurrences(of: systemSeparator, with: ".")
        }
        return self
    }
    
    private func addZeroesTo(amount: String, separator: Character) -> String {
        guard let dotPart = amount.split(separator: separator).last else { return "\(amount).0000" }
        guard dotPart.count <= 4 else {
            if dotPart.count == 4 { return amount }
            let from = dotPart.startIndex
            let to = dotPart.index(from, offsetBy: 4)
            return "\(amount.split(separator: separator).first!).\(dotPart[from ..< to])"
        }
        let zeroesToAdd = 4 - dotPart.count
        var formattedAmount = amount
        for _ in 0 ..< zeroesToAdd {
            formattedAmount += "0"
        }
        formattedAmount = formattedAmount.replacingOccurrences(of: String(separator), with: ".") /// EOS only supports dot as a decimal separator
        return formattedAmount
    }
    
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let htmlString = try NSMutableAttributedString(data: data,
                                                           options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                                                           documentAttributes: nil)
            htmlString.replaceFonts(with: UIFont.exFontLatoRegular(size: 14))
            return htmlString
        } catch {
            return NSAttributedString()
        }
    }
}

extension NSMutableAttributedString {
    func replaceFonts(with font: UIFont) {
        let baseFontDescriptor = font.fontDescriptor
        var changes = [NSRange: UIFont]()
        enumerateAttribute(.font, in: NSMakeRange(0, length), options: []) { foundFont, range, _ in
            if let htmlTraits = (foundFont as? UIFont)?.fontDescriptor.symbolicTraits,
               let fontSize = (foundFont as? UIFont)?.pointSize,
               let adjustedDescriptor = baseFontDescriptor.withSymbolicTraits(htmlTraits) {
                let newFont = UIFont(descriptor: adjustedDescriptor, size: fontSize)
                changes[range] = newFont
            }
        }
        changes.forEach { range, newFont in
            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)
        }
    }
}
