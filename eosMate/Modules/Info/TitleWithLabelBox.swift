//
//  TitleWithLabelBox.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

enum TitleWithLabelBoxStyle {
    case light, dark
}

class TitleWithLabelBox: UIView {
    static let preferredHeight: CGFloat = 45
    
    let titleLabel = UILabel()
    let label = UILabel()
    var style: TitleWithLabelBoxStyle = .dark
    
    convenience init(title: String, value: String?, style: TitleWithLabelBoxStyle = .dark) {
        self.init(frame: CGRect.zero)
        titleLabel.text = title
        label.text = value
        self.style = style
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [titleLabel, label].forEach { self.addSubview($0) }
        setView()
        setTitle()
        setLabel()
    }
    
    private func setView() {
        layer.cornerRadius = 10
        switch style {
        case .light:
            backgroundColor = UIColor.exShiningBlue()
        case .dark:
            backgroundColor = UIColor.exDarkGray()
        }
    }
    
    private func setTitle() {
        titleLabel.font = UIFont.exFontLatoBold(size: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    private func setLabel() {
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.exFontLatoRegular(size: 14)
        label.snp.makeConstraints { make in
            make.left.right.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
        }
    }
}
