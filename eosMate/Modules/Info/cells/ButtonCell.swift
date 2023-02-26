//
//  ButtonCell.swift
//  eosMate
//
//  Created by Cyril on 25/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ButtonCell: UITableViewCell {
    static let height: CGFloat = 60
    let btn = BaseButton(title: "", type: BaseButtonType.shinningBlue)
    
    convenience init(title: String) {
        self.init(style: .default, reuseIdentifier: "ButtonCell")
        set(title: title)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initView()
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func initView() {
        contentView.addSubview(btn)
        backgroundColor = .clear
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(52)
            make.center.equalToSuperview()
        }
    }
    
    func set(title: String) {
        btn.setTitle(title, for: .normal)
    }
}
