//
//  InputCell.swift
//  eosMate
//
//  Created by Cyril Cermak on 07.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class UnlimitedInfoCell: UITableViewCell {
    static let height: CGFloat = UITableViewAutomaticDimension
    
    private let unlimitedTextLabel = UILabel()
    private let infoLabel = UILabel()
    private let container = UIView()
    
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
        setUnlimitedTextLabel()
    }
    
    private func setContentView() {
        contentView.addSubview(container)
        container.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        container.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.layer.cornerRadius = 10
        container.backgroundColor = UIColor.exDarkBlue()
        container.addCellShadow(for: CGSize(width: screenSize.width - 30, height: frame.height - 20))
    }
    
    private func setUnlimitedTextLabel() {
        container.addSubview(unlimitedTextLabel)
        unlimitedTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        unlimitedTextLabel.numberOfLines = 0
        unlimitedTextLabel.textColor = UIColor.white
        unlimitedTextLabel.font = UIFont.exFontLatoRegular(size: 14)
        unlimitedTextLabel.tintColor = .white
    }
    
    private func setHelperLabel() {
        container.addSubview(infoLabel)
        infoLabel.textColor = UIColor.white
        infoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        infoLabel.font = UIFont.exFontLatoBold(size: 14)
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    func set(text: String, withInfo info: String) {
        unlimitedTextLabel.text = text
            .replacingOccurrences(of: ", ", with: ",\n")
            .replacingOccurrences(of: ",", with: ",\n")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "\" ", with: "")
            .replacingOccurrences(of: "\"", with: "")
        infoLabel.text = info
    }
}
