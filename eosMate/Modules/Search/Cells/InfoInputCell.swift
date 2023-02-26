//
//  InfoCell.swift
//  eosMate
//
//  Created by Cyril on 1/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

protocol CellHeightRepresentable: UITableViewCell {
    static var height: CGFloat { get }
}

class InfoInputCell: UITableViewCell, CellHeightRepresentable {
    static let height: CGFloat = 72
    let inputField = UITextField()
    let inputInfoLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        setContentView()
        setHelperLabel()
        setTextField()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: SearchInputCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
    }
    
    private func setTextField() {
        contentView.addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(inputInfoLabel.snp.right).offset(10)
            make.bottom.equalToSuperview()
        }
        inputField.autocorrectionType = .yes
        inputField.textColor = UIColor.white
        inputField.font = UIFont.exFontLatoRegular(size: 14)
        inputField.keyboardAppearance = .dark
        inputField.returnKeyType = .search
        inputField.tintColor = .white
        inputField.isUserInteractionEnabled = false
    }
    
    private func setHelperLabel() {
        contentView.addSubview(inputInfoLabel)
        inputInfoLabel.textColor = UIColor.white
        inputInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        inputInfoLabel.font = UIFont.exFontLatoBold(size: 14)
        inputInfoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func set(text: String, withInfo info: String) {
        inputField.text = text
        inputInfoLabel.text = info
    }
}
