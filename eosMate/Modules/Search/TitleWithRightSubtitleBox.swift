//
//  TitleWithRightSubtitle.swift
//  eosMate
//
//  Created by Cyril on 5/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class TitleWithRightSubtitleBox: UIView {
    static let preferredHeight: CGFloat = 35
    
    let titleLabel = UILabel()
    let label = UILabel()
    let spinner = UIActivityIndicatorView()
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
        [titleLabel, label, spinner].forEach { self.addSubview($0) }
        setView()
        setTitle()
        setLabel()
        setSpinner()
    }
    
    private func setView() {
        layer.cornerRadius = 10
        switch style {
        case .light:
            backgroundColor = UIColor.exLightGray()
        case .dark:
            backgroundColor = UIColor.exDarkGray()
        }
    }
    
    private func setTitle() {
        titleLabel.font = UIFont.exFontLatoBold(size: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(18)
        }
    }
    
    private func setLabel() {
        label.textColor = UIColor.white
        label.font = UIFont.exFontLatoRegular(size: 14)
        label.textAlignment = .right
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(18)
        }
    }
    
    private func setSpinner() {
        spinner.color = .white
        spinner.startAnimating()
        spinner.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
}
