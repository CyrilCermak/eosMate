//
//  AMPopUpInputCardView.swift
//  eosMate
//
//  Created by Cyril on 10/11/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum AMPopUpInputCardType {
    case buttonTitles(confirm: String, cancel: String)
}

class AMPopUpCardInputView: UIView {
    let container = UIView()
    let topTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let yesBtn = UIButton()
    let cancelBtn = UIButton()
    var cardType: AMPopUpInputCardType!
    let textView = UITextView()
    let disposeBag = DisposeBag()
    
    convenience init(type: AMPopUpInputCardType) {
        self.init(frame: CGRect.zero)
        cardType = type
        initView(for: type)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(for type: AMPopUpInputCardType) {
        addSubviews()
        setCurrentView()
        setContainer()
        setTitleLabel()
        setDescriptionLabel()
        setYesButton()
        setCancelButton()
        setInputView()
    }
    
    private func addSubviews() {
        [topTitleLabel, descriptionLabel, textView, yesBtn, cancelBtn].forEach { self.container.addSubview($0) }
        addSubview(container)
    }
    
    private func setCurrentView() {
        backgroundColor = UIColor.dimsColor()
    }
    
    private func setContainer() {
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(isSmallIPhone ? 18 : screenSize.height / 7)
            make.height.greaterThanOrEqualTo(280)
        }
        container.backgroundColor = UIColor.exBaseDarkBlue()
        container.layer.cornerRadius = 12
    }
    
    private func setTitleLabel() {
        topTitleLabel.textColor = .white
        topTitleLabel.font = UIFont.exFontLatoSemiBold(size: 24)
        topTitleLabel.numberOfLines = 0
        topTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    private func setInputView() {
        textView.applyBaseStyling()
        textView.addPasteFromClipboardBtn()
        textView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self.yesBtn.snp.top).offset(-10)
            make.left.right.equalTo(self.descriptionLabel)
        }
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.textColor = UIColor.exLightGray()
        descriptionLabel.font = UIFont.exFontLatoSemiBold(size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.topTitleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self.topTitleLabel)
        }
    }
    
    private func setYesButton() {
        yesBtn.setImage(UIImage(named: "popUpOkBtn"), for: .normal)
        yesBtn.layer.cornerRadius = 26
        yesBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(52)
        }
    }
    
    private func setCancelButton() {
        cancelBtn.setImage(UIImage(named: "popUpCancelBtn"), for: .normal)
        cancelBtn.layer.cornerRadius = 26
        cancelBtn.snp.makeConstraints { make in
            make.right.equalTo(yesBtn.snp.left).offset(-8)
            make.width.height.bottom.equalTo(yesBtn)
        }
    }
    
    func set(title: String, description: String) {
        topTitleLabel.text = title
        descriptionLabel.text = description
    }
}
