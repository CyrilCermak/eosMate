//
//  TransactionCell.swift
//  eosMate
//
//  Created by Cyril on 10/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class TransactionCell: UITableViewCell {
    static let height: CGFloat = 150
    
    let dateLabel = UILabel()
    let typeIcon = UIImageView()
    let memoLabel = UILabel()
    let transaction = TitleWithLabelBox(title: "", value: "", style: .light)

    var longTapPressed: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func initView() {
        [dateLabel, typeIcon, memoLabel, transaction].forEach { self.contentView.addSubview($0) }
        setContentView()
        setDateLabel()
        setStateLabel()
        setTransaction()
        setMemo()
    }
    
    private func setContentView() {
        contentView.layer.cornerRadius = 10
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: TransactionCell.height - 20))
        contentView.backgroundColor = UIColor.exDarkBlue()
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setStateLabel() {
        typeIcon.contentMode = .scaleAspectFit
        typeIcon.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(16)
            make.width.equalTo(20)
        }
    }
    
    private func setDateLabel() {
        dateLabel.textColor = .white
        dateLabel.font = UIFont.exFontLatoRegular(size: 11)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(typeIcon)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(16)
        }
    }
    
    private func setTransaction() {
        transaction.snp.makeConstraints { make in
            make.top.equalTo(self.typeIcon.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(44)
        }
    }
    
    private func setMemo() {
        memoLabel.textColor = .white
        memoLabel.font = UIFont.exFontLatoRegular(size: 14)
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.transaction.snp.bottom).offset(10)
            make.left.right.equalTo(self.transaction)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func set(tr: Transfer, transaction: EOSXTransaction, accountName: String) {
        self.transaction.label.text = tr.quantity
        memoLabel.text = tr.memo
        dateLabel.text = transaction.formattedDate ?? ""
        if accountName == tr.from {
            self.transaction.titleLabel.text = tr.to
            typeIcon.image = UIImage(named: "arrowDown")
            self.transaction.backgroundColor = UIColor.exDarkGray()
        } else {
            self.transaction.titleLabel.text = tr.from
            typeIcon.image = UIImage(named: "arrowUp")
            self.transaction.backgroundColor = UIColor.exShiningBlue()
        }
    }
    
    func set(buyRam: BuyRam, transaction: EOSXTransaction, accountName: String) {
        typeIcon.image = UIImage(named: "iconRAM")
        
        self.transaction.label.text = buyRam.quant
        memoLabel.text = "from: " + buyRam.payer
        dateLabel.text = transaction.formattedDate ?? ""
        self.transaction.titleLabel.text = buyRam.receiver
        self.transaction.backgroundColor = UIColor.exShiningBlue()
    }
    
    func set(sellRam: SellRam, transaction: EOSXTransaction, accountName: String) {
        typeIcon.image = UIImage(named: "iconRAM")
        
        self.transaction.label.text = "Sold: \(sellRam.bytes) bytes"
        memoLabel.text = ""
        dateLabel.text = transaction.formattedDate ?? ""
        self.transaction.titleLabel.text = sellRam.account
        self.transaction.backgroundColor = UIColor.exDarkGray()
    }
    
    func set(stake: StakeTransfer, transaction: EOSXTransaction, accountName: String) {
        typeIcon.image = UIImage(named: "iconCPU")
        
        memoLabel.text = "from: " + stake.from
        dateLabel.text = transaction.formattedDate ?? ""
        self.transaction.titleLabel.text = stake.receiver
        self.transaction.label.text = "Net: \(stake.stakeNetQuantity), CPU: \(stake.stakeCpuQuantity)"
        self.transaction.backgroundColor = UIColor.exShiningBlue()
    }
    
    func set(unstake: UnstakeTransfer, transaction: EOSXTransaction, accountName: String) {
        typeIcon.image = UIImage(named: "iconCPU")
        
        memoLabel.text = "to: " + unstake.receiver
        dateLabel.text = transaction.formattedDate ?? ""
        self.transaction.titleLabel.text = unstake.from
        self.transaction.label.text = "Net: \(unstake.unstakeNetQuantity), CPU: \(unstake.unstakeCpuQuantity)"
        self.transaction.backgroundColor = UIColor.exDarkGray()
    }
    
    func set(toWith: ToWithMessage, transaction: EOSXTransaction, accountName: String) {
        typeIcon.image = UIImage(named: "iconChain")
        
        memoLabel.text = ""
        dateLabel.text = transaction.formattedDate ?? ""
        self.transaction.titleLabel.text = transaction.account ?? ""
        self.transaction.label.text = toWith.message
        self.transaction.backgroundColor = UIColor.exShiningBlue()
    }
    
    func set(unknown transaction: EOSXTransaction, accountName: String) {
        typeIcon.image = UIImage(named: "iconChain")
            
        memoLabel.text = ""
        dateLabel.text = transaction.formattedDate ?? ""
        self.transaction.titleLabel.text = transaction.account ?? ""
        if let dict = transaction.payload as? [String: Any] {
            let longestString = dict.values.map { String(describing: $0) }.max(by: { $0.count < $1.count })
            memoLabel.text = longestString
            let string = dict.map { "\($0): \($1)" }.joined(separator: ", ")
            self.transaction.label.text = string
        }
        
        self.transaction.backgroundColor = UIColor.exShiningBlue()
    }
    
    func set(pendingTransaction: TransactionRequest) {
        typeIcon.image = UIImage(named: "iconChain")
        memoLabel.text = pendingTransaction.parameters
        transaction.titleLabel.text = pendingTransaction.accountName
        transaction.label.text = "\(pendingTransaction.action), \(pendingTransaction.tableName)"
        transaction.backgroundColor = UIColor.exShiningBlue()
    }
    
    func set(pendingTransaction: MateTransactionRequest) {
        typeIcon.image = UIImage(named: "iconChain")
        
        if let data = Data(base64Encoded: pendingTransaction.parameters), let string = String(data: data, encoding: .utf8) {
            memoLabel.text = string
        }
        transaction.titleLabel.text = pendingTransaction.accountName
        transaction.label.text = "\(pendingTransaction.action), \(pendingTransaction.tableName)"
        transaction.backgroundColor = UIColor.exShiningBlue()
    }
    
    func addLongTapRecognizer() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(didLongTap))
        tap.minimumPressDuration = 0.5
        tap.delaysTouchesBegan = true
        contentView.addGestureRecognizer(tap)
    }
    
    @objc func didLongTap(gestureReconizer: UILongPressGestureRecognizer) {
        contentView.backgroundColor = UIColor.exShiningBlue()
        if gestureReconizer.state == .ended {
            contentView.backgroundColor = UIColor.exDarkBlue()
            longTapPressed?()
        }
    }
}
