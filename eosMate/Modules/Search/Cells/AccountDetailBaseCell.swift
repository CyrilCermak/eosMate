//
//  AccountDetailBaseCell.swift
//  eosMate
//
//  Created by Cyril on 29/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailBaseCell: UITableViewCell {
    static let height: CGFloat = 262
    let inputField = UITextField()
    
    let balance = TitleWithLabelBox(title: SearchLocalization.totalBalance.text,
                                    value: "",
                                    style: .dark)
    let cpu = ImageWithLabelBox(imageName: "iconCPU", value: "")
    let ram = ImageWithLabelBox(imageName: "iconRAM", value: "", style: .light)
    let net = ImageWithLabelBox(imageName: "iconNetwork", value: "")
    
    let staked = ImageWithLabelBox(imageName: nil,
                                   value: "",
                                   style: .darkWith(title: SearchLocalization.staked.text))
    let unstaked = ImageWithLabelBox(imageName: nil,
                                     value: "",
                                     style: .lightWith(title: SearchLocalization.unstaked.text))
    let privileged = ImageWithLabelBox(imageName: nil,
                                       value: "",
                                       style: .darkWith(title: SearchLocalization.privileged.text))
    
    let bottomStack = UIStackView()
    let topStack = UIStackView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [balance, topStack, bottomStack].forEach { self.contentView.addSubview($0) }
        setBalance()
        setContentView()
        setTopStack()
        setBottomStack()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: AccountDetailBaseCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
    }
    
    private func setBalance() {
        balance.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalTo(self.topStack)
            make.height.equalTo(44)
        }
    }
    
    private func setTopStack() {
        initializeBase(stack: topStack)
        topStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(self.balance.snp.bottom).offset(12)
            make.height.equalTo(75)
        }
        
        [cpu, ram, net].forEach {
            topStack.addArrangedSubview($0)
            $0.snp.makeConstraints { $0.height.equalTo(bottomStack.snp.height) }
        }
    }
    
    private func setBottomStack() {
        initializeBase(stack: bottomStack)
        bottomStack.snp.makeConstraints { make in
            make.left.right.height.equalTo(self.topStack)
            make.top.equalTo(self.topStack.snp.bottom).offset(12)
        }
        
        [staked, unstaked, privileged].forEach {
            bottomStack.addArrangedSubview($0)
            $0.snp.makeConstraints { $0.height.equalTo(bottomStack.snp.height) }
        }
    }
    
    private func initializeBase(stack: UIStackView) {
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
    }
    
    func set(account: EOSAccount) {
        balance.label.text = "\(account.totalBalance ?? 0) EOS"
        ram.label.text = "\((Double(account.ramUsage ?? 1) / 1024).rounded())/\((Double(account.ramQuota ?? 1) / 1024).rounded()) kb"
        cpu.label.text = "\(account.convertedCPUWeight ?? 0)"
        net.label.text = "\(account.convertedNetWeight ?? 0)"
        
        staked.label.text = "\(account.staked ?? 0)"
        unstaked.label.text = "\(account.unstaked ?? 0)"
        privileged.label.text = "\(account.privileged?.description.uppercased() ?? "")"
    }
}
