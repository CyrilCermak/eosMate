//
//  BaseHtmlContentView.swift
//  eosMate
//
//  Created by Cyril Cermak on 14.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit
import SnapKit

class BaseHtmlContentView: UIView {
    private let textView = UITextView()
    var text: NSAttributedString? { didSet { textView.attributedText = text } }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.exDarkBlue()
        
        initView()
        textView.isEditable = false
    }
    
    private func initView() {
        [textView].forEach { self.addSubview($0) }
        setTextView()
    }
    
    private func setTextView() {
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.exFontLatoRegular(size: 14)
        textView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
