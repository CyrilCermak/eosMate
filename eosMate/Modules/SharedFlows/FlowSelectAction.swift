//
//  FlowSelectAction.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum FlowSelectActionType {
    case ram, stake
}

enum FlowSelectAction {
    case positive, negative
}

class FlowSelectActionView: UIView {
    let actionSelected = PublishSubject<FlowSelectAction>()
    
    private var type: FlowSelectActionType?
    private let disposeBag = DisposeBag()
    private let positiveActionBtn = UIButton()
    private let negativeActionBtn = UIButton()
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
    }
    
    convenience init(type: FlowSelectActionType) {
        self.init(frame: UIScreen.main.bounds)
        self.type = type
        initView()
        switch type {
        case .ram:
            positiveActionBtn.setBackgroundImage(UIImage(named: "buyRamBtn"), for: .normal)
            negativeActionBtn.setBackgroundImage(UIImage(named: "sellRamBtn"), for: .normal)
        case .stake:
            positiveActionBtn.setBackgroundImage(UIImage(named: "stakeBtn")!, for: .normal)
            negativeActionBtn.setBackgroundImage(UIImage(named: "unstakeBtn")!, for: .normal)
        }
    }
    
    private func initView() {
        [positiveActionBtn, negativeActionBtn].forEach { self.addSubview($0) }
        setBtns()
    }
    
    private func setBtns() {
        guard let type = type else { return }
        switch type {
        case .ram:
            positiveActionBtn.snp.makeConstraints { make in
                make.width.equalTo(285)
                make.height.equalTo(134)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-77)
            }
        case .stake:
            positiveActionBtn.snp.makeConstraints { make in
                make.width.equalTo(175)
                make.height.equalTo(145)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-84)
            }
        }
        negativeActionBtn.snp.makeConstraints { make in
            make.width.height.equalTo(self.positiveActionBtn)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.positiveActionBtn.snp.bottom).offset(20)
        }
        positiveActionBtn.addCellShadow()
        negativeActionBtn.addCellShadow()
        positiveActionBtn.rx.tap.map { FlowSelectAction.positive }.bind(to: actionSelected).disposed(by: disposeBag)
        negativeActionBtn.rx.tap.map { FlowSelectAction.negative }.bind(to: actionSelected).disposed(by: disposeBag)
    }
}

class FlowSelectTransactionView: UIView {
    let actionSelected = PublishSubject<TransactionRequestType>()
    
    private let disposeBag = DisposeBag()
    
    private var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let tokenActionBtn = UIButton()
    private let ramActionBtn = UIButton()
    private let stakeActionBtn = UIButton()
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        initView()
        setButtons()
    }
    
    private func initView() {
        [tokenActionBtn, ramActionBtn, stakeActionBtn].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(145)
            }
        }
        [UIView(), tokenActionBtn, ramActionBtn, stakeActionBtn, UIView()].forEach { buttonStack.addArrangedSubview($0) }
        addSubview(buttonStack)
        setStackView()
    }
    
    private func setStackView() {
        buttonStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.bottom.equalToSuperview()
        }
        
        tokenActionBtn.setBackgroundImage(UIImage(named: "trRequestTokensButton")!, for: .normal)
        ramActionBtn.setBackgroundImage(UIImage(named: "trRequestRamButton")!, for: .normal)
        stakeActionBtn.setBackgroundImage(UIImage(named: "trRequestStakeButton")!, for: .normal)
        
        tokenActionBtn.addCellShadow()
        ramActionBtn.addCellShadow()
        stakeActionBtn.addCellShadow()
    }
    
    private func setButtons() {
        tokenActionBtn.rx.tap.map { TransactionRequestType.tokens }.bind(to: actionSelected).disposed(by: disposeBag)
        ramActionBtn.rx.tap.map { TransactionRequestType.ram }.bind(to: actionSelected).disposed(by: disposeBag)
        stakeActionBtn.rx.tap.map { TransactionRequestType.stake }.bind(to: actionSelected).disposed(by: disposeBag)
    }
}
