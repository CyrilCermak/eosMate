//
//  UITextView+.swift
//  eosMate
//
//  Created by Cyril on 11/11/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func applyBaseStyling() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        autocorrectionType = .no
        textColor = UIColor.white
        font = UIFont.exFontLatoBold(size: 13)
        keyboardAppearance = .dark
        layer.borderColor = UIColor.exLightGray().cgColor
        layer.borderWidth = 1
        tintColor = .white
    }
    
    func addPasteFromClipboardBtn() {
        let btn = BaseButton(title: CoreLocalization.pasteFromClipboard.text,
                             normalColor: UIColor.exDarkGray(),
                             touchColor: UIColor.exMiddleGray(),
                             titleColor: UIColor.white)
        btn.layer.cornerRadius = 0
        btn.addTarget(self, action: #selector(pasteCliboard), for: .touchUpInside)
        inputAccessoryView = btn
    }
    
    @objc func pasteCliboard() {
        text = UIPasteboard.general.string
    }
}
