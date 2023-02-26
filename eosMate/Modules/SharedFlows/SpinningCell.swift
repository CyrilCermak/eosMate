//
//  SpinningCell.swift
//  eosMate
//
//  Created by Cyril on 21/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class SpinningCell: UITableViewCell {
    let spinner = UIActivityIndicatorView()
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setView()
    }
    
    private func setView() {
        contentView.addSubview(spinner)
        spinner.color = UIColor.exWhite()
        spinner.startAnimating()
        spinner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
