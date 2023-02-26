//
//  MyAccountSimpleCell.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MyAccountSimpleCell: UITableViewCell, TappableCell {
    weak var delegate: MyAccountCellDelegate?
    
    static let height: CGFloat = 72
    
    var disposeBag = DisposeBag()
    var tappedContetnViewColor: UIColor = .exLightGray()
    var baseContentViewColor: UIColor = .exDarkBlue()
    let accountName = UILabel()
    let accountAmount = UILabel()
    var account: EOSAccount?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [accountName, accountAmount].forEach { self.contentView.addSubview($0) }
        setContentView()
        setAccountName()
        setAccountAmount()
        addLongTapRecognizer()
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
    
    private func setContentView() {
        contentView.layer.cornerRadius = 10
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: MyAccountSimpleCell.height - 20))
        contentView.backgroundColor = baseContentViewColor
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setAccountName() {
        accountName.font = UIFont.exFontLatoBold(size: 16)
        accountName.textColor = UIColor.white
        accountName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(18)
        }
    }
    
    private func setAccountAmount() {
        accountAmount.font = UIFont.exFontLatoRegular(size: 16)
        accountAmount.textAlignment = .right
        accountAmount.textColor = UIColor.white
        accountAmount.snp.makeConstraints { make in
            make.centerY.equalTo(self.accountName)
            make.height.equalTo(self.accountName)
            make.left.equalTo(self.accountName.snp.right).offset(10)
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    func set(account: EOSAccount) {
        self.account = account
        accountName.text = account.accountName?.uppercased()
        accountAmount.text = account.totalBalanceFormatted
    }
}
