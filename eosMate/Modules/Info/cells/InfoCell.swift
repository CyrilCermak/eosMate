//
//  InfoCell.swift
//  eosMate
//
//  Created by Cyril on 2/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class InfoCell: UITableViewCell {
    static let height: CGFloat = 178
    
    let topStack = UIStackView()
    let bottomStack = UIStackView()
    let eosPrice = TitleWithLabelBox(title: InfoLocalization.eosPrice.text,
                                     value: "",
                                     style: .light)
    
    let ramPrice = TitleWithLabelBox(title: InfoLocalization.ramPrice.text,
                                     value: "")
    
    let high24 = ImageWithLabelBox(imageName: nil,
                                   value: "",
                                   style: .darkWith(title: InfoLocalization.high24h.text))
    
    let change24 = ImageWithLabelBox(imageName: nil,
                                     value: "",
                                     style: .lightWith(title: InfoLocalization.change.text))
    
    let low24 = ImageWithLabelBox(imageName: nil,
                                  value: "",
                                  style: .darkWith(title: InfoLocalization.low24h.text))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        addViews()
        setContentView()
        setTopStack()
        setBottomStack()
    }
    
    private func addViews() {
        [topStack, bottomStack].forEach { self.contentView.addSubview($0) }
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: InfoCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
    }
    
    private func setTopStack() {
        topStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(self.bottomStack.snp.top).offset(-12)
            make.height.equalTo(TitleWithLabelBox.preferredHeight)
        }
        
        topStack.alignment = .center
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually
        topStack.spacing = 12
        
        [eosPrice, ramPrice].forEach {
            topStack.addArrangedSubview($0)
            $0.snp.makeConstraints { $0.height.equalTo(topStack.snp.height) }
        }
    }
    
    private func setBottomStack() {
        bottomStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(75)
        }
        bottomStack.alignment = .center
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 12
        
        [high24, change24, low24].forEach {
            bottomStack.addArrangedSubview($0)
            $0.snp.makeConstraints { $0.height.equalTo(bottomStack.snp.height) }
        }
    }
    
    func set(eosMarket: EOSMarket?, ramPrice: String) {
        eosPrice.label.text = "\(eosMarket?.currentRoundedPrice ?? 0.0) USD"
        high24.label.text = "\(eosMarket?.high24H?.roundToTwoDecimal() ?? 0.0) USD"
        low24.label.text = "\(eosMarket?.low24H?.roundToTwoDecimal() ?? 0.0) USD"
        change24.label.text = "\(eosMarket?.priceChangePercentage24H?.roundToTwoDecimal() ?? 0.0) %"
        self.ramPrice.label.text = ramPrice
    }
}
