//
//  MyAccountCell.swift
//  eosMate
//
//  Created by Cyril on 5/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

protocol MyAccountCellDelegate: AnyObject {
    func didLongTap(account: EOSAccount)
}

class MyAccountCell: UITableViewCell {
    weak var delegate: MyAccountCellDelegate?
    
    static let height: CGFloat = 120
    let inputField = UITextField()
    let accountName = UILabel()
    var account: EOSAccount?
    
    let balance = TitleWithLabelBox(title: AccountFlowLocalization.totalBalance.text,
                                    value: "", style: .light)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [accountName, balance].forEach { self.contentView.addSubview($0) }
        setContentView()
        setAccountName()
        setBalance()
        addLongTapRecognizer()
    }
    
    private func setContentView() {
        contentView.layer.cornerRadius = 10
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: MyAccountCell.height - 20))
        contentView.backgroundColor = UIColor.exDarkBlue()
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func addLongTapRecognizer() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(didLongTap))
        tap.minimumPressDuration = 0.5
        tap.delaysTouchesBegan = true
        addGestureRecognizer(tap)
    }
    
    @objc func didLongTap(gestureReconizer: UILongPressGestureRecognizer) {
        guard let account = account else { return }
        contentView.backgroundColor = UIColor.exShiningBlue()
        if gestureReconizer.state == .ended {
            contentView.backgroundColor = UIColor.exDarkBlue()
            delegate?.didLongTap(account: account)
        }
    }
    
    @objc func didTap(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .began {
            contentView.backgroundColor = UIColor.red
        }
        if gestureRecognizer.state == .ended {
            contentView.backgroundColor = UIColor.exDarkBlue()
        }
    }
    
    private func setAccountName() {
        accountName.font = UIFont.exFontLatoBold(size: 16)
        accountName.textColor = UIColor.white
        accountName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18)
        }
    }
    
    private func setBalance() {
        balance.snp.makeConstraints { make in
            make.top.equalTo(self.accountName.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(44)
        }
    }
    
    func set(account: EOSAccount) {
        self.account = account
        accountName.text = account.accountName
        balance.label.text = account.totalBalanceFormatted
    }
}
