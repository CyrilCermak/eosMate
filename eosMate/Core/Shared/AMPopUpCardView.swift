//
//  AMPopUpCardView.swift
//  eosMate
//
//  Created by Cyril on 19/4/18.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum AMPopUpCardType {
    case yesAndNoButtons, okButton, twoButtons(firstTitle: String, secondTitle: String)
}

class AMPopUpCardView: UIView {
    let container = UIView()
    let topTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let yesBtn = UIButton()
    let cancelBtn = UIButton()
    let okBtn = UIButton()
    let firstBtn = BaseButton(title: "", normalColor: UIColor.exShiningBlue(), touchColor: UIColor.exLightBlue(), titleColor: .white)
    let secondBtn = BaseButton(title: "", normalColor: UIColor.exLightGray(), touchColor: UIColor.exMiddleGray(), titleColor: .white)
    var cardType: AMPopUpCardType!
    let didTapBgView = BehaviorSubject<Void>(value: ())
    
    convenience init(type: AMPopUpCardType) {
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
    
    private func initView(for type: AMPopUpCardType) {
        addSubviews()
        setCurrentView()
        setContainer()
        setTitleLabel()
        setDescriptionLabel()
        switch type {
        case .okButton:
            setOkButton()
        case .yesAndNoButtons:
            setYesButton()
            setCancelButton()
        case let .twoButtons(firstTitle, secondTitle):
            setTwoButtons(firstTitle: firstTitle, secondTitle: secondTitle)
        }
    }
    
    private func addSubviews() {
        [topTitleLabel, descriptionLabel, yesBtn, cancelBtn, okBtn].forEach { self.container.addSubview($0) }
        addSubview(container)
    }
    
    private func setCurrentView() {
        backgroundColor = UIColor.dimsColor()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTouches))
        addGestureRecognizer(gesture)
    }
    
    private func setContainer() {
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.center.equalToSuperview()
            make.height.greaterThanOrEqualTo(170)
        }
        container.backgroundColor = UIColor.exBaseDarkBlue()
        container.layer.cornerRadius = 12
    }
    
    private func setTitleLabel() {
        topTitleLabel.textColor = .white
        topTitleLabel.font = UIFont.exFontLatoSemiBold(size: 24)
        topTitleLabel.numberOfLines = 0
//        topTitleLabel.adjustsFontSizeToFitWidth = true
        topTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalToSuperview().offset(20)
//            make.height.equalTo(26)
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
            switch self.cardType! {
            case .okButton:
                make.bottom.equalTo(self.container).offset(-83)
            case .yesAndNoButtons:
                make.bottom.equalTo(self.container).offset(-83)
            case .twoButtons:
                make.bottom.equalTo(self.container).offset(-136)
            }
        }
    }
    
    private func setYesButton() {
        yesBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(52)
        }
    }
    
    private func setCancelButton() {
        cancelBtn.snp.makeConstraints { make in
            make.right.equalTo(yesBtn.snp.left).offset(-8)
            make.width.height.bottom.equalTo(yesBtn)
        }
    }
    
    private func setOkButton() {
        okBtn.backgroundColor = UIColor.exShiningBlue()
        okBtn.setTitle("Ok", for: .normal)
        okBtn.titleLabel?.textAlignment = .center
        okBtn.layer.cornerRadius = 12
        okBtn.titleLabel?.font = UIFont.exFontLatoSemiBold(size: 18)
        okBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }
    }
    
    private func setTwoButtons(firstTitle: String, secondTitle: String) {
        container.addSubview(firstBtn)
        container.addSubview(secondBtn)
        firstBtn.setTitle(firstTitle, for: .normal)
        firstBtn.titleLabel?.textAlignment = .center
        firstBtn.layer.cornerRadius = 12
        firstBtn.titleLabel?.font = UIFont.exFontLatoSemiBold(size: 18)
        firstBtn.snp.makeConstraints { make in
            make.left.right.equalTo(self.secondBtn)
            make.height.equalTo(44)
            make.bottom.equalTo(self.secondBtn.snp.top).offset(-12)
        }
        secondBtn.setTitle(secondTitle, for: .normal)
        secondBtn.titleLabel?.textAlignment = .center
        secondBtn.layer.cornerRadius = 12
        secondBtn.titleLabel?.font = UIFont.exFontLatoSemiBold(size: 18)
        secondBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }
    }
    
    func set(title: String, description: String) {
        topTitleLabel.text = title
        descriptionLabel.text = description
    }
    
    @objc func handleTouches() {
        didTapBgView.onNext(())
    }
}
