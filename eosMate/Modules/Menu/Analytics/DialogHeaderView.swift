//
//  DialogHeaderView.swift
//  eosMate
//
//  Created by Cyril Cermak on 14.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class DialogHeaderView: UIView {
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.exFontLatoSemiBold(size: 32)
        label.textColor = UIColor.exWhite()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
        
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.exFontLatoRegular(size: 16)
        label.textColor = UIColor.exWhite()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    @available(*, unavailable)  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func initView() {
        [headerLabel, subtitleLabel].forEach { self.addSubview($0) }
        backgroundColor = UIColor.clear
        setHeaderLabel()
        setSubtitleLabel()
    }
    
    private func setHeaderLabel() {
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24).priority(.high)
        }
    }
    
    private func setSubtitleLabel() {
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.headerLabel)
            make.top.equalTo(self.headerLabel.snp.bottom).offset(12)
        }
    }
    
    func set(header: String, subtitle: String, alignment: NSTextAlignment) {
        headerLabel.text = header
        subtitleLabel.text = subtitle
        [headerLabel, subtitleLabel].forEach { $0.textAlignment = alignment }
    }
}
